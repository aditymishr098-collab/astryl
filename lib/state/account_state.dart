import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/account_service.dart';
import '../data/account_store.dart';
import '../data/native_bridge.dart';
import '../data/settings.dart';
import '../data/sync.dart';

/// The online account: login, sync, the anonymous active-user count and the
/// shared location. Everything here is optional; the app works fully without
/// it, and nothing is sent until the user agrees.
class AccountState extends ChangeNotifier {
  AccountState({
    AccountStore? store,
    AccountService? service,
    NativeBridge bridge = const NativeBridge(),
  })  : _store = store ?? AccountStore(),
        _api = service ?? AccountService(),
        _bridge = bridge;

  final AccountStore _store;
  final AccountService _api;
  final NativeBridge _bridge;

  AccountPrefs _prefs = const AccountPrefs();
  AccountPrefs get prefs => _prefs;

  HelioraSettings Function() _read = () => const HelioraSettings();
  Future<void> Function(HelioraSettings next) _apply =
      (next) => Future<void>.value();

  Timer? _timer;
  String? _lastPushed;
  bool _syncing = false;

  /// "idle", "syncing", "ok" or "failed": the last sync, for Settings.
  String syncStatus = 'idle';

  /// Connects the account to the app's settings.
  void bind({
    required HelioraSettings Function() read,
    required Future<void> Function(HelioraSettings next) apply,
  }) {
    _read = read;
    _apply = apply;
  }

  Future<void> load() async {
    _prefs = await _store.load();
    if (_prefs.deviceId.isEmpty) {
      _prefs = _prefs.copyWith(deviceId: newDeviceId());
      await _store.save(_prefs);
    }
    notifyListeners();
  }

  bool get loggedIn => _prefs.session != null;
  String get username => _prefs.session?.username ?? '';

  /// True until the first-run account page has been left.
  bool get needsPrompt => !_prefs.promptDone;

  Future<void> _set(AccountPrefs next) async {
    _prefs = next;
    notifyListeners();
    await _store.save(next);
  }

  bool get crashReports => _prefs.crashReports;

  Future<void> setCrashReports(bool on) =>
      _set(_prefs.copyWith(crashReports: on));

  Future<void> markPromptDone() => _set(_prefs.copyWith(promptDone: true));

  String? get _country {
    final c = PlatformDispatcher.instance.locale.countryCode;
    return c == null || c.length != 2 ? null : c.toUpperCase();
  }

  AccountSession _sessionFrom(Map<String, dynamic> json, String username) {
    final s = json['session'];
    if (s is! Map) {
      throw const AccountException('server_error');
    }
    final access = s['access_token'];
    final refresh = s['refresh_token'];
    final expires = s['expires_at'];
    final id = s['user_id'];
    if (access is! String || refresh is! String) {
      throw const AccountException('server_error');
    }
    return AccountSession(
      accessToken: access,
      refreshToken: refresh,
      expiresAt: expires is num
          ? expires.toInt()
          : DateTime.now().millisecondsSinceEpoch ~/ 1000 + 3000,
      userId: id is String ? id : '',
      username: username,
    );
  }

  /// Makes an account and returns its recovery code. Throws
  /// [AccountException].
  Future<String> signUp({
    required String username,
    required String password,
    required bool countMe,
    required bool shareCountry,
    required bool shareLocation,
  }) async {
    final name = normalizeUsername(username);
    final json = await _api.call('signup', body: <String, Object?>{
      'username': name,
      'password': password,
      'consent': true,
      'consentVersion': consentVersion,
      'countMe': countMe,
      'shareCountry': shareCountry,
      'shareLocation': shareLocation,
      'country': _country,
    });
    final code = json['code'];
    final session = _sessionFrom(json, name);
    _lastPushed = null;
    await _set(_prefs.copyWith(
      session: session,
      countMe: countMe,
      shareCountry: shareCountry,
      shareLocation: shareLocation,
      syncedMs: 0,
    ));
    unawaited(syncNow());
    return code is String ? formatCode(code) : '';
  }

  /// Logs in and joins the account's data with the phone's.
  Future<void> logIn(String username, String password) async {
    final name = normalizeUsername(username);
    final json = await _api.call('login', body: <String, Object?>{
      'username': name,
      'password': password,
    });
    _lastPushed = null;
    await _set(_prefs.copyWith(
        session: _sessionFrom(json, name), promptDone: true, syncedMs: 0));
    await syncNow();
  }

