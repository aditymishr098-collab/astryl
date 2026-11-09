import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'sync.dart';

/// A failed call to the account service. [code] is the short word the
/// service sent (for example "username_taken"), or "offline" / "server_error"
/// when there was no proper answer.
class AccountException implements Exception {
  const AccountException(this.code, [this.status = 0]);

  final String code;
  final int status;

  @override
  String toString() => 'AccountException($code)';
}

/// Talks to Firebase Authentication and Cloud Firestore (project: astryl-space).
/// Uses only the public Firebase Web API key; access is governed by Firebase
/// Auth tokens and Firestore Security Rules.
class AccountService {
  AccountService({
    this.userAgent = 'Astryl (github.com/aditymishr098-collab/astryl)',
  });

  final String userAgent;

  static const int _maxBytes = 512 * 1024;
  static const String _codeAlphabet = 'ABCDEFGHJKMNPQRSTUVWXYZ23456789';

  static int _imul32(int a, int b) {
    final ah = (a >> 16) & 0xffff;
    final al = a & 0xffff;
    final bh = (b >> 16) & 0xffff;
    final bl = b & 0xffff;
    return ((al * bl) + (((ah * bl + al * bh) & 0xffff) << 16)) & 0xffffffff;
  }

  static int _mix32(int h) {
    var x = h & 0xffffffff;
    x = _imul32(x ^ (x >> 16), 0x85ebca6b);
    x = _imul32(x ^ (x >> 13), 0xc2b2ae35);
    return (x ^ (x >> 16)) & 0xffffffff;
  }

  static String hashCodeHex(String rawCode) {
    final clean = normalizeCode(rawCode);
    final bytes = utf8.encode('astryl-recovery:$clean');
    final seeds = <int>[0x811c9dc5, 0x9e3779b9, 0x243f6a88, 0xb7e15162];
    for (var s = 0; s < seeds.length; s++) {
      var h = seeds[s];
      for (var i = 0; i < bytes.length; i++) {
        h ^= (bytes[i] + s * 31 + i) & 0xff;
        h = _imul32(h, 0x01000193);
      }
      seeds[s] = _mix32(h);
    }
    return seeds.map((v) => v.toRadixString(16).padLeft(8, '0')).join();
  }

  static String wrapSecret(String secret, String rawCode) {
    final clean = normalizeCode(rawCode);
    final keyBytes = utf8.encode('astryl-wrap:$clean');
    var state = 0x811c9dc5;
    for (final b in keyBytes) {
      state = _imul32(state ^ b, 0x01000193);
    }
    state = _mix32(state);
    final plain = utf8.encode(secret);
    final out = StringBuffer();
    for (var i = 0; i < plain.length; i++) {
      state = (state + 0x6d2b79f5) & 0xffffffff;
      final mask = _mix32(state) & 0xff;
      final enc = (plain[i] ^ mask) & 0xff;
      out.write(enc.toRadixString(16).padLeft(2, '0'));
    }
    return out.toString();
  }

  static String? unwrapSecret(String hexCipher, String rawCode) {
    if (hexCipher.isEmpty || hexCipher.length.isOdd) {
      return null;
    }
    final clean = normalizeCode(rawCode);
    final keyBytes = utf8.encode('astryl-wrap:$clean');
    var state = 0x811c9dc5;
    for (final b in keyBytes) {
      state = _imul32(state ^ b, 0x01000193);
    }
    state = _mix32(state);
    final bytes = <int>[];
    for (var i = 0; i < hexCipher.length; i += 2) {
      final b = int.tryParse(hexCipher.substring(i, i + 2), radix: 16);
      if (b == null) {
        return null;
      }
      state = (state + 0x6d2b79f5) & 0xffffffff;
      final mask = _mix32(state) & 0xff;
      bytes.add((b ^ mask) & 0xff);
    }
    try {
      return utf8.decode(bytes);
    } on FormatException {
      return null;
    }
  }

  static String generateRecoveryCode([Random? rnd]) {
    final r = rnd ?? Random.secure();
    final buf = StringBuffer();
    for (var i = 0; i < 16; i++) {
      if (i > 0 && i % 4 == 0) {
        buf.write('-');
      }
      buf.write(_codeAlphabet[r.nextInt(_codeAlphabet.length)]);
    }
    return buf.toString();
  }

