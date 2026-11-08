import 'package:flutter/services.dart';

/// Small helpers implemented in MainActivity.kt, so the app needs no
/// third-party plugins.
class NativeBridge {
  const NativeBridge();

  static const MethodChannel _channel =
      MethodChannel('space.astryl.app/native');

  /// The app's private files folder. It survives app updates and is only
  /// removed when the app is uninstalled. Empty when unknown.
  Future<String> filesDir() async {
    try {
      final result = await _channel.invokeMethod<String>('filesDir');
      return result ?? '';
    } on Exception {
      return '';
    }
  }

  /// Folder in the app cache where downloaded updates are kept.
  Future<String> updatesDir() async {
    try {
      final result = await _channel.invokeMethod<String>('updatesDir');
      return result ?? '';
    } on Exception {
      return '';
    }
  }

  /// Opens the Android installer for [path]. Returns "ok", "permission"
  /// (the user must first allow installs from Astryl) or "error".
  Future<String> installApk(String path) async {
    try {
      final result = await _channel
          .invokeMethod<String>('installApk', <String, String>{'path': path});
      return result ?? 'error';
    } on Exception {
      return 'error';
    }
  }

  /// Folder in the app cache for images the user shares.
  Future<String> sharedDir() async {
    try {
      final result = await _channel.invokeMethod<String>('sharedDir');
      return result ?? '';
    } on Exception {
      return '';
    }
  }

  /// Opens the Android share sheet with the PNG at [path] and [text].
  Future<bool> shareImage(String path, String text) async {
    try {
      final result = await _channel.invokeMethod<bool>(
          'shareImage', <String, String>{'path': path, 'text': text});
      return result ?? false;
    } on Exception {
      return false;
    }
  }

  /// Opens the Android share sheet with the file at [path] of type [mime].
  Future<bool> shareFile(String path, String mime, String text) async {
    try {
      final result = await _channel.invokeMethod<bool>('shareFile',
          <String, String>{'path': path, 'mime': mime, 'text': text});
      return result ?? false;
    } on Exception {
      return false;
    }
  }

  /// Lets the user pick a backup file and returns its text, or null when
  /// nothing was picked or the file could not be read.
  Future<String?> pickBackup() async {
    try {
      return await _channel.invokeMethod<String>('pickBackup');
    } on Exception {
      return null;
    }
  }

  /// The installed version name, for example "1.0.0". Empty when unknown.
  Future<String> appVersion() async {
    try {
      final result = await _channel.invokeMethod<String>('appVersion');
      return result ?? '';
    } on Exception {
      return '';
    }
  }

  /// Opens an https link in the browser. False when nothing could open it.
  Future<bool> openUrl(String url) async {
    try {
      final result = await _channel
          .invokeMethod<bool>('openUrl', <String, String>{'url': url});
      return result ?? false;
    } on Exception {
      return false;
    }
  }

  /// Asks for the notification permission when Android needs it. True when
  /// reminders can be shown.
  Future<bool> requestNotifications() async {
    try {
      final result = await _channel.invokeMethod<bool>('requestNotifications');
      return result ?? false;
    } on Exception {
      return false;
    }
  }

  /// Sets a reminder that shows [title] and [body] at [at]. [id] names it so
  /// it can be removed again. [channel] is the name Android shows for this
  /// kind of notification.
  Future<bool> scheduleReminder({
    required String id,
    required DateTime at,
    required String title,
    required String body,
    required String channel,
  }) async {
    try {
      final result = await _channel.invokeMethod<bool>(
        'scheduleReminder',
        <String, Object>{
          'id': id,
          'at': at.millisecondsSinceEpoch,
          'title': title,
          'body': body,
          'channel': channel,
        },
      );
      return result ?? false;
    } on Exception {
      return false;
    }
  }

  /// Removes the reminder named [id].
  Future<void> cancelReminder(String id) async {
    try {
      await _channel
          .invokeMethod<bool>('cancelReminder', <String, String>{'id': id});
    } on Exception {
      // Nothing to remove.
    }
  }
}