  /// Sets a new password with the recovery code. Returns how many times the
  /// code can still be used.
  Future<int> recover(String username, String code, String password) async {
    final name = normalizeUsername(username);
    final json = await _api.call('recover', body: <String, Object?>{
      'username': name,
      'code': normalizeCode(code),
      'password': password,
    });
    _lastPushed = null;
    await _set(_prefs.copyWith(
        session: _sessionFrom(json, name), promptDone: true, syncedMs: 0));
    await syncNow();
    final left = json['usesLeft'];
    return left is int ? left : 0;
  }

  /// Makes a new recovery code (the old one stops working).
  Future<String> newRecoveryCode() async {
    final json = await _api.call('newcode', token: await _token());
    final code = json['code'];
    if (code is! String) {
      throw const AccountException('server_error');
    }
    return formatCode(code);
  }

  /// Logs out. The data stays on the phone.
  Future<void> logOut() async {
    _timer?.cancel();
    _lastPushed = null;
    syncStatus = 'idle';
    await _set(_prefs.copyWith(clearSession: true, syncedMs: 0));
  }

  /// Deletes the account and everything stored for it online. The data on
  /// the phone stays. Throws [AccountException], for example "bad_login"
  /// when the password is wrong.
  Future<void> deleteAccount(String password) async {
    await _api.call('delete',
        body: <String, Object?>{'password': password}, token: await _token());
    _timer?.cancel();
    _lastPushed = null;
    syncStatus = 'idle';
    await _set(_prefs.copyWith(
      clearSession: true,
      syncedMs: 0,
      shareLocation: false,
      shareCountry: false,
    ));
  }

  /// A working access token, renewed when it is about to run out.
  Future<String> _token() async {
    var session = _prefs.session;
    if (session == null) {
      throw const AccountException('no_token');
    }
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    if (session.expiresAt - 60 > now) {
      return session.accessToken;
    }
    try {
      final json = await _api.call('refresh', body: <String, Object?>{
        'refresh_token': session.refreshToken,
      });
      session = _sessionFrom(json, session.username);
      await _set(_prefs.copyWith(session: session));
      return session.accessToken;
    } on AccountException catch (e) {
      if (e.status == 401) {
        // The login ran out for good: ask the user to log in again.
        await _set(_prefs.copyWith(clearSession: true, syncedMs: 0));
      }
      rethrow;
    }
  }

  Future<void> setSyncOn(bool value) async {
    await _set(_prefs.copyWith(syncOn: value));
    if (value) {
      unawaited(syncNow());
    }
  }

  Future<void> setCountMe(bool value) async {
    await _set(_prefs.copyWith(countMe: value, lastPingMs: 0));
    await _pushPrefs();
    if (value) {
      unawaited(ping());
    }
  }

  Future<void> setShareCountry(bool value) async {
    await _set(_prefs.copyWith(shareCountry: value, lastPingMs: 0));
    await _pushPrefs();
    if (value && _prefs.countMe) {
      unawaited(ping());
    }
  }

  Future<void> setShareLocation(bool value) async {
    await _set(_prefs.copyWith(shareLocation: value, lastLocationMs: 0));
    await _pushPrefs();
  }

  Future<void> _pushPrefs() async {
    if (!loggedIn) {
      return;
    }
    try {
      await _api.call('prefs',
          body: <String, Object?>{
            'countMe': _prefs.countMe,
            'shareCountry': _prefs.shareCountry,
            'shareLocation': _prefs.shareLocation,
            'country': _prefs.shareCountry ? _country : null,
          },
          token: await _token());
    } on AccountException {
      // Tried again the next time the app opens.
    }
  }

  /// Agrees the phone and the account. True when it worked.
  Future<bool> syncNow() async {
    if (!loggedIn || !_prefs.syncOn || _syncing) {
      return false;
    }
    _syncing = true;
    syncStatus = 'syncing';
    notifyListeners();
    try {
      final token = await _token();
      final res = await _api.call('pull', token: token);
      final remote = res['data'];
      final remoteMs = res['updatedMs'] is num ? (res['updatedMs'] as num).toInt() : 0;
      final remotePrefs = res['prefs'];
      if (remotePrefs is Map) {
        _prefs = _prefs.copyWith(
          countMe: remotePrefs['countMe'] is bool ? remotePrefs['countMe'] as bool : null,
          shareCountry: remotePrefs['shareCountry'] is bool ? remotePrefs['shareCountry'] as bool : null,
          shareLocation: remotePrefs['shareLocation'] is bool ? remotePrefs['shareLocation'] as bool : null,
        );
      }
      final local = _read();
      var next = local;
      if (remote is Map<String, dynamic>) {
        next = mergeSync(local, remote, remoteWins: remoteMs > _prefs.syncedMs);
      }
      if (canonicalJson(buildSyncPayload(next)) !=
          canonicalJson(buildSyncPayload(local))) {
        await _apply(next);
      }
      final payload = buildSyncPayload(next);
      final text = canonicalJson(payload);
      var syncedMs = remoteMs;
      if (remote == null || canonicalJson(remote) != text) {
        final pushed = await _api.call('push',
            body: <String, Object?>{'data': payload}, token: token);
        syncedMs = pushed['updatedMs'] is num
            ? (pushed['updatedMs'] as num).toInt()
            : DateTime.now().millisecondsSinceEpoch;
      }
      _lastPushed = text;
      syncStatus = 'ok';
      await _set(_prefs.copyWith(syncedMs: syncedMs));
      return true;
    } on AccountException {
      syncStatus = 'failed';
      notifyListeners();
      return false;
    } finally {
      _syncing = false;
    }
  }