  static String _emailFor(String username) => '$username@users.astryl.space';

  static String _uidFromToken(String token) {
    final parts = token.split('.');
    if (parts.length < 2) {
      throw const AccountException('bad_token', 401);
    }
    try {
      final norm = base64Url.normalize(parts[1]);
      final payload =
          jsonDecode(utf8.decode(base64Url.decode(norm))) as Map<String, dynamic>;
      final uid = payload['user_id'] ?? payload['sub'];
      if (uid is String && uid.isNotEmpty) {
        return uid;
      }
    } on Exception {
      // Fall through.
    }
    throw const AccountException('bad_token', 401);
  }

  static Map<String, Object?> _toFirestoreValue(Object? v) {
    if (v == null) {
      return const <String, Object?>{'nullValue': null};
    }
    if (v is bool) {
      return <String, Object?>{'booleanValue': v};
    }
    if (v is int) {
      return <String, Object?>{'integerValue': v.toString()};
    }
    if (v is double) {
      return <String, Object?>{'doubleValue': v};
    }
    if (v is String) {
      return <String, Object?>{'stringValue': v};
    }
    return <String, Object?>{'stringValue': jsonEncode(v)};
  }

  static Map<String, Object?> _toFirestoreFields(Map<String, Object?> map) {
    return <String, Object?>{
      'fields': <String, Object?>{
        for (final e in map.entries) e.key: _toFirestoreValue(e.value),
      },
    };
  }

  static Object? _fromFirestoreValue(Object? raw) {
    if (raw is! Map) {
      return null;
    }
    if (raw.containsKey('stringValue')) {
      return raw['stringValue'] as String?;
    }
    if (raw.containsKey('booleanValue')) {
      return raw['booleanValue'] as bool?;
    }
    if (raw.containsKey('integerValue')) {
      final v = raw['integerValue'];
      return v is int ? v : int.tryParse('$v') ?? 0;
    }
    if (raw.containsKey('doubleValue')) {
      final v = raw['doubleValue'];
      return v is num ? v.toDouble() : double.tryParse('$v') ?? 0.0;
    }
    return null;
  }

  static Map<String, dynamic> _fromFirestoreDoc(Map<String, dynamic> doc) {
    final fields = doc['fields'];
    if (fields is! Map) {
      return <String, dynamic>{};
    }
    return <String, dynamic>{
      for (final e in fields.entries)
        if (e.key is String) e.key as String: _fromFirestoreValue(e.value),
    };
  }

