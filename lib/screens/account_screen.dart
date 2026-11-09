import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/account_service.dart';
import '../data/sync.dart';
import '../l10n/gen/app_localizations.dart';
import '../l10n/names.dart';
import '../state/account_state.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';

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

/// Make an account, log in, or reset the password. Shown once when the app
/// is first opened (with "Skip now") and again from Settings.
class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key, this.firstRun = false});

  final bool firstRun;

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
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

  @override
  void dispose() {
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
      // The permission was asked on the form; the first place goes now.
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
    return Scaffold(
      appBar: widget.firstRun
          ? null
          : AppBar(
              title: Text(l.acctTitle),
              automaticallyImplyLeading: _recoveryCode == null,
            ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          children: <Widget>[
            if (_recoveryCode != null)
              ..._codeView(l, p)
            else ...<Widget>[
              if (widget.firstRun) ...<Widget>[
                Icon(Icons.public, size: 44, color: p.accentText),
                const SizedBox(height: 12),
              ],
              Text(
                  _mode == _Mode.recover
                      ? l.acctRecoverTitle
                      : l.acctCreateTitle,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: p.text)),
              const SizedBox(height: 8),
              Text(l.acctIntro,
                  style: TextStyle(fontSize: 14, color: p.muted, height: 1.45)),
              const SizedBox(height: 18),
              if (_mode != _Mode.recover)
                SegmentedButton<_Mode>(
                  segments: <ButtonSegment<_Mode>>[
                    ButtonSegment<_Mode>(
                        value: _Mode.create, label: Text(l.acctTabCreate)),
                    ButtonSegment<_Mode>(
                        value: _Mode.login, label: Text(l.acctTabLogin)),
                  ],
                  selected: <_Mode>{_mode},
                  onSelectionChanged: _busy
                      ? null
                      : (s) => setState(() {
                            _mode = s.first;
                            _error = null;
                          }),
                ),
              const SizedBox(height: 16),
              ..._form(l, p),
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _form(AppLocalizations l, Palette p) {
    final create = _mode == _Mode.create;
    final recover = _mode == _Mode.recover;
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
          labelText: l.acctUsername,
          helperText: create || recover ? l.acctUsernameHint : null,
          border: const OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 12),
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
            labelText: l.acctRecoverCode,
            hintText: 'XXXX-XXXX-XXXX-XXXX',
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
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
          labelText: recover ? l.acctRecoverNewPassword : l.acctPassword,
          helperText: create || recover ? l.acctPasswordHint : null,
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: Icon(_show ? Icons.visibility_off : Icons.visibility),
            onPressed: () => setState(() => _show = !_show),
          ),
        ),
      ),
      if (create) ...<Widget>[
        const SizedBox(height: 12),
        TextField(
          controller: _pass2,
          enabled: !_busy,
          obscureText: !_show,
          autocorrect: false,
          enableSuggestions: false,
          decoration: InputDecoration(
            labelText: l.acctPasswordAgain,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
          value: _consent,
          onChanged: _busy ? null : (v) => setState(() => _consent = v ?? false),
          title: Text(l.acctConsent,
              style: TextStyle(fontSize: 14, color: p.text)),
        ),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton(
            onPressed: () => _openPolicy(context),
            child: Text(l.acctReadPolicy),
          ),
        ),
        const SizedBox(height: 8),
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
        Text(_error!, style: TextStyle(color: p.bad, fontSize: 14)),
      ],
      const SizedBox(height: 16),
      FilledButton(
        style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
        onPressed: _busy || (create && !_consent) ? null : _submit,
        child: _busy
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
      if (_mode == _Mode.login)
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
      if (recover)
        TextButton(
          onPressed: _busy
              ? null
              : () => setState(() {
                    _mode = _Mode.login;
                    _error = null;
                    _pass.clear();
                  }),
          child: Text(l.acctBackToLogin),
        ),
      if (widget.firstRun) ...<Widget>[
        const SizedBox(height: 16),
        OutlinedButton(
          style:
              OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
          onPressed: _busy ? null : () => _account.markPromptDone(),
          child: Text(l.acctSkip),
        ),
        const SizedBox(height: 8),
        Text(l.acctSkipNote,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: p.muted, height: 1.4)),
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
            title: Text(title, style: TextStyle(fontSize: 15, color: p.text)),
            value: value,
            onChanged: _busy ? null : onChanged,
          ),
          Text(note,
              style: TextStyle(fontSize: 12, color: p.muted, height: 1.4)),
        ],
      ),
    );
  }

  List<Widget> _codeView(AppLocalizations l, Palette p) {
    final code = _recoveryCode ?? '';
    return <Widget>[
      Icon(Icons.vpn_key_outlined, size: 40, color: p.accentText),
      const SizedBox(height: 12),
      Text(l.acctCodeTitle,
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.w700, color: p.text)),
      const SizedBox(height: 8),
      Text(l.acctCodeWarn,
          style: TextStyle(fontSize: 14, color: p.muted, height: 1.45)),
      const SizedBox(height: 18),
      SurfaceCard(
        child: Column(
          children: <Widget>[
            SelectableText(
              code,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
                color: p.text,
              ),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              icon: const Icon(Icons.copy, size: 18),
              label: Text(l.acctCopy),
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                await Clipboard.setData(ClipboardData(text: code));
                messenger.showSnackBar(SnackBar(content: Text(l.acctCopied)));
              },
            ),
          ],
        ),
      ),
      const SizedBox(height: 12),
      CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity.leading,
        value: _codeSaved,
        onChanged: (v) => setState(() => _codeSaved = v ?? false),
        title: Text(l.acctCodeSaved,
            style: TextStyle(fontSize: 14, color: p.text)),
      ),
      const SizedBox(height: 12),
      FilledButton(
        style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
        onPressed: _codeSaved ? _afterCode : null,
        child: Text(l.acctContinue),
      ),
    ];
  }
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
                      FilledButton(
                        style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(48)),
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                              builder: (_) => const AccountScreen()),
                        ),
                        child: Text(l.acctCreateTitle),
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
                        onTap: account.logOut,
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
