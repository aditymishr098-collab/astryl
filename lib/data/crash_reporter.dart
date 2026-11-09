import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'account_service.dart';
import 'native_bridge.dart';

/// One crash, as it is sent. It holds the error text, the app version and the
/// phone's Android build string. It holds no name, no account, no id and no
/// location.
class CrashReport {
  const CrashReport({
    required this.message,
    required this.stack,
    required this.version,
    required this.os,
    required this.locale,
  });

  static const int maxMessage = 400;
  static const int maxStack = 3000;

  final String message;
  final String stack;
  final String version;
  final String os;
  final String locale;

  /// Cuts [text] to [max] characters.
  static String clip(String text, int max) =>
      text.length <= max ? text : text.substring(0, max);

  factory CrashReport.from(
    Object error,
    StackTrace? stack, {
    required String version,
    required String os,
    required String locale,
  }) {
    return CrashReport(
      message: clip(error.toString(), maxMessage),
      stack: clip((stack ?? StackTrace.empty).toString(), maxStack),
      version: clip(version, 30),
      os: clip(os, 120),
      locale: clip(locale, 12),
    );
  }

  Map<String, String> toJson() => <String, String>{
        'message': message,
        'stack': stack,
        'version': version,
        'os': os,
        'locale': locale,
      };

  static CrashReport? fromJson(Object? json) {
    if (json is! Map) {
      return null;
    }
    String s(String key) => json[key] is String ? json[key] as String : '';
    final message = s('message');
    if (message.isEmpty) {
      return null;
    }
    return CrashReport(
      message: message,
      stack: s('stack'),
      version: s('version'),
      os: s('os'),
      locale: s('locale'),
    );
  }
}

/// Keeps crash reports and sends them to the project's own Supabase.
///
/// A crash may close the app before anything is sent, so every report is first
/// written to a small file on the phone and sent now or at the next start.
/// Nothing is kept or sent while [enabled] says no.
class CrashReporter {
  CrashReporter({
    required this.bridge,
    required this.enabled,
    required this.version,
    required this.locale,
    AccountService? service,
  }) : _service = service ?? AccountService();

  final NativeBridge bridge;
  final bool Function() enabled;
  final String Function() version;
  final String Function() locale;
  final AccountService _service;

  static const int maxQueue = 10;
  static const int maxPerRun = 5;

  int _seen = 0;
  bool _sending = false;

  Future<File?> _file() async {
    final dir = await bridge.filesDir();
    return dir.isEmpty ? null : File('$dir${Platform.pathSeparator}crashes.json');
  }

  Future<List<CrashReport>> _read() async {
    try {
      final file = await _file();
      if (file != null && await file.exists()) {
        final json = jsonDecode(await file.readAsString());
        if (json is List) {
          return <CrashReport>[
            for (final item in json)
              if (CrashReport.fromJson(item) case final r?) r,
          ];
        }
      }
    } on Exception {
      // A damaged file is the same as an empty one.
    }
    return <CrashReport>[];
  }

  Future<void> _write(List<CrashReport> list) async {
    try {
      final file = await _file();
      if (file == null) {
        return;
      }
      if (list.isEmpty) {
        if (await file.exists()) {
          await file.delete();
        }
        return;
      }
      await file.writeAsString(jsonEncode(<Object>[for (final r in list) r.toJson()]));
    } on Exception {
      // Reporting must never cause a second problem.
    }
  }

  /// Keeps one crash and tries to send it. Safe to call from an error handler.
  Future<void> record(Object error, StackTrace? stack) async {
    try {
      if (!enabled() || _seen >= maxPerRun) {
        return;
      }
      _seen++;
      final report = CrashReport.from(
        error,
        stack,
        version: version(),
        os: Platform.operatingSystemVersion,
        locale: locale(),
      );
      final queue = await _read();
      queue.add(report);
      while (queue.length > maxQueue) {
        queue.removeAt(0);
      }
      await _write(queue);
      unawaited(flush());
    } on Exception {
      // Never throw from here.
    }
  }

  /// Sends what is waiting. Reports that could not be sent stay for later.
  Future<void> flush() async {
    if (_sending || !enabled()) {
      return;
    }
    _sending = true;
    try {
      var queue = await _read();
      while (queue.isNotEmpty) {
        try {
          await _service.call('crash', body: queue.first.toJson());
        } on AccountException catch (e) {
          if (e.code == 'offline' || e.code == 'server_error') {
            return;
          }
          // The server refused this report (too big, rate limit): drop it.
        }
        queue = queue.sublist(1);
        await _write(queue);
      }
    } on Exception {
      // Try again at the next start.
    } finally {
      _sending = false;
    }
  }
}
