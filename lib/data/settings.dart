import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'native_bridge.dart';

/// Which solar-system view the Explore tab shows.
enum ViewMode { flat, globe }

/// The text sizes offered in Settings, in percent. Larger sizes would break
/// the fixed layouts of some screens, so 130 is the limit.
const List<int> textScaleChoices = <int>[100, 115, 130];

/// The languages the app is translated into. An empty code means the
/// language of the phone.
const Set<String> supportedLocaleCodes = <String>{'', 'en', 'hi'};

/// Everything Heliora remembers. Stored as one small JSON file in the app's
/// private folder, which Android keeps when the app is updated.
@immutable
class HelioraSettings {
  const HelioraSettings({
    this.themeMode = ThemeMode.system,
    this.localeCode = '',
    this.viewMode = ViewMode.flat,
    this.autoUpdateCheck = true,
    this.lastUpdateCheckMs = 0,
    this.bestQuizScore = 0,
    this.birthDateMs = 0,
    this.cityId = '',
    this.reminders = const <String>[],
    this.onlineFeatures = false,
    this.quizBests = const <String, int>{},
    this.tonightAlert = false,
    this.tonightMinutes = 1200,
    this.favorites = const <String>[],
    this.textScalePercent = 100,
  });

  final ThemeMode themeMode;

  /// Empty means "follow the phone's language".
  final String localeCode;
  final ViewMode viewMode;
  final bool autoUpdateCheck;
  final int lastUpdateCheckMs;
  final int bestQuizScore;

  /// The user's birth date for "your age on other planets", or 0 when not
  /// set. It never leaves the phone.
  final int birthDateMs;

  /// The city for "Tonight's sky", or empty when not chosen.
  final String cityId;

  /// Ids of the space events the user asked to be reminded about.
  final List<String> reminders;

  /// True when the user allowed the optional online features (space station
  /// and rocket launches). Off by default.
  final bool onlineFeatures;

  /// Best quiz score for each level, keyed by the level name (easy, medium,
  /// hard). The older single [bestQuizScore] counts as the medium score.
  final Map<String, int> quizBests;

  /// True when a note about tonight's sky should be shown every evening.
  final bool tonightAlert;

  /// When that note is shown, in minutes after midnight (1200 = 20:00).
  final int tonightMinutes;

  /// Keys of the planets, missions and spacecraft the user starred (see
  /// favorites.dart).
  final List<String> favorites;

  /// Text size chosen in Settings, in percent: 100, 115 or 130.
  final int textScalePercent;

  /// The best score of a quiz level, 0 when not played yet.
  int bestFor(String level) {
    final saved = quizBests[level];
    if (saved != null) {
      return saved;
    }
    return level == 'medium' ? bestQuizScore : 0;
  }

  DateTime? get birthDate => birthDateMs == 0
      ? null
      : DateTime.fromMillisecondsSinceEpoch(birthDateMs);

  HelioraSettings copyWith({
    ThemeMode? themeMode,
    String? localeCode,
    ViewMode? viewMode,
    bool? autoUpdateCheck,
    int? lastUpdateCheckMs,
    int? bestQuizScore,
    int? birthDateMs,
    String? cityId,
    List<String>? reminders,
    bool? onlineFeatures,
    Map<String, int>? quizBests,
    bool? tonightAlert,
    int? tonightMinutes,
    List<String>? favorites,
    int? textScalePercent,
  }) {
    return HelioraSettings(
      themeMode: themeMode ?? this.themeMode,
      localeCode: localeCode ?? this.localeCode,
      viewMode: viewMode ?? this.viewMode,
      autoUpdateCheck: autoUpdateCheck ?? this.autoUpdateCheck,
      lastUpdateCheckMs: lastUpdateCheckMs ?? this.lastUpdateCheckMs,
      bestQuizScore: bestQuizScore ?? this.bestQuizScore,
      birthDateMs: birthDateMs ?? this.birthDateMs,
      cityId: cityId ?? this.cityId,
      reminders: reminders ?? this.reminders,
      onlineFeatures: onlineFeatures ?? this.onlineFeatures,
      quizBests: quizBests ?? this.quizBests,
      tonightAlert: tonightAlert ?? this.tonightAlert,
      tonightMinutes: tonightMinutes ?? this.tonightMinutes,
      favorites: favorites ?? this.favorites,
      textScalePercent: textScalePercent ?? this.textScalePercent,
    );
  }

