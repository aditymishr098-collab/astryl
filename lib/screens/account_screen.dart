import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/account_service.dart';
import '../data/planets.dart';
import '../data/sync.dart';
import '../l10n/gen/app_localizations.dart';
import '../l10n/names.dart';
import '../state/account_state.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/motion.dart';

/// The words for an [AccountException].
String accountErrorText(AppLocalizations l, AccountException e) {
  switch (e.code) {
    case 'offline':
      return l.acctErrOffline;
    case 'username_taken':
      return l.acctErrTaken;
    case 'bad_username':
      return l.acctErrUsername;
    case 'bad_password':
      return l.acctErrPassword;
    case 'bad_login':
      return l.acctErrLogin;
    case 'bad_recovery':
      return l.acctErrRecovery;
    case 'code_used_up':
      return l.acctErrUsedUp;
    case 'locked':
      return l.acctErrLocked;
    case 'rate_limited':
      return l.acctErrRate;
    default:
      return l.acctErrGeneric;
  }
}

Future<void> _openPolicy(BuildContext context) async {
  final l = context.l10n;
  final messenger = ScaffoldMessenger.of(context);
  final ok = await AppScope.read(context).bridge.openUrl(privacyUrl);
  if (!ok) {
    messenger.showSnackBar(SnackBar(content: Text(l.openFailed)));
  }
}

/// Asks for the location and tells the user when it did not work. True when
/// a place was found.
Future<bool> askForLocation(BuildContext context) async {
  final l = context.l10n;
  final messenger = ScaffoldMessenger.of(context);
  final place = await AppScope.read(context).bridge.getLocation(ask: true);
  if (place.ok) {
    return true;
  }
  final text = switch (place.status) {
    'denied' => l.locDenied,
    'off' => l.locOff,
    _ => l.locError,
  };
  messenger.showSnackBar(SnackBar(content: Text(text)));
  return false;
}

enum _Mode { create, login, recover }

