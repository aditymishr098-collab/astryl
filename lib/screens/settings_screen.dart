import 'package:flutter/material.dart';

import '../data/backup.dart';
import '../data/build_flavor.dart';
import '../data/settings.dart';
import '../l10n/names.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'update_dialog.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const String _sourceUrl = 'https://github.com/aditymishr098-collab/astryl';

  Future<void> _checkUpdates(BuildContext context) async {
    final l = context.l10n;
    final state = AppScope.read(context);
    final messenger = ScaffoldMessenger.of(context);
    final (result, info) = await state.checkForUpdate();
    if (!context.mounted) {
      return;
    }
    switch (result) {
      case UpdateCheckResult.newer:
        await showUpdateDialog(context, info!);
      case UpdateCheckResult.upToDate:
        messenger.showSnackBar(SnackBar(content: Text(l.upToDate)));
      case UpdateCheckResult.failed:
        messenger.showSnackBar(SnackBar(content: Text(l.updateFailed)));
    }
  }

  Future<void> _open(BuildContext context, String url) async {
    final l = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final opened = await AppScope.read(context).bridge.openUrl(url);
    if (!opened) {
      messenger.showSnackBar(SnackBar(content: Text(l.openFailed)));
    }
  }

  Future<void> _toggleTonight(BuildContext context, bool value) async {
    final l = context.l10n;
    final state = AppScope.read(context);
    final messenger = ScaffoldMessenger.of(context);
    if (value && !await state.bridge.requestNotifications()) {
      messenger.showSnackBar(SnackBar(content: Text(l.notificationsOff)));
      return;
    }
    await state.setTonightAlert(value);
  }

  Future<void> _pickTonightTime(BuildContext context) async {
    final state = AppScope.read(context);
    final minutes = state.settings.tonightMinutes;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60),
    );
    if (picked != null) {
      await state.setTonightMinutes(picked.hour * 60 + picked.minute);
    }
  }

  Future<void> _saveBackup(BuildContext context) async {
    final l = context.l10n;
    final state = AppScope.read(context);
    final messenger = ScaffoldMessenger.of(context);
    final path = await state.writeBackup();
    final shared = path != null &&
        await state.bridge
            .shareFile(path, 'application/json', l.backupShareText);
    if (!shared) {
      messenger.showSnackBar(SnackBar(content: Text(l.backupSaveFailed)));
    }
  }

  Future<void> _restoreBackup(BuildContext context) async {
    final l = context.l10n;
    final state = AppScope.read(context);
    final messenger = ScaffoldMessenger.of(context);
    final text = await state.bridge.pickBackup();
    if (text == null) {
      return;
    }
    if (!isHelioraBackup(text)) {
      messenger.showSnackBar(SnackBar(content: Text(l.backupBad)));
      return;
    }
    if (!context.mounted) {
      return;
    }
    final yes = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l.backupRestoreTitle),
        content: Text(l.backupRestoreAsk),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l.backupRestoreConfirm),
          ),
        ],
      ),
    );
    if (yes != true) {
      return;
    }
    final done = await state.restoreBackup(text);
    messenger.showSnackBar(
        SnackBar(content: Text(done ? l.backupRestored : l.backupBad)));
  }

  Future<void> _pickLanguage(BuildContext context) async {
    final l = context.l10n;
    final state = AppScope.read(context);
    final current = state.settings.localeCode;
    final picked = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        final p = Palette.of(sheetContext);
        Widget tile(String code, String name) {
          final on = code == current;
          return ListTile(
            title: Text(name,
                style: TextStyle(
                    color: p.text,
                    fontWeight: on ? FontWeight.w700 : FontWeight.w400)),
            trailing: on ? Icon(Icons.check, color: p.accentText) : null,
            onTap: () => Navigator.of(sheetContext).pop(code),
          );
        }

        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          maxChildSize: 0.95,
          builder: (context, controller) => ListView(
            controller: controller,
            children: <Widget>[
              tile('', l.phoneLanguage),
              for (final (code, name) in appLanguages) tile(code, name),
            ],
          ),
        );
      },
    );
    if (picked != null) {
      await state.setLocaleCode(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = Palette.of(context);
    final state = AppScope.of(context);
    final settings = state.settings;
    final languageLabel = settings.localeCode.isEmpty
        ? l.phoneLanguage
        : languageName(settings.localeCode);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.settings,
            style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: <Widget>[
          SectionLabel(l.appearance),
          SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(l.theme,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: p.text)),
                const SizedBox(height: 12),
                SegmentedButton<ThemeMode>(
                  showSelectedIcon: false,
                  segments: <ButtonSegment<ThemeMode>>[
                    ButtonSegment<ThemeMode>(
                        value: ThemeMode.system, label: Text(l.themeSystem)),
                    ButtonSegment<ThemeMode>(
                        value: ThemeMode.light, label: Text(l.themeLight)),
                    ButtonSegment<ThemeMode>(
                        value: ThemeMode.dark, label: Text(l.themeDark)),
                  ],
                  selected: <ThemeMode>{settings.themeMode},
                  onSelectionChanged: (set) => state.setThemeMode(set.first),
                  style: SegmentedButton.styleFrom(
                    selectedBackgroundColor: p.accent,
                    selectedForegroundColor: p.onAccent,
                    foregroundColor: p.text,
                    side: BorderSide(color: p.border),
                  ),
                ),
                const SizedBox(height: 20),
                Text(l.textSize,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: p.text)),
                const SizedBox(height: 12),
                SegmentedButton<int>(
                  showSelectedIcon: false,
                  segments: <ButtonSegment<int>>[
                    ButtonSegment<int>(
                        value: textScaleChoices[0],
                        label: Text(l.textSizeNormal)),
                    ButtonSegment<int>(
                        value: textScaleChoices[1],
                        label: Text(l.textSizeLarge)),
                    ButtonSegment<int>(
                        value: textScaleChoices[2],
                        label: Text(l.textSizeLarger)),
                  ],
                  selected: <int>{settings.textScalePercent},
                  onSelectionChanged: (set) => state.setTextScale(set.first),
                  style: SegmentedButton.styleFrom(
                    selectedBackgroundColor: p.accent,
                    selectedForegroundColor: p.onAccent,
                    foregroundColor: p.text,
                    side: BorderSide(color: p.border),
                  ),
                ),
                const SizedBox(height: 8),
                Text(l.textSizeNote,
                    style: TextStyle(fontSize: 12, color: p.muted, height: 1.4)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SectionLabel(l.language),
          SurfaceCard(
            padding: EdgeInsets.zero,
            child: ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              title: Text(l.appLanguage, style: TextStyle(color: p.text)),
              subtitle: Text(l.languageNote,
                  style: TextStyle(fontSize: 12, color: p.muted)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(languageLabel, style: TextStyle(color: p.muted)),
                  Icon(Icons.chevron_right, color: p.muted),
                ],
              ),
              onTap: () => _pickLanguage(context),
            ),
          ),
          const SizedBox(height: 20),
          SectionLabel(l.alertsTitle),
          SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l.tonightAlertSwitch,
                      style: TextStyle(fontSize: 15, color: p.text)),
                  value: settings.tonightAlert,
                  onChanged: (value) => _toggleTonight(context, value),
                ),
                if (settings.tonightAlert)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l.tonightAlertTime,
                        style: TextStyle(fontSize: 15, color: p.text)),
                    trailing: Text(
                      MaterialLocalizations.of(context).formatTimeOfDay(
                          TimeOfDay(
                              hour: settings.tonightMinutes ~/ 60,
                              minute: settings.tonightMinutes % 60)),
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: p.accentText),
                    ),
                    onTap: () => _pickTonightTime(context),
                  ),
                Text(l.tonightAlertNote,
                    style:
                        TextStyle(fontSize: 12, color: p.muted, height: 1.4)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SectionLabel(l.onlineTitle),
          SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l.onlineTitle,
                      style: TextStyle(fontSize: 15, color: p.text)),
                  value: settings.onlineFeatures,
                  onChanged: state.setOnlineFeatures,
                ),
                Text(l.onlineSubtitle,
                    style:
                        TextStyle(fontSize: 12, color: p.muted, height: 1.4)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SectionLabel(l.backupTitle),
          SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(l.backupNote,
                    style:
                        TextStyle(fontSize: 13, color: p.muted, height: 1.4)),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48)),
                  onPressed: () => _saveBackup(context),
                  icon: const Icon(Icons.upload_file_outlined),
                  label: Text(l.backupSave),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48)),
                  onPressed: () => _restoreBackup(context),
                  icon: const Icon(Icons.download_outlined),
                  label: Text(l.backupRestore),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SectionLabel(l.updates),
          SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(l.version,
                            style: TextStyle(fontSize: 15, color: p.text))),
                    Text(state.appVersion.isEmpty ? '-' : state.appVersion,
                        style: TextStyle(color: p.muted)),
                  ],
                ),
                // The F-Droid build is updated by F-Droid, never by the app.
                if (inAppUpdates) ...<Widget>[
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      backgroundColor: p.orbit,
                      foregroundColor: Theme.of(context).brightness ==
                              Brightness.dark
                          ? p.background
                          : Colors.white,
                    ),
                    onPressed: state.checkingForUpdate
                        ? null
                        : () => _checkUpdates(context),
                    icon: state.checkingForUpdate
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.refresh),
                    label: Text(state.checkingForUpdate
                        ? l.checking
                        : l.checkForUpdates),
                  ),
                  const SizedBox(height: 4),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l.autoUpdateCheck,
                        style: TextStyle(fontSize: 14, color: p.text)),
                    value: settings.autoUpdateCheck,
                    onChanged: state.setAutoUpdateCheck,
                  ),
                  Text(l.updateNote,
                      style:
                          TextStyle(fontSize: 12, color: p.muted, height: 1.4)),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          SectionLabel(l.about),
          SurfaceCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: <Widget>[
                ListTile(
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  title: Text(l.sourceCode, style: TextStyle(color: p.text)),
                  trailing: Icon(Icons.open_in_new, color: p.muted, size: 20),
                  onTap: () => _open(context, _sourceUrl),
                ),
                const Divider(),
                ListTile(
                  title: Text(l.privacyLine, style: TextStyle(color: p.text)),
                  subtitle: Text(l.dataSource,
                      style: TextStyle(fontSize: 12, color: p.muted)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