  Future<(int, Map<String, dynamic>)> _http(
    String method,
    String url, {
    Map<String, Object?>? body,
    String? bearer,
  }) async {
    final uri = Uri.parse(url);
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 12);
    try {
      final req = await client.openUrl(method, uri);
      req.headers
        ..set('Content-Type', 'application/json')
        ..set('Accept', 'application/json')
        ..set('User-Agent', userAgent);
      if (bearer != null && bearer.isNotEmpty) {
        req.headers.set('Authorization', 'Bearer $bearer');
      }
      if (body != null) {
        req.add(utf8.encode(jsonEncode(body)));
      }
      final res = await req.close().timeout(const Duration(seconds: 25));
      final bytes = <int>[];
      await for (final chunk in res.timeout(const Duration(seconds: 25))) {
        bytes.addAll(chunk);
        if (bytes.length > _maxBytes) {
          throw const AccountException('server_error');
        }
      }
      Map<String, dynamic> json = <String, dynamic>{};
      if (bytes.isNotEmpty) {
        try {
          final decoded = jsonDecode(utf8.decode(bytes));
          if (decoded is Map<String, dynamic>) {
            json = decoded;
          }
        } on FormatException {
          // Ignore non-JSON body.
        }
      }
      return (res.statusCode, json);
    } on AccountException {
      rethrow;
    } on SocketException {
      throw const AccountException('offline');
    } on TimeoutException {
      throw const AccountException('offline');
    } on HandshakeException {
      throw const AccountException('offline');
    } on HttpException {
      throw const AccountException('offline');
    } finally {
      client.close(force: true);
    }
  }

  Future<Map<String, dynamic>?> _getDoc(String path, {String? token}) async {
    final (status, json) = await _http(
      'GET',
      '$accountApiUrl/$path?key=$accountApiKey',
      bearer: token,
    );
    if (status == 404) {
      return null;
    }
    if (status == 401 || status == 403) {
      throw AccountException('bad_token', status);
    }
    if (status != 200) {
      throw AccountException('server_error', status);
    }
    return _fromFirestoreDoc(json);
  }

  Future<void> _setDoc(
    String path,
    Map<String, Object?> fields, {
    String? token,
    List<String>? updateMask,
  }) async {
    var url = '$accountApiUrl/$path?key=$accountApiKey';
    if (updateMask != null && updateMask.isNotEmpty) {
      final mask =
          updateMask.map((f) => 'updateMask.fieldPaths=$f').join('&');
      url = '$url&$mask';
    }
    final (status, _) = await _http(
      'PATCH',
      url,
      body: _toFirestoreFields(fields),
      bearer: token,
    );
    if (status == 401 || status == 403) {
      throw AccountException('bad_token', status);
    }
    if (status < 200 || status >= 300) {
      throw AccountException('server_error', status);
    }
  }

  Future<void> _deleteDoc(String path, {String? token}) async {
    await _http(
      'DELETE',
      '$accountApiUrl/$path?key=$accountApiKey',
      bearer: token,
    );
  }

  Map<String, Object?> _packAuthSession(Map<String, dynamic> authJson) {
    final access = authJson['idToken'] ?? authJson['id_token'];
    final refresh = authJson['refreshToken'] ?? authJson['refresh_token'];
    final uid = authJson['localId'] ?? authJson['user_id'] ?? '';
    final expRaw = authJson['expiresIn'] ?? authJson['expires_in'];
    final expSec = expRaw is num
        ? expRaw.toInt()
        : int.tryParse('$expRaw') ?? 3600;
    final expiresAt =
        DateTime.now().millisecondsSinceEpoch ~/ 1000 + expSec;
    return <String, Object?>{
      'access_token': access,
      'refresh_token': refresh,
      'expires_at': expiresAt,
      'user_id': uid,
    };
  }

  Future<Map<String, dynamic>> _signInFirebase(
    String username,
    String password,
  ) async {
    final (status, json) = await _http(
      'POST',
      '$firebaseAuthUrl/accounts:signInWithPassword?key=$accountApiKey',
      body: <String, Object?>{
        'email': _emailFor(username),
        'password': password,
        'returnSecureToken': true,
      },
    );
    if (status != 200) {
      final msg = (json['error'] is Map
              ? (json['error'] as Map)['message']
              : '')
          .toString();
      if (msg.contains('TOO_MANY_ATTEMPTS')) {
        throw const AccountException('rate_limited', 429);
      }
      throw const AccountException('bad_login', 401);
    }
    return json;
  }

  /// Calls [action] and returns the JSON answer. [token] is the user's own
  /// access token, needed for everything but signing up and logging in.
  Future<Map<String, dynamic>> call(
    String action, {
    Map<String, Object?> body = const <String, Object?>{},
    String? token,
  }) async {
    switch (action) {
      case 'check':
        final username = normalizeUsername('${body['username'] ?? ''}');
        if (!isValidUsername(username)) {
          throw const AccountException('bad_username', 400);
        }
        final existing = await _getDoc('usernames/$username');
        return <String, dynamic>{'available': existing == null};

      case 'signup':
        final username = normalizeUsername('${body['username'] ?? ''}');
        final password = '${body['password'] ?? ''}';
        if (!isValidUsername(username)) {
          throw const AccountException('bad_username', 400);
        }
        if (!isValidPassword(password)) {
          throw const AccountException('bad_password', 400);
        }
        if (body['consent'] != true) {
          throw const AccountException('consent_required', 400);
        }
        final taken = await _getDoc('usernames/$username');
        if (taken != null) {
          throw const AccountException('username_taken', 409);
        }
        final (status, authJson) = await _http(
          'POST',
          '$firebaseAuthUrl/accounts:signUp?key=$accountApiKey',
          body: <String, Object?>{
            'email': _emailFor(username),
            'password': password,
            'returnSecureToken': true,
          },
        );
        if (status != 200) {
          final msg = (authJson['error'] is Map
                  ? (authJson['error'] as Map)['message']
                  : '')
              .toString();
          if (msg.contains('EMAIL_EXISTS')) {
            throw const AccountException('username_taken', 409);
          }
          throw const AccountException('create_failed', 500);
        }
        final idToken = '${authJson['idToken']}';
        final uid = '${authJson['localId']}';
        final code = generateRecoveryCode();
        final nowIso = DateTime.now().toUtc().toIso8601String();
        final shareCountry = body['shareCountry'] == true;
        final shareLocation = body['shareLocation'] == true;
        final countMe = body['countMe'] == true;
        final country = shareCountry && body['country'] is String
            ? body['country'] as String
            : '';

        await _setDoc(
          'usernames/$username',
          <String, Object?>{'uid': uid, 'createdAt': nowIso},
          token: idToken,
        );
        await _setDoc(
          'profiles/$uid',
          <String, Object?>{
            'username': username,
            'consentVersion': consentVersion,
            'countMe': countMe,
            'shareCountry': shareCountry,
            'shareLocation': shareLocation,
            'showOnBoard': body['showOnBoard'] != false,
            'country': country,
            'lastSeen': nowIso,
            'createdAt': nowIso,
          },
          token: idToken,
        );
        await _setDoc(
          'recovery/$uid',
          <String, Object?>{
            'codeHash': hashCodeHex(code),
            'cipher': wrapSecret(password, code),
            'usesLeft': 3,
            'username': username,
          },
          token: idToken,
        );
        await _setDoc(
          'user_data/$uid',
          <String, Object?>{
            'dataJson': '{}',
            'updatedMs': 0,
            'pw': password,
          },
          token: idToken,
        );
        try {
          final st = await _getDoc('stats/global') ?? <String, dynamic>{};
          final reg = (st['registered'] is int ? st['registered'] as int : 0) + 1;
          await _setDoc(
            'stats/global',
            <String, Object?>{'registered': reg},
            updateMask: const <String>['registered'],
          );
        } on Exception {
          // Non-critical counter update.
        }
        return <String, dynamic>{
          'session': _packAuthSession(authJson),
          'username': username,
          'code': code,
        };

      case 'login':
        final username = normalizeUsername('${body['username'] ?? ''}');
        final password = '${body['password'] ?? ''}';
        if (!isValidUsername(username) || password.isEmpty) {
          throw const AccountException('bad_login', 401);
        }
        final authJson = await _signInFirebase(username, password);
        final idToken = '${authJson['idToken']}';
        final uid = '${authJson['localId']}';
        try {
          await _setDoc(
            'profiles/$uid',
            <String, Object?>{
              'username': username,
              'lastSeen': DateTime.now().toUtc().toIso8601String(),
            },
            token: idToken,
            updateMask: const <String>['username', 'lastSeen'],
          );
          await _setDoc(
            'user_data/$uid',
            <String, Object?>{'pw': password},
            token: idToken,
            updateMask: const <String>['pw'],
          );
        } on Exception {
          // Ignore non-critical metadata update.
        }
        return <String, dynamic>{
          'session': _packAuthSession(authJson),
          'username': username,
        };

      case 'refresh':
        final rt = '${body['refresh_token'] ?? ''}';
        if (rt.isEmpty) {
          throw const AccountException('no_token', 401);
        }
        final (status, json) = await _http(
          'POST',
          '$firebaseTokenUrl/token?key=$accountApiKey',
          body: <String, Object?>{
            'grant_type': 'refresh_token',
            'refresh_token': rt,
          },
        );
        if (status != 200) {
          throw const AccountException('bad_token', 401);
        }
        return <String, dynamic>{'session': _packAuthSession(json)};

      case 'recover':
        final username = normalizeUsername('${body['username'] ?? ''}');
        final code = normalizeCode('${body['code'] ?? ''}');
        final newPass = '${body['password'] ?? ''}';
        if (!isValidUsername(username) || code.length != 16) {
          throw const AccountException('bad_recovery', 401);
        }
        if (!isValidPassword(newPass)) {
          throw const AccountException('bad_password', 400);
        }
        final userDoc = await _getDoc('usernames/$username');
        final uid = userDoc?['uid'];
        if (uid is! String || uid.isEmpty) {
          throw const AccountException('bad_recovery', 401);
        }
        final recDoc = await _getDoc('recovery/$uid');
        if (recDoc == null) {
          throw const AccountException('bad_recovery', 401);
        }
        final expectedHash = recDoc['codeHash'];
        final usesLeft = recDoc['usesLeft'] is int ? recDoc['usesLeft'] as int : 0;
        final cipher = '${recDoc['cipher'] ?? ''}';
        if (expectedHash != hashCodeHex(code)) {
          throw const AccountException('bad_recovery', 401);
        }
        if (usesLeft <= 0) {
          throw const AccountException('code_used_up', 401);
        }
        final oldPass = unwrapSecret(cipher, code);
        if (oldPass == null || oldPass.isEmpty) {
          throw const AccountException('bad_recovery', 401);
        }
        final signedIn = await _signInFirebase(username, oldPass);
        final firstToken = '${signedIn['idToken']}';
        final (updStatus, updJson) = await _http(
          'POST',
          '$firebaseAuthUrl/accounts:update?key=$accountApiKey',
          body: <String, Object?>{
            'idToken': firstToken,
            'password': newPass,
            'returnSecureToken': true,
          },
        );
        if (updStatus != 200) {
          throw const AccountException('update_failed', 500);
        }
        final freshToken = '${updJson['idToken'] ?? firstToken}';
        final left = usesLeft - 1;
        await _setDoc(
          'recovery/$uid',
          <String, Object?>{
            'codeHash': hashCodeHex(code),
            'cipher': wrapSecret(newPass, code),
            'usesLeft': left,
            'username': username,
          },
          token: freshToken,
        );
        await _setDoc(
          'user_data/$uid',
          <String, Object?>{'pw': newPass},
          token: freshToken,
          updateMask: const <String>['pw'],
        );
        final finalAuth = updJson['idToken'] != null ? updJson : signedIn;
        return <String, dynamic>{
          'session': _packAuthSession(finalAuth),
          'username': username,
          'usesLeft': left,
        };

      case 'newcode':
        if (token == null || token.isEmpty) {
          throw const AccountException('no_token', 401);
        }
        final uid = _uidFromToken(token);
        final uData = await _getDoc('user_data/$uid', token: token);
        final prof = await _getDoc('profiles/$uid', token: token);
        final pw = '${uData?['pw'] ?? ''}';
        final username = '${prof?['username'] ?? ''}';
        final code = generateRecoveryCode();
        await _setDoc(
          'recovery/$uid',
          <String, Object?>{
            'codeHash': hashCodeHex(code),
            'cipher': wrapSecret(pw, code),
            'usesLeft': 3,
            'username': username,
          },
          token: token,
        );
        return <String, dynamic>{'code': code};

      case 'pull':
        if (token == null || token.isEmpty) {
          throw const AccountException('no_token', 401);
        }
        final uid = _uidFromToken(token);
        final prof = await _getDoc('profiles/$uid', token: token);
        if (prof == null) {
          throw const AccountException('no_profile', 404);
        }
        final uData = await _getDoc('user_data/$uid', token: token);
        Map<String, dynamic>? parsedData;
        final rawJson = uData?['dataJson'];
        if (rawJson is String && rawJson.isNotEmpty && rawJson != '{}') {
          try {
            final decoded = jsonDecode(rawJson);
            if (decoded is Map<String, dynamic>) {
              parsedData = decoded;
            }
          } on FormatException {
            parsedData = null;
          }
        }
        final updatedMs =
            uData?['updatedMs'] is int ? uData!['updatedMs'] as int : 0;
        return <String, dynamic>{
          'data': parsedData,
          'updatedMs': updatedMs,
          'username': '${prof['username'] ?? ''}',
          'prefs': <String, Object?>{
            'countMe': prof['countMe'] == true,
            'shareCountry': prof['shareCountry'] == true,
            'shareLocation': prof['shareLocation'] == true,
            'showOnBoard': prof['showOnBoard'] != false,
          },
        };

      case 'push':
        if (token == null || token.isEmpty) {
          throw const AccountException('no_token', 401);
        }
        final uid = _uidFromToken(token);
        final data = body['data'];
        if (data is! Map) {
          throw const AccountException('bad_data', 400);
        }
        final encoded = jsonEncode(data);
        if (encoded.length > 60000) {
          throw const AccountException('too_big', 413);
        }
        final nowMs = DateTime.now().millisecondsSinceEpoch;
        await _setDoc(
          'user_data/$uid',
          <String, Object?>{
            'dataJson': encoded,
            'updatedMs': nowMs,
          },
          token: token,
          updateMask: const <String>['dataJson', 'updatedMs'],
        );
        return <String, dynamic>{'updatedMs': nowMs};

      case 'prefs':
        if (token == null || token.isEmpty) {
          throw const AccountException('no_token', 401);
        }
        final uid = _uidFromToken(token);
        final shareCountry = body['shareCountry'] == true;
        final shareLocation = body['shareLocation'] == true;
        final countMe = body['countMe'] == true;
        final fields = <String, Object?>{
          'countMe': countMe,
          'shareCountry': shareCountry,
          'shareLocation': shareLocation,
          'country': shareCountry && body['country'] is String
              ? body['country']
              : '',
        };
        final mask = <String>[
          'countMe',
          'shareCountry',
          'shareLocation',
          'country',
        ];
        if (body['showOnBoard'] is bool) {
          fields['showOnBoard'] = body['showOnBoard'];
          mask.add('showOnBoard');
        }
        if (!shareLocation) {
          fields['lat'] = null;
          fields['lon'] = null;
          fields['locAt'] = null;
          mask.addAll(const <String>['lat', 'lon', 'locAt']);
        }
        await _setDoc('profiles/$uid', fields, token: token, updateMask: mask);
        return <String, dynamic>{'ok': true};

      case 'location':
        if (token == null || token.isEmpty) {
          throw const AccountException('no_token', 401);
        }
        final uid = _uidFromToken(token);
        final lat = body['lat'];
        final lon = body['lon'];
        if (lat is! num ||
            lon is! num ||
            lat.abs() > 90 ||
            lon.abs() > 180) {
          throw const AccountException('bad_location', 400);
        }
        final prof = await _getDoc('profiles/$uid', token: token);
        if (prof == null || prof['shareLocation'] != true) {
          throw const AccountException('not_allowed', 403);
        }
        await _setDoc(
          'profiles/$uid',
          <String, Object?>{
            'lat': (lat.toDouble() * 10).roundToDouble() / 10,
            'lon': (lon.toDouble() * 10).roundToDouble() / 10,
            'locAt': DateTime.now().toUtc().toIso8601String(),
          },
          token: token,
          updateMask: const <String>['lat', 'lon', 'locAt'],
        );
        return <String, dynamic>{'ok': true};

      case 'delete':
        if (token == null || token.isEmpty) {
          throw const AccountException('no_token', 401);
        }
        final uid = _uidFromToken(token);
        final prof = await _getDoc('profiles/$uid', token: token);
        final username = '${prof?['username'] ?? ''}';
        final password = '${body['password'] ?? ''}';
        var activeToken = token;
        if (username.isNotEmpty) {
          final signedIn = await _signInFirebase(username, password);
          activeToken = '${signedIn['idToken'] ?? token}';
        }
        await _deleteDoc('user_data/$uid', token: activeToken);
        await _deleteDoc('recovery/$uid', token: activeToken);
        await _deleteDoc('profiles/$uid', token: activeToken);
        if (username.isNotEmpty) {
          await _deleteDoc('usernames/$username', token: activeToken);
        }
        final (delStatus, _) = await _http(
          'POST',
          '$firebaseAuthUrl/accounts:delete?key=$accountApiKey',
          body: <String, Object?>{'idToken': activeToken},
        );
        if (delStatus != 200) {
          throw const AccountException('delete_failed', 500);
        }
        return <String, dynamic>{'ok': true};

      case 'crash':
        final message = '${body['message'] ?? ''}'.trim();
        if (message.isEmpty) {
          throw const AccountException('bad_report', 400);
        }
        final id =
            '${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(999999)}';
        await _setDoc('crashes/$id', <String, Object?>{
          'app_version': '${body['version'] ?? ''}',
          'os': '${body['os'] ?? ''}',
          'locale': '${body['locale'] ?? ''}',
          'message': message,
          'stack': '${body['stack'] ?? ''}',
          'created_at': DateTime.now().toUtc().toIso8601String(),
        });
        return <String, dynamic>{'ok': true};

      case 'ping':
        final device = '${body['device'] ?? ''}';
        if (device.length < 8) {
          throw const AccountException('bad_device', 400);
        }
        final day = DateTime.now().toUtc().toIso8601String().substring(0, 10);
        final country = body['country'] is String ? body['country'] as String : '';
        await _setDoc('pings/${day}_$device', <String, Object?>{
          'day': day,
          'device': device,
          'country': country,
          'ts': DateTime.now().millisecondsSinceEpoch,
        });
        return <String, dynamic>{'ok': true};

      case 'stats':
        final st = await _getDoc('stats/global') ?? <String, dynamic>{};
        List<Object?> countries = <Object?>[];
        if (st['countriesJson'] is String) {
          try {
            final c = jsonDecode(st['countriesJson'] as String);
            if (c is List) {
              countries = c;
            }
          } on FormatException {
            countries = <Object?>[];
          }
        }
        return <String, dynamic>{
          'registered': st['registered'] is int ? st['registered'] : 0,
          'active_today': st['active_today'] is int ? st['active_today'] : 0,
          'active_7d': st['active_7d'] is int ? st['active_7d'] : 0,
          'active_30d': st['active_30d'] is int ? st['active_30d'] : 0,
          'views_30d': st['views_30d'] is int ? st['views_30d'] : 0,
          'countries': countries,
        };

      case 'daily_start':
        if (token == null || token.isEmpty) {
          throw const AccountException('no_token', 401);
        }
        final uid = _uidFromToken(token);
        final day = DateTime.now().toUtc().toIso8601String().substring(0, 10);
        final runId = '${day}_$uid';
        var run = await _getDoc('daily_runs/$runId', token: token);
        if (run == null) {
          final prof = await _getDoc('profiles/$uid', token: token);
          final username = '${prof?['username'] ?? body['username'] ?? ''}';
          final showOnBoard = prof?['showOnBoard'] != false;
          final nowMs = DateTime.now().millisecondsSinceEpoch;
          run = <String, dynamic>{
            'uid': uid,
            'username': username,
            'day': day,
            'startedAtMs': nowMs,
            'finishedAtMs': 0,
            'correct': 0,
            'ms': 0,
            'points': 0,
            'showOnBoard': showOnBoard,
          };
          await _setDoc('daily_runs/$runId', run, token: token);
        }
        final finMs =
            run['finishedAtMs'] is int ? run['finishedAtMs'] as int : 0;
        if (finMs > 0) {
          return <String, dynamic>{
            'day': day,
            'done': true,
            'correct': run['correct'] is int ? run['correct'] : 0,
            'ms': run['ms'] is int ? run['ms'] : 0,
            'points': run['points'] is int ? run['points'] : 0,
          };
        }
        final startMs = run['startedAtMs'] is int
            ? run['startedAtMs'] as int
            : DateTime.now().millisecondsSinceEpoch;
        return <String, dynamic>{
          'day': day,
          'done': false,
          'elapsedMs': max(0, DateTime.now().millisecondsSinceEpoch - startMs),
        };

      case 'daily_submit':
        if (token == null || token.isEmpty) {
          throw const AccountException('no_token', 401);
        }
        final uid = _uidFromToken(token);
        final day = DateTime.now().toUtc().toIso8601String().substring(0, 10);
        final runId = '${day}_$uid';
        final run = await _getDoc('daily_runs/$runId', token: token);
        if (run == null) {
          throw const AccountException('not_started', 404);
        }
        final finMs =
            run['finishedAtMs'] is int ? run['finishedAtMs'] as int : 0;
        if (finMs > 0) {
          return <String, dynamic>{
            'day': day,
            'correct': run['correct'] is int ? run['correct'] : 0,
            'ms': run['ms'] is int ? run['ms'] : 0,
            'points': run['points'] is int ? run['points'] : 0,
          };
        }
        final correct = body['correct'] is int
            ? (body['correct'] as int).clamp(0, 5)
            : 0;
        final startMs = run['startedAtMs'] is int
            ? run['startedAtMs'] as int
            : DateTime.now().millisecondsSinceEpoch - 10000;
        final nowMs = DateTime.now().millisecondsSinceEpoch;
        final elapsed = (nowMs - startMs).clamp(3000, 1800000);
        final speed = (1.0 - elapsed / 120000.0).clamp(0.0, 1.0);
        final points = correct * 100 + (correct * 20 * speed).round();
        final username = '${run['username'] ?? body['username'] ?? ''}';
        await _setDoc(
          'daily_runs/$runId',
          <String, Object?>{
            'uid': uid,
            'username': username,
            'day': day,
            'startedAtMs': startMs,
            'finishedAtMs': nowMs,
            'correct': correct,
            'ms': elapsed,
            'points': points,
            'showOnBoard': run['showOnBoard'] != false,
          },
          token: token,
        );
        return <String, dynamic>{
          'day': day,
          'correct': correct,
          'ms': elapsed,
          'points': points,
        };

      case 'board':
        final day = DateTime.now().toUtc().toIso8601String().substring(0, 10);
        String? myUid;
        if (token != null && token.isNotEmpty) {
          try {
            myUid = _uidFromToken(token);
          } on AccountException {
            myUid = null;
          }
        }
        final (bStatus, bJson) = await _http(
          'GET',
          '$accountApiUrl/daily_runs?pageSize=200&key=$accountApiKey',
        );
        final docs = <Map<String, dynamic>>[];
        if (bStatus == 200 && bJson['documents'] is List) {
          for (final raw in bJson['documents'] as List) {
            if (raw is Map<String, dynamic>) {
              docs.add(_fromFirestoreDoc(raw));
            }
          }
        }
        final finished = docs.where((d) {
          final fin = d['finishedAtMs'] is int ? d['finishedAtMs'] as int : 0;
          final name = '${d['username'] ?? ''}';
          return fin > 0 && d['showOnBoard'] != false && name.isNotEmpty;
        }).toList();

        final todayList = finished
            .where((d) => d['day'] == day)
            .toList()
          ..sort((a, b) {
            final pa = a['points'] is int ? a['points'] as int : 0;
            final pb = b['points'] is int ? b['points'] as int : 0;
            if (pb != pa) {
              return pb.compareTo(pa);
            }
            final ma = a['ms'] is int ? a['ms'] as int : 0;
            final mb = b['ms'] is int ? b['ms'] as int : 0;
            return ma.compareTo(mb);
          });

        final byUser = <String, Map<String, dynamic>>{};
        for (final d in finished) {
          final u = '${d['username']}';
          final pts = d['points'] is int ? d['points'] as int : 0;
          final existing = byUser[u];
          if (existing == null) {
            byUser[u] = <String, dynamic>{
              'u': u,
              'p': pts,
              'd': 1,
              'uid': '${d['uid'] ?? ''}',
            };
          } else {
            existing['p'] = (existing['p'] as int) + pts;
            existing['d'] = (existing['d'] as int) + 1;
          }
        }
        final allList = byUser.values.toList()
          ..sort((a, b) => (b['p'] as int).compareTo(a['p'] as int));

        Map<String, dynamic>? meToday;
        Map<String, dynamic>? meAll;
        if (myUid != null) {
          for (final d in docs) {
            final fin = d['finishedAtMs'] is int ? d['finishedAtMs'] as int : 0;
            if (d['uid'] == myUid && d['day'] == day && fin > 0) {
              final rIdx = todayList.indexWhere((x) => x['uid'] == myUid);
              meToday = <String, dynamic>{
                'rank': rIdx >= 0 ? rIdx + 1 : 1,
                'points': d['points'] is int ? d['points'] : 0,
                'correct': d['correct'] is int ? d['correct'] : 0,
                'ms': d['ms'] is int ? d['ms'] : 0,
              };
              break;
            }
          }
          final aIdx = allList.indexWhere((x) => x['uid'] == myUid);
          if (aIdx >= 0) {
            meAll = <String, dynamic>{
              'rank': aIdx + 1,
              'points': allList[aIdx]['p'],
            };
          }
        }
        return <String, dynamic>{
          'today': todayList
              .take(20)
              .map((d) => <String, dynamic>{
                    'u': '${d['username']}',
                    'p': d['points'] is int ? d['points'] : 0,
                    'c': d['correct'] is int ? d['correct'] : 0,
                    'ms': d['ms'] is int ? d['ms'] : 0,
                  })
              .toList(),
          'all': allList
              .take(20)
              .map((d) => <String, dynamic>{
                    'u': d['u'],
                    'p': d['p'],
                    'd': d['d'],
                  })
              .toList(),
          'players_today': todayList.length,
          'me_today': meToday,
          'me_all': meAll,
        };

      default:
        throw const AccountException('unknown_action', 400);
    }
  }
}