/// Make an account, log in, or reset the password. The app opens on it until
/// somebody is logged in (there is no "skip"), and it is shown again after
/// log out, featuring a live animated starfield and floating orbital portal.
class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key, this.firstRun = false});

  final bool firstRun;

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>
    with SingleTickerProviderStateMixin {
  _Mode _mode = _Mode.create;
  final _user = TextEditingController();
  final _pass = TextEditingController();
  final _pass2 = TextEditingController();
  final _code = TextEditingController();
  bool _show = false;
  bool _consent = false;
  bool _countMe = false;
  bool _country = false;
  bool _location = false;
  bool _busy = false;
  String? _error;
  String? _recoveryCode;
  bool _codeSaved = false;

  late final AnimationController _heroCtrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 16),
  )..repeat();

  @override
  void initState() {
    super.initState();
    _pass.addListener(_onPassChanged);
  }

  void _onPassChanged() {
    if (mounted && (_mode == _Mode.create || _mode == _Mode.recover)) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _heroCtrl.dispose();
    _pass.removeListener(_onPassChanged);
    _user.dispose();
    _pass.dispose();
    _pass2.dispose();
    _code.dispose();
    super.dispose();
  }

  AccountState get _account => AppScope.read(context).account;

  void _fail(AccountException e) {
    setState(() {
      _busy = false;
      _error = accountErrorText(context.l10n, e);
    });
  }

  void _finish() {
    if (widget.firstRun) {
      // The start page swaps itself for the app.
      _account.markPromptDone();
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<void> _submit() async {
    final l = context.l10n;
    final user = _user.text;
    if (!isValidUsername(user)) {
      setState(() => _error = l.acctErrUsername);
      return;
    }
    switch (_mode) {
      case _Mode.create:
        if (!isValidPassword(_pass.text)) {
          setState(() => _error = l.acctErrPassword);
          return;
        }
        if (_pass.text != _pass2.text) {
          setState(() => _error = l.acctErrMismatch);
          return;
        }
      case _Mode.login:
        if (_pass.text.isEmpty) {
          setState(() => _error = l.acctErrLogin);
          return;
        }
      case _Mode.recover:
        if (!isValidCode(_code.text)) {
          setState(() => _error = l.acctErrCode);
          return;
        }
        if (!isValidPassword(_pass.text)) {
          setState(() => _error = l.acctErrPassword);
          return;
        }
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final messenger = ScaffoldMessenger.of(context);
    try {
      switch (_mode) {
        case _Mode.create:
          final code = await _account.signUp(
            username: user,
            password: _pass.text,
            countMe: _countMe,
            shareCountry: _country,
            shareLocation: _location,
          );
          if (!mounted) {
            return;
          }
          setState(() {
            _busy = false;
            _recoveryCode = code;
          });
        case _Mode.login:
          await _account.logIn(user, _pass.text);
          if (!mounted) {
            return;
          }
          _finish();
        case _Mode.recover:
          final left = await _account.recover(user, _code.text, _pass.text);
          if (!mounted) {
            return;
          }
          messenger.showSnackBar(
              SnackBar(content: Text(l.acctRecovered(left))));
          _finish();
      }
    } on AccountException catch (e) {
      if (mounted) {
        _fail(e);
      }
    }
  }

  Future<void> _toggleLocation(bool value) async {
    if (value && !await askForLocation(context)) {
      return;
    }
    if (mounted) {
      setState(() => _location = value);
    }
  }

  Future<void> _afterCode() async {
    final account = _account;
    if (account.prefs.shareLocation) {
      await account.shareLocationNow(force: true);
    }
    if (account.prefs.countMe) {
      await account.ping();
    }
    if (mounted) {
      _finish();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = Palette.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isHi = Localizations.localeOf(context).languageCode == 'hi';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: widget.firstRun
          ? null
          : AppBar(
              title: Text(l.acctTitle),
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: _recoveryCode == null,
            ),
      body: Stack(
        children: <Widget>[
          // Animated cosmic starfield & nebula background
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _heroCtrl,
                builder: (context, _) => CustomPaint(
                  painter: _CosmicPortalBackgroundPainter(
                    phase: _heroCtrl.value,
                    isDark: isDark,
                    accent: p.accent,
                    orbit: p.orbit,
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 540),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
                  children: <Widget>[
                    if (_recoveryCode != null)
                      ..._codeView(l, p, isHi)
                    else ...<Widget>[
                      FadeSlideIn(
                        child: _AnimatedOrbitalHero(
                          animation: _heroCtrl,
                          title: _mode == _Mode.recover
                              ? l.acctRecoverTitle
                              : l.acctCreateTitle,
                          subtitle: l.acctIntro,
                          isHi: isHi,
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (_mode != _Mode.recover)
                        FadeSlideIn(
                          delay: const Duration(milliseconds: 70),
                          child: _AnimatedModePill(
                            mode: _mode,
                            createLabel: l.acctTabCreate,
                            loginLabel: l.acctTabLogin,
                            enabled: !_busy,
                            onChanged: (next) => setState(() {
                              _mode = next;
                              _error = null;
                            }),
                          ),
                        ),
                      const SizedBox(height: 16),
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 130),
                        child: SurfaceCard(
                          padding: const EdgeInsets.all(20),
                          borderColor: p.accent.withValues(alpha: 0.32),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 280),
                            switchInCurve: Curves.easeOutCubic,
                            switchOutCurve: Curves.easeInCubic,
                            transitionBuilder: (child, anim) => FadeTransition(
                              opacity: anim,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 0.04),
                                  end: Offset.zero,
                                ).animate(anim),
                                child: child,
                              ),
                            ),
                            child: Column(
                              key: ValueKey<_Mode>(_mode),
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: _form(l, p, isHi),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _form(AppLocalizations l, Palette p, bool isHi) {
    final create = _mode == _Mode.create;
    final recover = _mode == _Mode.recover;
    final passLen = _pass.text.length;
    final passStrength = (passLen / 12.0).clamp(0.0, 1.0);
    final strengthColor = passLen < 8
        ? p.bad
        : passLen < 11
            ? p.accent
            : p.good;

    return <Widget>[
      TextField(
        controller: _user,
        enabled: !_busy,
        autocorrect: false,
        enableSuggestions: false,
        textInputAction: TextInputAction.next,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9_]')),
          LengthLimitingTextInputFormatter(20),
        ],
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.alternate_email_rounded,
              size: 20, color: p.accentText),
          labelText: l.acctUsername,
          helperText: create || recover ? l.acctUsernameHint : null,
        ),
      ),
      const SizedBox(height: 14),
      if (recover) ...<Widget>[
        TextField(
          controller: _code,
          enabled: !_busy,
          autocorrect: false,
          enableSuggestions: false,
          textCapitalization: TextCapitalization.characters,
          textInputAction: TextInputAction.next,
          style: const TextStyle(fontFamily: 'monospace', letterSpacing: 1.5),
          decoration: InputDecoration(
            prefixIcon:
                Icon(Icons.vpn_key_rounded, size: 20, color: p.accentText),
            labelText: l.acctRecoverCode,
            hintText: 'XXXX-XXXX-XXXX-XXXX',
          ),
        ),
        const SizedBox(height: 14),
      ],
      TextField(
        controller: _pass,
        enabled: !_busy,
        obscureText: !_show,
        autocorrect: false,
        enableSuggestions: false,
        textInputAction: create ? TextInputAction.next : TextInputAction.done,
        onSubmitted: create ? null : (_) => _submit(),
        decoration: InputDecoration(
          prefixIcon:
              Icon(Icons.lock_outline_rounded, size: 20, color: p.accentText),
          labelText: recover ? l.acctRecoverNewPassword : l.acctPassword,
          helperText: create || recover ? l.acctPasswordHint : null,
          suffixIcon: IconButton(
            icon: Icon(_show ? Icons.visibility_off : Icons.visibility),
            onPressed: () => setState(() => _show = !_show),
          ),
        ),
      ),
      if ((create || recover) && passLen > 0) ...<Widget>[
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: passStrength,
                  minHeight: 5,
                  color: strengthColor,
                  backgroundColor: p.surfaceHigh,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              passLen < 8
                  ? (isHi ? 'कम से कम 8 अक्षर' : 'Min 8 chars')
                  : passLen < 11
                      ? (isHi ? 'अच्छा पासवर्ड' : 'Good')
                      : (isHi ? 'मज़बूत पासवर्ड ✨' : 'Strong ✨'),
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: strengthColor,
              ),
            ),
          ],
        ),
      ],
      if (create) ...<Widget>[
        const SizedBox(height: 14),
        TextField(
          controller: _pass2,
          enabled: !_busy,
          obscureText: !_show,
          autocorrect: false,
          enableSuggestions: false,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.verified_user_outlined,
                size: 20, color: p.accentText),
            labelText: l.acctPasswordAgain,
          ),
        ),
        const SizedBox(height: 14),
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
          value: _consent,
          onChanged: _busy ? null : (v) => setState(() => _consent = v ?? false),
          title: Text(l.acctConsent,
              style: TextStyle(fontSize: 13.5, color: p.text)),
        ),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton.icon(
            onPressed: () => _openPolicy(context),
            icon: const Icon(Icons.shield_outlined, size: 17),
            label: Text(l.acctReadPolicy),
          ),
        ),
        const SizedBox(height: 8),
        const Divider(height: 1),
        const SizedBox(height: 12),
        SectionLabel(l.acctOptionalTitle),
        _option(l.acctCountMe, l.acctCountMeNote, _countMe,
            (v) => setState(() => _countMe = v), p),
        _option(l.acctShareCountry, l.acctShareCountryNote, _country,
            (v) => setState(() => _country = v), p),
        _option(l.acctShareLocation, l.acctShareLocationNote, _location,
            _toggleLocation, p),
      ],
      if (_error != null) ...<Widget>[
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: p.bad.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: p.bad.withValues(alpha: 0.45)),
          ),
          child: Row(
            children: <Widget>[
              Icon(Icons.error_outline, size: 18, color: p.bad),
              const SizedBox(width: 8),
              Expanded(
                child: Text(_error!,
                    style: TextStyle(
                        color: p.bad,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      ],
      const SizedBox(height: 18),
      FilledButton.icon(
        style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
        onPressed: _busy || (create && !_consent) ? null : _submit,
        icon: _busy
            ? const SizedBox.shrink()
            : Icon(
                create
                    ? Icons.rocket_launch_rounded
                    : recover
                        ? Icons.lock_reset_rounded
                        : Icons.login_rounded,
                size: 19,
              ),
        label: _busy
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2.5))
            : Text(create
                ? l.acctTabCreate
                : recover
                    ? l.acctRecoverButton
                    : l.acctTabLogin),
      ),
      if (_mode == _Mode.login) ...<Widget>[
        const SizedBox(height: 6),
        TextButton(
          onPressed: _busy
              ? null
              : () => setState(() {
                    _mode = _Mode.recover;
                    _error = null;
                    _pass.clear();
                  }),
          child: Text(l.acctForgot),
        ),
      ],
      if (recover) ...<Widget>[
        const SizedBox(height: 6),
        TextButton.icon(
          onPressed: _busy
              ? null
              : () => setState(() {
                    _mode = _Mode.login;
                    _error = null;
                    _pass.clear();
                  }),
          icon: const Icon(Icons.arrow_back_rounded, size: 17),
          label: Text(l.acctBackToLogin),
        ),
      ],
    ];
  }

  Widget _option(String title, String note, bool value,
      ValueChanged<bool> onChanged, Palette p) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(title, style: TextStyle(fontSize: 14.5, color: p.text)),
            value: value,
            onChanged: _busy ? null : onChanged,
          ),
          Text(note,
              style: TextStyle(fontSize: 12, color: p.muted, height: 1.4)),
        ],
      ),
    );
  }

  List<Widget> _codeView(AppLocalizations l, Palette p, bool isHi) {
    final code = _recoveryCode ?? '';
    return <Widget>[
      FadeSlideIn(
        child: SurfaceCard(
          padding: const EdgeInsets.all(22),
          borderColor: p.accent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: p.accent.withValues(alpha: 0.18),
                    ),
                    child: Icon(Icons.vpn_key_rounded,
                        size: 24, color: p.accentText),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          isHi
                              ? 'ASTRYL गुप्त रिकवरी पास'
                              : 'ASTRYL SECRET RECOVERY PASS',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                            color: p.accentText,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l.acctCodeTitle,
                          style: headingStyle(22, p.text),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                l.acctCodeWarn,
                style: TextStyle(fontSize: 13.5, color: p.muted, height: 1.45),
              ),
              const SizedBox(height: 18),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                decoration: BoxDecoration(
                  color: p.surfaceHigh,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                      color: p.accent.withValues(alpha: 0.55), width: 1.5),
                ),
                child: Column(
                  children: <Widget>[
                    SelectableText(
                      code,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.2,
                        color: p.accentText,
                      ),
                    ),
                    const SizedBox(height: 12),
                    FilledButton.tonalIcon(
                      icon: const Icon(Icons.copy_rounded, size: 18),
                      label: Text(l.acctCopy),
                      onPressed: () async {
                        final messenger = ScaffoldMessenger.of(context);
                        await Clipboard.setData(ClipboardData(text: code));
                        messenger
                            .showSnackBar(SnackBar(content: Text(l.acctCopied)));
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                value: _codeSaved,
                onChanged: (v) => setState(() => _codeSaved = v ?? false),
                title: Text(l.acctCodeSaved,
                    style: TextStyle(fontSize: 14, color: p.text)),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52)),
                onPressed: _codeSaved ? _afterCode : null,
                icon: const Icon(Icons.rocket_launch_rounded, size: 19),
                label: Text(l.acctContinue),
              ),
            ],
          ),
        ),
      ),
    ];
  }
}

