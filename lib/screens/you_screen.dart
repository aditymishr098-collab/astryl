import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../core/format.dart';
import '../l10n/names.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/motion.dart';
import 'account_screen.dart';
import 'settings_screen.dart';

/// The "You" tab: Space Explorer Passport, optional account, Weight/Jump/Age
/// calculators, and every setting.
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
        const FadeSlideIn(child: _SpacePassportCard()),
        const SizedBox(height: 16),
        if (!kIsWeb) ...<Widget>[
          const FadeSlideIn(child: _AccountCard()),
          const SizedBox(height: 28),
        ],
        // The weight, jump and age calculators are in the Compare tab.
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

/// A summary "Space Explorer Passport" card showing the user's explorer title,
/// favourites count, quiz best scores, and days on Earth.
class _SpacePassportCard extends StatelessWidget {
  const _SpacePassportCard();

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final isHi = Localizations.localeOf(context).languageCode == 'hi';
    final state = AppScope.of(context);
    final account = state.account;
    final settings = state.settings;
    final favCount = settings.favorites.length;
    final easyBest = settings.bestFor('easy');
    final medBest = settings.bestFor('medium');
    final hardBest = settings.bestFor('hard');
    final totalStars = easyBest + medBest + hardBest;

    final String rankTitle;
    if (totalStars >= 25) {
      rankTitle = isHi ? 'कमांडर (Cosmic Commander)' : 'Cosmic Commander';
    } else if (totalStars >= 15) {
      rankTitle = isHi ? 'डीप स्पेस पायलट (Space Pilot)' : 'Deep Space Pilot';
    } else if (totalStars >= 5 || favCount >= 3) {
      rankTitle = isHi ? 'स्टार नेविगेटर (Star Navigator)' : 'Star Navigator';
    } else {
      rankTitle = isHi ? 'अंतरिक्ष यात्री (Space Cadet)' : 'Space Cadet';
    }

    return ListenableBuilder(
      listenable: account,
      builder: (context, _) {
        final name = account.loggedIn
            ? account.username
            : (isHi ? 'अंतरिक्ष यात्री' : 'Space Explorer');
        return SurfaceCard(
          borderColor: p.accent.withValues(alpha: 0.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: <Color>[p.accent, p.accentText],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.public, color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          isHi ? 'ASTRYL अंतरिक्ष पासपोर्ट' : 'ASTRYL SPACE PASSPORT',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: p.accentText,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          name,
                          style: TextStyle(
                            fontFamily: headingFont,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: p.text,
                          ),
                        ),
                        Text(
                          rankTitle,
                          style: TextStyle(fontSize: 12.5, color: p.muted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _PassportStat(
                      label: isHi ? 'पसंदीदा (★)' : 'Favourites (★)',
                      value: formatNumber(context, favCount),
                    ),
                  ),
                  Expanded(
                    child: _PassportStat(
                      label: isHi ? 'क्विज़ कुल अंक' : 'Quiz Stars',
                      value: '${formatNumber(context, totalStars)}/30',
                    ),
                  ),
                  Expanded(
                    child: _PassportStat(
                      label: isHi ? 'कठिन बेस्ट' : 'Hard Best',
                      value: '${formatNumber(context, hardBest)}/10',
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PassportStat extends StatelessWidget {
  const _PassportStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          value,
          style: TextStyle(
            fontFamily: headingFont,
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: p.text,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 11.5, color: p.muted)),
      ],
    );
  }
}

/// The optional account, one slim row at the top of "You".
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
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: p.text)),
              ),
              subtitle: account.loggedIn
                  ? null
                  : Text(l.settingsAccountSubtitle,
                      style: TextStyle(fontSize: 12, color: p.muted)),
              trailing: account.loggedIn
                  ? Icon(Icons.chevron_right, color: p.muted)
                  : FilledButton.tonalIcon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                            builder: (_) => const AccountScreen()),
                      ),
                      icon: const Icon(Icons.login_rounded, size: 16),
                      label: Text(l.acctTabLogin),
                    ),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                    builder: (_) => const AccountHubScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
