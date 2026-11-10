import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'native_bridge.dart';

/// The login of the online account, kept apart from the settings so that a
/// backup file never contains it.
class AccountSession {
  const AccountSession({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    required this.userId,
    required this.username,
  });

  final String accessToken;
  final String refreshToken;

  /// Seconds since 1970 when [accessToken] stops working.
  final int expiresAt;
  final String userId;
  final String username;

  AccountSession copyWith({
    String? accessToken,
    String? refreshToken,
    int? expiresAt,
  }) {
    return AccountSession(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresAt: expiresAt ?? this.expiresAt,
      userId: userId,
      username: username,
    );
  }

  Map<String, Object> toJson() => <String, Object>{
        'access': accessToken,
        'refresh': refreshToken,
        'expiresAt': expiresAt,
        'userId': userId,
        'username': username,
      };

  static AccountSession? fromJson(Object? json) {
    if (json is! Map) {
      return null;
    }
    final a = json['access'];
    final r = json['refresh'];
    final e = json['expiresAt'];
    final u = json['userId'];
    final n = json['username'];
    if (a is String && r is String && e is int && u is String && n is String) {
      return AccountSession(
          accessToken: a,
          refreshToken: r,
          expiresAt: e,
          userId: u,
          username: n);
    }
    return null;
  }
}

/// Everything about the account part of the app that is kept on the phone.
class AccountPrefs {
  const AccountPrefs({
    this.deviceId = '',
    this.promptDone = false,
    this.syncOn = true,
    this.countMe = false,
    this.shareCountry = false,
    this.shareLocation = false,
    this.showOnBoard = true,
    this.crashReports = true,
    this.syncedMs = 0,
    this.lastPingMs = 0,
    this.lastLocationMs = 0,
    this.avatar = '',
    this.session,
  });

  /// A random id for the anonymous active-user count. It is not linked to
  /// any account or person.
  final String deviceId;

  /// True once the first-run account page was left (account made or skipped).
  final bool promptDone;
  final bool syncOn;
  final bool countMe;
  final bool shareCountry;
  final bool shareLocation;

  /// Whether the name shows on the Daily 5 leaderboard (on by default).
  final bool showOnBoard;

  /// Whether a crash sends a small anonymous report (no account, no name).
  final bool crashReports;

  /// When the phone last agreed with the account (ms since 1970, server time).
  final int syncedMs;
  final int lastPingMs;
  final int lastLocationMs;

  /// The profile picture of the logged-in account: a small JPEG as base64
  /// text, kept here so it also shows offline. Empty when there is none.
  final String avatar;
  final AccountSession? session;

  AccountPrefs copyWith({
    String? deviceId,
    bool? promptDone,
    bool? syncOn,
    bool? countMe,
    bool? shareCountry,
    bool? shareLocation,
    bool? showOnBoard,
    bool? crashReports,
    int? syncedMs,
    int? lastPingMs,
    int? lastLocationMs,
    String? avatar,
    AccountSession? session,
    bool clearSession = false,
  }) {
    return AccountPrefs(
      deviceId: deviceId ?? this.deviceId,
      promptDone: promptDone ?? this.promptDone,
      syncOn: syncOn ?? this.syncOn,
      countMe: countMe ?? this.countMe,
      shareCountry: shareCountry ?? this.shareCountry,
      shareLocation: shareLocation ?? this.shareLocation,
      showOnBoard: showOnBoard ?? this.showOnBoard,
      crashReports: crashReports ?? this.crashReports,
      syncedMs: syncedMs ?? this.syncedMs,
      lastPingMs: lastPingMs ?? this.lastPingMs,
      lastLocationMs: lastLocationMs ?? this.lastLocationMs,
      avatar: avatar ?? this.avatar,
      session: clearSession ? null : (session ?? this.session),
    );
  }

  Map<String, Object?> toJson() => <String, Object?>{
        'deviceId': deviceId,
        'promptDone': promptDone,
        'syncOn': syncOn,
        'countMe': countMe,
        'shareCountry': shareCountry,
        'shareLocation': shareLocation,
        'showOnBoard': showOnBoard,
        'crashReports': crashReports,
        'syncedMs': syncedMs,
        'lastPingMs': lastPingMs,
        'lastLocationMs': lastLocationMs,
        'avatar': avatar,
        'session': session?.toJson(),
      };

  factory AccountPrefs.fromJson(Map<String, dynamic> json) {
    const d = AccountPrefs();
    bool b(String key, bool fallback) {
      final v = json[key];
      return v is bool ? v : fallback;
    }

    int i(String key) {
      final v = json[key];
      return v is int ? v : 0;
    }

    final id = json['deviceId'];
    return AccountPrefs(
      deviceId: id is String ? id : d.deviceId,
      promptDone: b('promptDone', d.promptDone),
      syncOn: b('syncOn', d.syncOn),
      countMe: b('countMe', d.countMe),
      shareCountry: b('shareCountry', d.shareCountry),
      shareLocation: b('shareLocation', d.shareLocation),
      showOnBoard: b('showOnBoard', d.showOnBoard),
      crashReports: b('crashReports', d.crashReports),
      syncedMs: i('syncedMs'),
      lastPingMs: i('lastPingMs'),
      lastLocationMs: i('lastLocationMs'),
      avatar: json['avatar'] is String ? json['avatar'] as String : '',
      session: AccountSession.fromJson(json['session']),
    );
  }
}

/// A random id such as "3f9c1a7e-5b2d-4c80-9e11-0a6b7d2c4f58".
String newDeviceId([Random? random]) {
  final r = random ?? Random.secure();
  String hex(int n) =>
      List<String>.generate(n, (_) => r.nextInt(16).toRadixString(16)).join();
  return '${hex(8)}-${hex(4)}-4${hex(3)}-${hex(4)}-${hex(12)}';
}

/// Loads and saves [AccountPrefs] as `account.json`.
class AccountStore {
  AccountStore({NativeBridge bridge = const NativeBridge()}) : _bridge = bridge;

  final NativeBridge _bridge;

  Future<File?> _file() async {
    final dir = await _bridge.filesDir();
    if (dir.isEmpty) {
      return null;
    }
    return File('$dir${Platform.pathSeparator}account.json');
  }

  Future<AccountPrefs> load() async {
    try {
      final file = await _file();
      if (file != null && await file.exists()) {
        final json = jsonDecode(await file.readAsString());
        if (json is Map<String, dynamic>) {
          return AccountPrefs.fromJson(json);
        }
      }
    } on Exception {
      // A broken file is ignored; the defaults are used.
    }
    return const AccountPrefs();
  }

  Future<void> save(AccountPrefs prefs) async {
    try {
      final file = await _file();
      if (file == null) {
        return;
      }
      final temp = File('${file.path}.tmp');
      await temp.writeAsString(jsonEncode(prefs.toJson()), flush: true);
      await temp.rename(file.path);
    } on Exception {
      // Best effort.
    }
  }
}
