import 'cities.dart';
import 'settings.dart';

/// Rules for the online account, kept free of any network code so they can
/// be tested on their own.

/// Firebase project and Web API key (public, safe in client code; access is
/// controlled by Firebase Authentication and Firestore Security Rules).
const String firebaseProjectId = 'astryl-space';
const String accountApiUrl =
    'https://firestore.googleapis.com/v1/projects/$firebaseProjectId/databases/(default)/documents';
const String firebaseAuthUrl = 'https://identitytoolkit.googleapis.com/v1';
const String firebaseTokenUrl = 'https://securetoken.googleapis.com/v1';
const String accountApiKey = 'AIzaSyA-ZcWiNNMmVlDzTqPafBQmz9HIzLGag7g';
const String privacyUrl = 'https://astryl.space/privacy.html';

/// The version of the privacy policy the user ticked.
const int consentVersion = 1;

final RegExp _usernameRe = RegExp(r'^[a-z0-9_]{3,20}$');

/// Lower-case, trimmed username.
String normalizeUsername(String raw) => raw.trim().toLowerCase();

/// 3 to 20 letters (a-z), digits or underscores.
bool isValidUsername(String raw) => _usernameRe.hasMatch(normalizeUsername(raw));

/// At least 8 characters, at most 72 (the limit of the password hashing).
bool isValidPassword(String raw) => raw.length >= 8 && raw.length <= 72;

/// A recovery code is 16 characters, shown as XXXX-XXXX-XXXX-XXXX. People
/// type it in any case and with or without dashes.
String normalizeCode(String raw) {
  const alphabet = 'ABCDEFGHJKMNPQRSTUVWXYZ23456789';
  final buffer = StringBuffer();
  for (final unit in raw.toUpperCase().split('')) {
    if (alphabet.contains(unit)) {
      buffer.write(unit);
    }
  }
  return buffer.toString();
}

bool isValidCode(String raw) => normalizeCode(raw).length == 16;

/// "ABCD-EFGH-IJKL-MNOP" from any spelling of a code.
String formatCode(String raw) {
  final c = normalizeCode(raw);
  if (c.length != 16) {
    return raw;
  }
  return '${c.substring(0, 4)}-${c.substring(4, 8)}-'
      '${c.substring(8, 12)}-${c.substring(12, 16)}';
}

/// The part of the settings that is kept in the account. Left out on
/// purpose: reminders and the update check (they belong to one phone), the
/// online-features switch, and a location found by GPS (it is only shared
/// when the user switches that on separately).
Map<String, Object> buildSyncPayload(HelioraSettings s) {
  return <String, Object>{
    'v': 1,
    'theme': s.themeMode.name,
    'locale': s.localeCode,
    'view': s.viewMode.name,
    'city': s.cityId == gpsCityId ? '' : s.cityId,
    'birthDateMs': s.birthDateMs,
    'tonightAlert': s.tonightAlert,
    'tonightMinutes': s.tonightMinutes,
    'textScale': s.textScalePercent,
    'favorites': List<String>.of(s.favorites),
    'quizBests': Map<String, int>.of(s.quizBests),
  };
}

/// Joins the account data [remote] with the phone's [local] settings.
///
/// Favourites are joined and the best quiz scores are kept, so nothing is
/// lost either way. Single values come from [remote] when [remoteWins] is
/// true (the account has newer data), otherwise the phone's stay. Values
/// missing from [remote] never erase what the phone has.
HelioraSettings mergeSync(
  HelioraSettings local,
  Map<String, dynamic> remote, {
  required bool remoteWins,
}) {
  final remoteFav = remote['favorites'];
  final favorites = <String>[
    if (remoteFav is List)
      for (final f in remoteFav)
        if (f is String) f,
  ];
  for (final f in local.favorites) {
    if (!favorites.contains(f)) {
      favorites.add(f);
    }
  }

  final bests = Map<String, int>.of(local.quizBests);
  final remoteBests = remote['quizBests'];
  if (remoteBests is Map) {
    for (final e in remoteBests.entries) {
      final key = e.key;
      final value = e.value;
      if (key is String && value is int && value > (bests[key] ?? 0)) {
        bests[key] = value;
      }
    }
  }

  var merged = local.copyWith(favorites: favorites, quizBests: bests);
  if (!remoteWins) {
    return merged;
  }
  final base = HelioraSettings.fromJson(<String, dynamic>{
    'theme': remote['theme'],
    'locale': remote['locale'],
    'view': remote['view'],
    'tonightAlert': remote['tonightAlert'],
    'tonightMinutes': remote['tonightMinutes'],
    'textScale': remote['textScale'],
  });
  final city = remote['city'];
  final birth = remote['birthDateMs'];
  final hasTheme = remote['theme'] is String;
  final hasLocale = remote['locale'] is String;
  final hasView = remote['view'] is String;
  merged = merged.copyWith(
    themeMode: hasTheme ? base.themeMode : null,
    localeCode: hasLocale ? base.localeCode : null,
    viewMode: hasView ? base.viewMode : null,
    cityId: city is String && city.isNotEmpty && cityById(city) != null
        ? city
        : null,
    birthDateMs: birth is int && birth > 0 ? birth : null,
    tonightAlert: remote['tonightAlert'] is bool ? base.tonightAlert : null,
    tonightMinutes: remote['tonightMinutes'] is int ? base.tonightMinutes : null,
    textScalePercent: remote['textScale'] is int ? base.textScalePercent : null,
  );
  return merged;
}

/// A text for [value] that does not depend on the order of map keys, so two
/// copies of the same data compare equal.
String canonicalJson(Object? value) {
  if (value is Map) {
    final keys = value.keys.map((k) => k.toString()).toList()..sort();
    return '{${keys.map((k) => '${_quote(k)}:${canonicalJson(value[k])}').join(',')}}';
  }
  if (value is List) {
    return '[${value.map(canonicalJson).join(',')}]';
  }
  if (value is String) {
    return _quote(value);
  }
  return '$value';
}

String _quote(String s) {
  final escaped = s
      .replaceAll(r'\', r'\\')
      .replaceAll('"', r'\"')
      .replaceAll('\n', r'\n');
  return '"$escaped"';
}