  /// Called after the settings changed: sends them a moment later, once.
  void scheduleSync() {
    if (!loggedIn || !_prefs.syncOn) {
      return;
    }
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 3), () async {
      if (_lastPushed == null) {
        await syncNow();
        return;
      }
      final payload = buildSyncPayload(_read());
      if (canonicalJson(payload) == _lastPushed) {
        return;
      }
      try {
        final pushed = await _api.call('push',
            body: <String, Object?>{'data': payload}, token: await _token());
        _lastPushed = canonicalJson(payload);
        syncStatus = 'ok';
        final ms = pushed['updatedMs'];
        await _set(_prefs.copyWith(
            syncedMs: ms is num ? ms.toInt() : DateTime.now().millisecondsSinceEpoch));
      } on AccountException {
        syncStatus = 'failed';
        notifyListeners();
      }
    });
  }

  /// Counts this phone as active, once every few hours, when the user
  /// allowed it.
  Future<void> ping() async {
    if (!_prefs.countMe) {
      return;
    }
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - _prefs.lastPingMs < 4 * 60 * 60 * 1000) {
      return;
    }
    try {
      await _api.call('ping', body: <String, Object?>{
        'device': _prefs.deviceId,
        'country': _prefs.shareCountry ? _country : null,
      });
      await _set(_prefs.copyWith(lastPingMs: now));
    } on AccountException {
      // Tried again the next time the app opens.
    }
  }

  /// Sends the approximate location, at most once a day, when the user
  /// allowed it. With [ask] false it never shows a permission question.
  Future<void> shareLocationNow({bool ask = false, bool force = false}) async {
    if (!loggedIn || !_prefs.shareLocation) {
      return;
    }
    final now = DateTime.now().millisecondsSinceEpoch;
    if (!force && now - _prefs.lastLocationMs < 20 * 60 * 60 * 1000) {
      return;
    }
    final place = await _bridge.getLocation(ask: ask);
    if (!place.ok) {
      return;
    }
    try {
      await _api.call('location',
          body: <String, Object?>{'lat': place.lat, 'lon': place.lon},
          token: await _token());
      await _set(_prefs.copyWith(lastLocationMs: now));
    } on AccountException {
      // Tried again the next time the app opens.
    }
  }

  /// What the app does each time it opens.
  Future<void> onAppOpen() async {
    // The web version has no account: it has no files or native bridge.
    if (kIsWeb) {
      return;
    }
    await syncNow();
    await ping();
    await shareLocationNow();
  }

  /// The public counter, or null when offline.
  Future<Map<String, dynamic>?> stats() async {
    try {
      return await _api.call('stats');
    } on AccountException {
      return null;
    }
  }

  /// Starts today's Daily 5 run for the logged-in user, or returns the finished
  /// run if already played today.
  Future<Map<String, dynamic>?> dailyStart() async {
    if (!loggedIn) {
      return null;
    }
    try {
      return await _api.call(
        'daily_start',
        body: <String, Object?>{'username': username},
        token: await _token(),
      );
    } on AccountException {
      return null;
    }
  }

  /// Submits today's Daily 5 score for the logged-in user.
  Future<Map<String, dynamic>?> dailySubmit(int correct) async {
    if (!loggedIn) {
      return null;
    }
    try {
      return await _api.call(
        'daily_submit',
        body: <String, Object?>{
          'correct': correct,
          'username': username,
        },
        token: await _token(),
      );
    } on AccountException {
      return null;
    }
  }

  /// Fetches the live Daily 5 leaderboard (today and all-time).
  Future<Map<String, dynamic>?> dailyBoard() async {
    try {
      String? tk;
      if (loggedIn) {
        try {
          tk = await _token();
        } on AccountException {
          tk = null;
        }
      }
      return await _api.call('board', token: tk);
    } on AccountException {
      return null;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
