import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../l10n/names.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/motion.dart';
import 'account_screen.dart';
import 'settings_screen.dart';

/// The "You" tab: the optional account, then every setting.
class YouScreen extends StatelessWidget {
  const YouScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = Palette.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: <Widget>[
        Text(l.navYou,
            style: TextStyle(
                fontFamily: headingFont,
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: p.text)),
        const SizedBox(height: 16),
        if (!kIsWeb) ...<Widget>[
          const FadeSlideIn(child: _AccountCard()),
          const SizedBox(height: 24),
        ],
        Text(l.settings,
            style: TextStyle(
                fontFamily: headingFont,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: p.text)),
        const SizedBox(height: 8),
        const FadeSlideIn(child: SettingsSections()),
      ],
    );
  }
}

/// The optional account and the crash-report switch, at the top of "You".
class _AccountCard extends StatelessWidget {
  const _AccountCard();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = Palette.of(context);
    final account = AppScope.of(context).account;
    return ListenableBuilder(
      listenable: account,
      builder: (context, _) => SurfaceCard(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          children: <Widget>[
            ListTile(
              leading:
                  Icon(Icons.account_circle_outlined, color: p.accentText),
              title: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Text(
                    account.loggedIn
                        ? l.acctLoggedInAs(account.username)
                        : l.acctTitle,
                    key: ValueKey<bool>(account.loggedIn),
                    style: TextStyle(color: p.text)),
              ),
              subtitle: Text(l.settingsAccountSubtitle,
                  style: TextStyle(fontSize: 12, color: p.muted)),
              trailing: Icon(Icons.chevron_right, color: p.muted),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                    builder: (_) => const AccountHubScreen()),
              ),
            ),
            SwitchListTile(
              title: Text(l.crashReportsTitle,
                  style: TextStyle(fontSize: 15, color: p.text)),
              subtitle: Text(l.crashReportsNote,
                  style: TextStyle(fontSize: 12, color: p.muted, height: 1.4)),
              value: account.crashReports,
              onChanged: account.setCrashReports,
            ),
          ],
        ),
      ),
    );
  }
}