/// Animated orbital hero header with a floating Earth & Saturn ring system.
class _AnimatedOrbitalHero extends StatelessWidget {
  const _AnimatedOrbitalHero({
    required this.animation,
    required this.title,
    required this.subtitle,
    required this.isHi,
  });

  final Animation<double> animation;
  final String title;
  final String subtitle;
  final bool isHi;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final saturn = planetById('saturn');
    final earth = planetById('earth');
    final mars = planetById('mars');

    return Column(
      children: <Widget>[
        SizedBox(
          height: 138,
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, _) {
              final t = animation.value * 2 * math.pi;
              final floatY = math.sin(t * 2) * 5.0;
              final earthAngle = t;
              final marsAngle = -t * 1.4 + 1.2;
              return Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  // Ambient solar glow
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: <Color>[
                          p.accent.withValues(alpha: 0.26),
                          p.orbit.withValues(alpha: 0.10),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  // Outer tilted orbit ring
                  CustomPaint(
                    size: const Size(220, 110),
                    painter: _HeroOrbitRingPainter(
                      color: p.orbit.withValues(alpha: 0.35),
                      accent: p.accent.withValues(alpha: 0.45),
                      angle: t,
                    ),
                  ),
                  // Orbiting Earth
                  Transform.translate(
                    offset: Offset(
                      math.cos(earthAngle) * 86,
                      math.sin(earthAngle) * 28,
                    ),
                    child: PlanetBall(planet: earth, size: 20),
                  ),
                  // Orbiting Mars
                  Transform.translate(
                    offset: Offset(
                      math.cos(marsAngle) * 58,
                      math.sin(marsAngle) * 20,
                    ),
                    child: PlanetBall(planet: mars, size: 14),
                  ),
                  // Central floating ringed planet / logo
                  Transform.translate(
                    offset: Offset(0, floatY),
                    child: PlanetBall(planet: saturn, size: 58),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: p.accent.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: p.accent.withValues(alpha: 0.4)),
          ),
          child: Text(
            isHi ? '✨ ASTRYL कॉस्मिक पोर्टल' : '✨ ASTRYL COSMIC PORTAL',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
              color: p.accentText,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          textAlign: TextAlign.center,
          style: headingStyle(26, p.text),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13.5, color: p.muted, height: 1.45),
        ),
      ],
    );
  }
}

