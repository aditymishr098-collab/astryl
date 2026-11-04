import 'dart:convert';

import 'settings.dart';

/// A backup is one small JSON file with the favourites, settings, quiz
/// scores, city and birth date. It is made on the phone and goes nowhere
/// unless the user sends it somewhere.

/// The newest file layout this version understands.
const int backupFormat = 1;

/// A backup is a few kilobytes; anything much bigger is not one.
const int maxBackupChars = 256 * 1024;

/// The text of a backup file for [settings].
String buildBackup(HelioraSettings settings, DateTime now, String appVersion) {
  return const JsonEncoder.withIndent('  ').convert(<String, Object>{
    'app': 'heliora',
    'format': backupFormat,
    'appVersion': appVersion,
    'createdMs': now.millisecondsSinceEpoch,
    'settings': settings.toJson(),
  });
}

/// Reads a backup file. Throws [FormatException] when [text] is not a
/// Heliora backup this version can read.
HelioraSettings parseBackup(String text) {
  if (text.length > maxBackupChars) {
    throw const FormatException('Too big for a backup');
  }
  final json = jsonDecode(text);
  if (json is! Map<String, dynamic> || json['app'] != 'heliora') {
    throw const FormatException('Not a Heliora backup');
  }
  final format = json['format'];
  if (format is! int || format < 1 || format > backupFormat) {
    throw const FormatException('Unknown backup version');
  }
  final settings = json['settings'];
  if (settings is! Map<String, dynamic>) {
    throw const FormatException('No settings in the backup');
  }
  return HelioraSettings.fromJson(settings);
}

/// True when [text] is a backup that can be restored.
bool isHelioraBackup(String text) {
  try {
    parseBackup(text);
    return true;
  } on FormatException {
    return false;
  }
}

/// What the phone keeps after restoring [backup] over [current].
///
/// The bells for single events are dropped: the alarms behind them live on
/// the old phone, so a bell that looks set would never ring. The daily note
/// about tonight's sky is a setting, so it comes back and sets itself again.
/// The time of the last update check belongs to this phone and stays.
HelioraSettings restoredSettings(
    HelioraSettings current, HelioraSettings backup) {
  return backup.copyWith(
    reminders: const <String>[],
    lastUpdateCheckMs: current.lastUpdateCheckMs,
  );
}
