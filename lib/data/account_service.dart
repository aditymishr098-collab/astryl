import 'dart:async';
import 'dart:convert';
import 'dart:io';

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

/// Talks to the "account" function on Supabase. Only the public key is used.
class AccountService {
  AccountService({this.userAgent = 'Astryl (github.com/aditymishr098-collab/astryl)'});

  final String userAgent;

  static const int _maxBytes = 256 * 1024;

  /// Calls [action] and returns the JSON answer. [token] is the user's own
  /// access token, needed for everything but signing up and logging in.
  Future<Map<String, dynamic>> call(
    String action, {
    Map<String, Object?> body = const <String, Object?>{},
    String? token,
  }) async {
    final uri = Uri.parse(accountApiUrl);
    if (uri.scheme != 'https') {
      throw const AccountException('server_error');
    }
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 12);
    try {
      final request = await client.postUrl(uri);
      request.headers
        ..set('Content-Type', 'application/json')
        ..set('Accept', 'application/json')
        ..set('User-Agent', userAgent)
        ..set('apikey', accountApiKey);
      if (token != null) {
        request.headers.set('x-astryl-token', token);
      }
      request.add(utf8.encode(jsonEncode(<String, Object?>{...body, 'action': action})));
      final response =
          await request.close().timeout(const Duration(seconds: 25));
      final bytes = <int>[];
      await for (final chunk
          in response.timeout(const Duration(seconds: 25))) {
        bytes.addAll(chunk);
        if (bytes.length > _maxBytes) {
          throw const AccountException('server_error');
        }
      }
      Object? json;
      try {
        json = jsonDecode(utf8.decode(bytes));
      } on FormatException {
        json = null;
      }
      if (response.statusCode == 200 && json is Map<String, dynamic>) {
        return json;
      }
      final error = json is Map ? json['error'] : null;
      throw AccountException(
          error is String ? error : 'server_error', response.statusCode);
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
}
