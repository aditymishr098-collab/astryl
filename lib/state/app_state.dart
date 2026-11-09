import 'dart:io';

import 'package:flutter/material.dart';

import '../core/version.dart';
import '../data/account_store.dart' show AccountStore;
import '../data/backup.dart';
import '../data/cities.dart';
import '../data/build_flavor.dart';
import '../data/favorites.dart';
import '../data/native_bridge.dart';
import '../data/online_service.dart';
import 'account_state.dart';
import 'online_state.dart';
import '../data/settings.dart';
import '../data/tonight_alerts.dart';
import '../data/update_service.dart';

/// Holds the settings and update state for the whole app.
class AppState extends ChangeNotifier {
  AppState({
    SettingsStore? store,
    UpdateService? updates,
    NativeBridge bridge = const NativeBridge(),
  })  : _store = store ?? SettingsStore(),
        _updates = updates ?? UpdateService(),
        _bridge = bridge;

  final SettingsStore _store;
  final UpdateService _updates;
  final NativeBridge _bridge;

  /// The optional online account (see account_state.dart).
  late final AccountState account = AccountState(
    store: AccountStore(bridge: _bridge),
    bridge: _bridge,
  );

  HelioraSettings _settings = const HelioraSettings();
  HelioraSettings get settings => _settings;

  String _appVersion = '';

  /// Installed version name, for example "1.0.0".
  String get appVersion => _appVersion;

  NativeBridge get bridge => _bridge;

  /// Orbit data and launches for the optional online features.
  final OnlineState online = OnlineState();

  Future<void> load() async {
    _settings = await _store.load();
    _appVersion = await _bridge.appVersion();
    online.useStore(OnlineStore(folder: _bridge.filesDir));
    await online.loadCache();
    _applyMyLocation();
    account.bind(read: () => _settings, apply: _update);
    await account.load();
    notifyListeners();
  }

  /// Lets cityById() answer for the "my location" city.
  void _applyMyLocation() {
    if (_settings.cityId == gpsCityId) {
      setMyLocation(_settings.myLat, _settings.myLon);
    } else {
      setMyLocation(null, null);
    }
  }

  Future<void> _update(HelioraSettings next) async {
    _settings = next;
    _applyMyLocation();
    notifyListeners();
    await _store.save(next);
    account.scheduleSync();
  }

  Future<void> setThemeMode(ThemeMode mode) =>
      _update(_settings.copyWith(themeMode: mode));

  Future<void> setLocaleCode(String code) =>
      _update(_settings.copyWith(localeCode: code));

  Future<void> setViewMode(ViewMode mode) =>
      _update(_settings.copyWith(viewMode: mode));

  Future<void> setCity(String id) =>
      _update(_settings.copyWith(cityId: id));

  /// Makes the place the phone found the city for the sky.
  Future<void> setMyLocationCity(double lat, double lon) => _update(
      _settings.copyWith(cityId: gpsCityId, myLat: lat, myLon: lon));

  Future<void> setBirthDate(DateTime date) => _update(
      _settings.copyWith(birthDateMs: date.millisecondsSinceEpoch));

  /// Whether a reminder is set for the space event [id].
  bool hasReminder(String id) => _settings.reminders.contains(id);

  /// Remembers that a reminder is set (or not) for the space event [id].
  Future<void> setReminder(String id, bool on) {
    final list = <String>[
      for (final r in _settings.reminders)
        if (r != id) r,
      if (on) id,
    ];
    return _update(_settings.copyWith(reminders: list));
  }

  /// Allows or stops the optional online features.
  Future<void> setOnlineFeatures(bool value) =>
      _update(_settings.copyWith(onlineFeatures: value));

  /// Turns the daily "tonight in the sky" note on or off. Turning it off
  /// removes the notes that were already set.
  Future<void> setTonightAlert(bool value) async {
    await _update(_settings.copyWith(tonightAlert: value));
    if (!value) {
      for (var i = 0; i < tonightAlertDays; i++) {
        await _bridge.cancelReminder('tonight:$i');
      }
    }
  }

  /// Sets when the daily note is shown, in minutes after midnight.
  Future<void> setTonightMinutes(int minutes) =>
      _update(_settings.copyWith(tonightMinutes: minutes));

  /// Whether [key] (see favorites.dart) is starred.
  bool isFavorite(String key) => _settings.favorites.contains(key);

  /// Stars or un-stars [key].
  Future<void> toggleFavorite(String key) => _update(_settings.copyWith(
      favorites: toggledFavorite(_settings.favorites, key)));

  /// Writes a backup file to the share folder and returns its path, or null
  /// when it could not be written.
  Future<String?> writeBackup() async {
    try {
      final dir = await _bridge.sharedDir();
      if (dir.isEmpty) {
        return null;
      }
      final file = File('$dir${Platform.pathSeparator}Astryl-backup.json');
      await file.writeAsString(
          buildBackup(_settings, DateTime.now(), _appVersion),
          flush: true);
      return file.path;
    } on Exception {
      return null;
    }
  }

  /// Puts the settings in the backup [text] in place of the current ones.
  /// False, with nothing changed, when [text] is not an Astryl backup.
  Future<bool> restoreBackup(String text) async {
    final HelioraSettings backup;
    try {
      backup = parseBackup(text);
    } on FormatException {
      return false;
    }
    // The old bells would still ring although they are no longer listed.
    for (final id in _settings.reminders) {
      await _bridge.cancelReminder(id);
    }
    await _update(restoredSettings(_settings, backup));
    return true;
  }

  /// Sets the text size in percent (one of [textScaleChoices]).
  Future<void> setTextScale(int percent) =>
      _update(_settings.copyWith(textScalePercent: percent));

  /// Forgets reminders that are over. Only reminders for which [inScope] is
  /// true are looked at; those not in [valid] are dropped.
  Future<void> pruneReminders(
      bool Function(String id) inScope, Set<String> valid) {
    final list = <String>[
      for (final r in _settings.reminders)
        if (!inScope(r) || valid.contains(r)) r,
    ];
    if (list.length == _settings.reminders.length) {
      return Future<void>.value();
    }
    return _update(_settings.copyWith(reminders: list));
  }

  /// Keeps the best quiz score of a level ('easy', 'medium' or 'hard').
  /// Returns true when [score] is a new best.
  Future<bool> recordQuizScore(String level, int score) async {
    if (score <= _settings.bestFor(level)) {
      return false;
    }
    final bests = Map<String, int>.of(_settings.quizBests)..[level] = score;
    await _update(_settings.copyWith(quizBests: bests));
    return true;
  }

  /// Asks GitHub for the newest release each time the app opens. Returns it
  /// when it is newer than this app, otherwise (or when offline, or slow)
  /// null. Never throws: the app must always be able to open.
  Future<UpdateInfo?> checkOnOpen() async {
    if (!inAppUpdates || _appVersion.isEmpty) {
      return null;
    }
    try {
      final info =
          await _updates.latest().timeout(const Duration(seconds: 5));
      return isNewerVersion(info.tag, _appVersion) ? info : null;
    } on Exception {
      return null;
    }
  }
}

/// Makes [AppState] available to every screen.
class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
      : super(notifier: state);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'No AppScope above this context');
    return scope!.notifier!;
  }

  /// Reads the state without rebuilding when it changes.
  static AppState read(BuildContext context) {
    final element = context.getElementForInheritedWidgetOfExactType<AppScope>();
    return (element!.widget as AppScope).notifier!;
  }
}