class _HeroOrbitRingPainter extends CustomPainter {
  const _HeroOrbitRingPainter({
    required this.color,
    required this.accent,
    required this.angle,
  });

  final Color color;
  final Color accent;
  final double angle;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outer = Rect.fromCenter(center: center, width: 172, height: 56);
    final inner = Rect.fromCenter(center: center, width: 116, height: 40);
    canvas.drawOval(
      outer,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..color = color,
    );
    canvas.drawOval(
      inner,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.1
        ..color = accent,
    );
  }

  @override
  bool shouldRepaint(covariant _HeroOrbitRingPainter oldDelegate) =>
      oldDelegate.angle != angle;
}

/// Custom animated sliding pill switcher for Create vs Log In.
class _AnimatedModePill extends StatelessWidget {
  const _AnimatedModePill({
    required this.mode,
    required this.createLabel,
    required this.loginLabel,
    required this.enabled,
    required this.onChanged,
  });

  final _Mode mode;
  final String createLabel;
  final String loginLabel;
  final bool enabled;
  final ValueChanged<_Mode> onChanged;

  @override
  Widget build(BuildContext context) {
    final p = Palette.of(context);
    final isCreate = mode == _Mode.create;
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: p.border),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: enabled ? () => onChanged(_Mode.create) : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isCreate ? p.accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  createLabel,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isCreate ? p.onAccent : p.muted,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: enabled ? () => onChanged(_Mode.login) : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: !isCreate ? p.accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  loginLabel,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: !isCreate ? p.onAccent : p.muted,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Draws twinkling deep-space stars and subtle nebula clouds behind the login screen.
class _CosmicPortalBackgroundPainter extends CustomPainter {
  const _CosmicPortalBackgroundPainter({
    required this.phase,
    required this.isDark,
    required this.accent,
    required this.orbit,
  });

