import 'dart:io';

import 'package:flutter/material.dart';

import '../core/format.dart';
import '../data/update_service.dart';
import '../l10n/names.dart';
import '../state/app_state.dart';
import '../theme.dart';

/// Tells the user a newer version is out and updates the app from inside:
/// the signed APK is downloaded from the GitHub release with a progress bar,
/// then the Android installer opens. Installing over the current app keeps
/// all settings, because the APK is signed with the same key.
Future<void> showUpdateDialog(BuildContext context, UpdateInfo info) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _UpdateDialog(info: info),
  );
}

enum _Stage { ready, downloading, downloaded, permission, failed }

class _UpdateDialog extends StatefulWidget {
  const _UpdateDialog({required this.info});

  final UpdateInfo info;

  @override
  State<_UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<_UpdateDialog> {
  _Stage _stage = _Stage.ready;
  double? _progress;
  String? _path;
  bool _cancelled = false;

  bool get _canInstallInApp {
    final apk = widget.info.apkUrl;
    return apk != null && UpdateService.isTrustedDownload(apk);
  }

  @override
  void dispose() {
    _cancelled = true;
    super.dispose();
  }

  Future<void> _download() async {
    final bridge = AppScope.read(context).bridge;
    setState(() {
      _stage = _Stage.downloading;
      _progress = null;
    });
    try {
      final dir = await bridge.updatesDir();
      if (dir.isEmpty) {
        throw const FileSystemException('No updates folder');
      }
      final path = '$dir${Platform.pathSeparator}'
          'Astryl-${widget.info.version}.apk';

      // Remove older downloads so the cache does not fill up.
      await for (final entry in Directory(dir).list()) {
        if (entry is File && entry.path != path) {
          await entry.delete();
        }
      }

      final file = File(path);
      if (!await file.exists() || await file.length() < 1000000) {
        await UpdateService().download(widget.info.apkUrl!, path, (value) {
          if (!_cancelled && mounted) {
            setState(() => _progress = value);
          }
        });
      }
      if (_cancelled || !mounted) {
        return;
      }
      _path = path;
      setState(() => _stage = _Stage.downloaded);
      await _install();
    } on Exception {
      if (mounted) {
        setState(() => _stage = _Stage.failed);
      }
    }
  }

  Future<void> _install() async {
    final path = _path;
    if (path == null) {
      return _download();
    }
    final result = await AppScope.read(context).bridge.installApk(path);
    if (!mounted) {
      return;
    }
    switch (result) {
      case 'ok':
        Navigator.of(context).pop();
      case 'permission':
        setState(() => _stage = _Stage.permission);
      default:
        setState(() => _stage = _Stage.failed);
    }
  }

  Future<void> _openInBrowser() async {
    final l = context.l10n;
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.maybeOf(context);
    final opened =
        await AppScope.read(context).bridge.openUrl(widget.info.pageUrl);
    navigator.pop();
    if (!opened) {
      messenger?.showSnackBar(SnackBar(content: Text(l.openFailed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = Palette.of(context);
    final info = widget.info;
    final busy = _stage == _Stage.downloading;

    final body = <Widget>[
      Text(l.updateReady(info.version)),
      if (info.notes.isNotEmpty && _stage == _Stage.ready) ...<Widget>[
        const SizedBox(height: 12),
        Text(info.notes, style: TextStyle(fontSize: 13, color: p.muted)),
      ],
      if (busy) ...<Widget>[
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: _progress,
            minHeight: 8,
            color: p.accent,
            backgroundColor: p.surfaceHigh,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l.downloadingPercent(
              formatNumber(context, ((_progress ?? 0) * 100).floor())),
          style: TextStyle(fontSize: 13, color: p.muted),
        ),
      ],
      if (_stage == _Stage.permission) ...<Widget>[
        const SizedBox(height: 12),
        Text(l.allowInstalls,
            style: TextStyle(fontSize: 13, color: p.text, height: 1.4)),
      ],
      if (_stage == _Stage.failed) ...<Widget>[
        const SizedBox(height: 12),
        Text(l.downloadFailed,
            style: TextStyle(fontSize: 13, color: p.bad, height: 1.4)),
      ],
    ];

    final List<Widget> actions;
    if (!_canInstallInApp) {
      actions = <Widget>[
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l.later)),
        FilledButton(onPressed: _openInBrowser, child: Text(l.download)),
      ];
    } else {
      switch (_stage) {
        case _Stage.ready:
          actions = <Widget>[
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l.later)),
            FilledButton(onPressed: _download, child: Text(l.downloadInstall)),
          ];
        case _Stage.downloading:
          actions = <Widget>[
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l.later)),
          ];
        case _Stage.downloaded:
        case _Stage.permission:
          actions = <Widget>[
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l.later)),
            FilledButton(onPressed: _install, child: Text(l.installNow)),
          ];
        case _Stage.failed:
          actions = <Widget>[
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l.later)),
            FilledButton(onPressed: _download, child: Text(l.tryAgain)),
          ];
      }
    }

    return PopScope(
      canPop: !busy,
      child: AlertDialog(
        title: Text(l.updateAvailable),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: body,
          ),
        ),
        actions: actions,
      ),
    );
  }
}