  Map<String, Object> toJson() {
    return <String, Object>{
      'version': 1,
      'theme': themeMode.name,
      'locale': localeCode,
      'view': viewMode.name,
      'autoUpdateCheck': autoUpdateCheck,
      'lastUpdateCheckMs': lastUpdateCheckMs,
      'bestQuizScore': bestQuizScore,
      'birthDateMs': birthDateMs,
      'cityId': cityId,
      'reminders': reminders,
      'onlineFeatures': onlineFeatures,
      'quizBests': quizBests,
      'tonightAlert': tonightAlert,
      'tonightMinutes': tonightMinutes,
      'favorites': favorites,
      'textScale': textScalePercent,
    };
  }

  /// Reads stored JSON. Unknown or broken values fall back to defaults, so a
  /// newer or older file never wipes the rest of the settings.
  factory HelioraSettings.fromJson(Map<String, dynamic> json) {
    const d = HelioraSettings();
    ThemeMode theme = d.themeMode;
    for (final mode in ThemeMode.values) {
      if (mode.name == json['theme']) {
        theme = mode;
      }
    }
    ViewMode view = d.viewMode;
    for (final mode in ViewMode.values) {
      if (mode.name == json['view']) {
        view = mode;
      }
    }
    final locale = json['locale'];
    final auto = json['autoUpdateCheck'];
    final last = json['lastUpdateCheckMs'];
    final best = json['bestQuizScore'];
    final birth = json['birthDateMs'];
    final city = json['cityId'];
    final reminders = json['reminders'];
    final online = json['onlineFeatures'];
    final bests = json['quizBests'];
    final alert = json['tonightAlert'];
    final minutes = json['tonightMinutes'];
    final favs = json['favorites'];
    final scale = json['textScale'];
    return HelioraSettings(
      themeMode: theme,
      // A language that was removed in an update falls back to the phone's.
      localeCode: locale is String
          ? (supportedLocaleCodes.contains(locale) ? locale : '')
          : d.localeCode,
      viewMode: view,
      autoUpdateCheck: auto is bool ? auto : d.autoUpdateCheck,
      lastUpdateCheckMs: last is int ? last : d.lastUpdateCheckMs,
      bestQuizScore: best is int ? best : d.bestQuizScore,
      birthDateMs: birth is int ? birth : d.birthDateMs,
      cityId: city is String ? city : d.cityId,
      reminders: reminders is List
          ? <String>[for (final r in reminders) if (r is String) r]
          : d.reminders,
      onlineFeatures: online is bool ? online : d.onlineFeatures,
      quizBests: bests is Map
          ? <String, int>{
              for (final e in bests.entries)
                if (e.key is String && e.value is int) e.key as String: e.value as int,
            }
          : d.quizBests,
      tonightAlert: alert is bool ? alert : d.tonightAlert,
      tonightMinutes: minutes is int && minutes >= 0 && minutes < 1440
          ? minutes
          : d.tonightMinutes,
      favorites: favs is List
          ? <String>[for (final f in favs) if (f is String) f]
          : d.favorites,
      textScalePercent:
          scale is int && textScaleChoices.contains(scale) ? scale : d.textScalePercent,
    );
  }
}

/// Loads and saves [HelioraSettings] as `settings.json`.
class SettingsStore {
  SettingsStore({NativeBridge bridge = const NativeBridge()})
      : _bridge = bridge;

  final NativeBridge _bridge;
  String? _dir;

  Future<File?> _file(String name) async {
    _dir ??= await _bridge.filesDir();
    final dir = _dir;
    if (dir == null || dir.isEmpty) {
      return null;
    }
    return File('$dir${Platform.pathSeparator}$name');
  }

  Future<HelioraSettings> load() async {
    try {
      final file = await _file('settings.json');
      if (file == null || !await file.exists()) {
        return const HelioraSettings();
      }
      final json = jsonDecode(await file.readAsString());
      if (json is Map<String, dynamic>) {
        return HelioraSettings.fromJson(json);
      }
    } on Exception {
      // A broken file is ignored; defaults are used instead.
    }
    return const HelioraSettings();
  }

  /// Writes to a temporary file first and then renames it, so a crash while
  /// saving never leaves a half-written settings file.
  Future<void> save(HelioraSettings settings) async {
    try {
      final file = await _file('settings.json');
      if (file == null) {
        return;
      }
      final temp = File('${file.path}.tmp');
      await temp.writeAsString(jsonEncode(settings.toJson()), flush: true);
      await temp.rename(file.path);
    } on Exception {
      // Saving is best effort; the app keeps working with what it has.
    }
  }
}