  final double phase;
  final bool isDark;
  final Color accent;
  final Color orbit;

  @override
  void paint(Canvas canvas, Size size) {
    final topGlow = Offset(size.width * 0.2, size.height * 0.14);
    final bottomGlow = Offset(size.width * 0.85, size.height * 0.78);
    canvas.drawCircle(
      topGlow,
      size.width * 0.65,
      Paint()
        ..shader = RadialGradient(
          colors: <Color>[
            orbit.withValues(alpha: isDark ? 0.16 : 0.08),
            Colors.transparent,
          ],
        ).createShader(
          Rect.fromCircle(center: topGlow, radius: size.width * 0.65),
        ),
    );
    canvas.drawCircle(
      bottomGlow,
      size.width * 0.6,
      Paint()
        ..shader = RadialGradient(
          colors: <Color>[
            accent.withValues(alpha: isDark ? 0.12 : 0.06),
            Colors.transparent,
          ],
        ).createShader(
          Rect.fromCircle(center: bottomGlow, radius: size.width * 0.6),
        ),
    );

    if (!isDark) {
      return;
    }

    final starPaint = Paint();
    for (var i = 0; i < 42; i++) {
      final fx = ((i * 73 + 19) % 97) / 97.0;
      final fy = ((i * 41 + 31) % 89) / 89.0;
      final twinkle =
          0.35 + 0.65 * (0.5 + 0.5 * math.sin(phase * 2 * math.pi * 2 + i));
      final r = (i % 5 == 0) ? 1.8 : 1.1;
      starPaint.color = (i % 4 == 0 ? accent : Colors.white)
          .withValues(alpha: (0.25 + 0.55 * twinkle).clamp(0.0, 1.0));
      canvas.drawCircle(
        Offset(fx * size.width, fy * size.height),
        r,
        starPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CosmicPortalBackgroundPainter oldDelegate) =>
      oldDelegate.phase != phase || oldDelegate.isDark != isDark;
}

/// Settings -> Account: login state, what is shared, new recovery code,
/// log out and delete.
class AccountHubScreen extends StatefulWidget {
  const AccountHubScreen({super.key});

  @override
  State<AccountHubScreen> createState() => _AccountHubScreenState();
}

class _AccountHubScreenState extends State<AccountHubScreen> {
  Map<String, dynamic>? _stats;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final stats = await AppScope.read(context).account.stats();
      if (mounted) {
        setState(() => _stats = stats);
      }
    });
  }

  Future<void> _toggleLocation(AccountState account, bool value) async {
    if (value && !await askForLocation(context)) {
      return;
    }
    await account.setShareLocation(value);
    if (value) {
      await account.shareLocationNow(force: true);
    }
  }

  Future<void> _newCode(AccountState account) async {
    final l = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    try {
      final code = await account.newRecoveryCode();
      if (!mounted) {
        return;
      }
      await showDialog<void>(
        context: context,
        builder: (context) {
          final p = Palette.of(context);
          return AlertDialog(
            title: Text(l.acctCodeTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SelectableText(code,
                    style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                        color: p.text)),
                const SizedBox(height: 10),
                Text(l.acctCodeWarn,
                    style: TextStyle(fontSize: 13, color: p.muted)),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: code));
                },
                child: Text(l.acctCopy),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l.acctContinue),
              ),
            ],
          );
        },
      );
    } on AccountException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(accountErrorText(l, e))));
    }
  }

  Future<void> _delete(AccountState account) async {
    final l = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);
    final controller = TextEditingController();
    final password = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.acctDeleteConfirmTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(l.acctDeleteConfirmBody),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              obscureText: true,
              autocorrect: false,
              enableSuggestions: false,
              decoration: InputDecoration(
                labelText: l.acctPassword,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: Palette.of(context).bad),
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: Text(l.acctDeleteButton),
          ),
        ],
      ),
    );
    controller.dispose();
    if (password == null || password.isEmpty) {
      return;
    }
    try {
      await account.deleteAccount(password);
      nav.popUntil((route) => route.isFirst);
      messenger.showSnackBar(SnackBar(content: Text(l.acctDeleted)));
    } on AccountException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(accountErrorText(l, e))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final p = Palette.of(context);
    final account = AppScope.read(context).account;
    return Scaffold(
      appBar: AppBar(title: Text(l.acctTitle)),
      body: ListenableBuilder(
        listenable: account,
        builder: (context, _) {
          final prefs = account.prefs;
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: <Widget>[
              SurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    if (account.loggedIn) ...<Widget>[
                      Row(
                        children: <Widget>[
                          Icon(Icons.account_circle_outlined,
                              color: p.accentText),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(l.acctLoggedInAs(account.username),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: p.text)),
                          ),
                        ],
                      ),
                    ] else ...<Widget>[
                      Text(l.acctNotLoggedIn,
                          style: TextStyle(fontSize: 15, color: p.text)),
                      const SizedBox(height: 4),
                      Text(l.acctIntro,
                          style: TextStyle(
                              fontSize: 13, color: p.muted, height: 1.4)),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(48)),
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                              builder: (_) => const AccountScreen()),
                        ),
                        icon: const Icon(Icons.rocket_launch_rounded, size: 18),
                        label: Text(l.acctCreateTitle),
                      ),
                    ],
                  ],
                ),
              ),
              if (account.loggedIn) ...<Widget>[
                const SizedBox(height: 16),
                SurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(l.acctSync,
                            style: TextStyle(fontSize: 15, color: p.text)),
                        value: prefs.syncOn,
                        onChanged: account.setSyncOn,
                      ),
                      Text(l.acctSyncNote,
                          style: TextStyle(
                              fontSize: 12, color: p.muted, height: 1.4)),
                      const SizedBox(height: 8),
                      Row(
                        children: <Widget>[
                          OutlinedButton(
                            onPressed: prefs.syncOn &&
                                    account.syncStatus != 'syncing'
                                ? account.syncNow
                                : null,
                            child: Text(l.acctSyncNow),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              switch (account.syncStatus) {
                                'syncing' => l.acctSyncing,
                                'ok' => l.acctSyncOk,
                                'failed' => l.acctSyncFailed,
                                _ => '',
                              },
                              style: TextStyle(fontSize: 12, color: p.muted),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
              if (account.loggedIn) ...<Widget>[
                const SizedBox(height: 16),
                SurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(l.boardShow,
                            style: TextStyle(fontSize: 15, color: p.text)),
                        value: prefs.showOnBoard,
                        onChanged: account.setShowOnBoard,
                      ),
                      Text(l.boardShowNote,
                          style: TextStyle(
                              fontSize: 12, color: p.muted, height: 1.4)),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 16),
              SectionLabel(l.acctOptionalTitle),
              SurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l.acctCountMe,
                          style: TextStyle(fontSize: 15, color: p.text)),
                      value: prefs.countMe,
                      onChanged: account.setCountMe,
                    ),
                    Text(l.acctCountMeNote,
                        style: TextStyle(
                            fontSize: 12, color: p.muted, height: 1.4)),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l.acctShareCountry,
                          style: TextStyle(fontSize: 15, color: p.text)),
                      value: prefs.shareCountry,
                      onChanged: account.setShareCountry,
                    ),
                    Text(l.acctShareCountryNote,
                        style: TextStyle(
                            fontSize: 12, color: p.muted, height: 1.4)),
                    if (account.loggedIn) ...<Widget>[
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(l.acctShareLocation,
                            style: TextStyle(fontSize: 15, color: p.text)),
                        value: prefs.shareLocation,
                        onChanged: (v) => _toggleLocation(account, v),
                      ),
                      Text(l.acctShareLocationNote,
                          style: TextStyle(
                              fontSize: 12, color: p.muted, height: 1.4)),
                    ],
                  ],
                ),
              ),
              if (_stats != null) ...<Widget>[
                const SizedBox(height: 16),
                SectionLabel(l.acctCommunity),
                SurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        l.acctStatsLine('${_stats!['registered'] ?? 0}',
                            '${_stats!['active_30d'] ?? 0}'),
                        style: TextStyle(fontSize: 15, color: p.text),
                      ),
                      const SizedBox(height: 4),
                      Text(l.acctStatsNote,
                          style: TextStyle(fontSize: 12, color: p.muted)),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 16),
              SurfaceCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(l.acctPrivacyLink,
                          style: TextStyle(color: p.text)),
                      trailing:
                          Icon(Icons.open_in_new, color: p.muted, size: 20),
                      onTap: () => _openPolicy(context),
                    ),
                    if (account.loggedIn) ...<Widget>[
                      const Divider(height: 1),
                      ListTile(
                        title: Text(l.acctNewCode,
                            style: TextStyle(color: p.text)),
                        subtitle: Text(l.acctNewCodeNote,
                            style: TextStyle(fontSize: 12, color: p.muted)),
                        onTap: () => _newCode(account),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        title: Text(l.acctLogOut,
                            style: TextStyle(color: p.text)),
                        onTap: () async {
                          final nav = Navigator.of(context);
                          await account.logOut();
                          nav.popUntil((route) => route.isFirst);
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        title: Text(l.acctDelete,
                            style: TextStyle(color: p.bad)),
                        subtitle: Text(l.acctDeleteNote,
                            style: TextStyle(fontSize: 12, color: p.muted)),
                        onTap: () => _delete(account),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
