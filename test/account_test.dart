import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heliora/data/account_store.dart';
import 'package:heliora/data/cities.dart';
import 'package:heliora/data/settings.dart';
import 'package:heliora/data/sync.dart';

void main() {
  group('usernames, passwords and codes', () {
    test('username rules', () {
      expect(isValidUsername('adity_m'), isTrue);
      expect(isValidUsername('  Adity_M  '), isTrue);
      expect(isValidUsername('ab'), isFalse);
      expect(isValidUsername('a' * 21), isFalse);
      expect(isValidUsername('has space'), isFalse);
      expect(isValidUsername('dash-name'), isFalse);
      expect(normalizeUsername('  Adity_M '), 'adity_m');
    });

    test('password rules', () {
      expect(isValidPassword('1234567'), isFalse);
      expect(isValidPassword('12345678'), isTrue);
      expect(isValidPassword('x' * 72), isTrue);
      expect(isValidPassword('x' * 73), isFalse);
    });

    test('recovery code spelling', () {
      expect(normalizeCode('abcd-efgh-jkmn-pqrs'), 'ABCDEFGHJKMNPQRS');
      expect(normalizeCode('ABCD EFGH JKMN PQRS'), 'ABCDEFGHJKMNPQRS');
      expect(isValidCode('abcd-efgh-jkmn-pqrs'), isTrue);
      expect(isValidCode('abcd-efgh-jkmn'), isFalse);
      // 0, 1, I, L and O are never in a code.
      expect(normalizeCode('0O1IL'), '');
      expect(formatCode('abcdefghjkmnpqrs'), 'ABCD-EFGH-JKMN-PQRS');
      expect(formatCode('short'), 'short');
    });
  });

  group('canonicalJson', () {
    test('does not depend on key order', () {
      final a = <String, Object>{
        'b': 1,
        'a': <String, Object>{'y': 2, 'x': <int>[1, 2]},
      };
      final b = <String, Object>{
        'a': <String, Object>{'x': <int>[1, 2], 'y': 2},
        'b': 1,
      };
      expect(canonicalJson(a), canonicalJson(b));
      expect(canonicalJson(a), isNot(canonicalJson(<String, Object>{'a': 1})));
    });

    test('keeps list order and escapes quotes', () {
      expect(canonicalJson(<int>[2, 1]), '[2,1]');
      expect(canonicalJson(<String, Object>{'k': 'say "hi"'}),
          r'{"k":"say \"hi\""}');
    });
  });

  group('sync payload and merge', () {
    const local = HelioraSettings(
      themeMode: ThemeMode.light,
      localeCode: 'en',
      cityId: 'yerevan',
      favorites: <String>['a', 'b'],
      quizBests: <String, int>{'easy': 7, 'hard': 2},
      reminders: <String>['event:1'],
      onlineFeatures: true,
      textScalePercent: 115,
    );

    test('payload leaves out what belongs to one phone', () {
      final payload = buildSyncPayload(local);
      expect(payload.containsKey('reminders'), isFalse);
      expect(payload.containsKey('onlineFeatures'), isFalse);
      expect(payload.containsKey('lastUpdateCheckMs'), isFalse);
      expect(payload['theme'], 'light');
      expect(payload['city'], 'yerevan');
      expect(jsonDecode(jsonEncode(payload)), isA<Map<String, dynamic>>());
    });

    test('a GPS city is never put in the account data', () {
      final gps = local.copyWith(cityId: gpsCityId, myLat: 40.1, myLon: 44.5);
      final payload = buildSyncPayload(gps);
      expect(payload['city'], '');
      expect(jsonEncode(payload).contains('40.1'), isFalse);
    });

    test('favourites are joined and quiz bests kept', () {
      final merged = mergeSync(
        local,
        <String, dynamic>{
          'favorites': <String>['b', 'c'],
          'quizBests': <String, dynamic>{'easy': 5, 'medium': 9, 'hard': 4},
        },
        remoteWins: false,
      );
      expect(merged.favorites, <String>['b', 'c', 'a']);
      expect(merged.quizBests, <String, int>{'easy': 7, 'medium': 9, 'hard': 4});
      expect(merged.themeMode, ThemeMode.light);
    });

    test('single values come from the account only when it wins', () {
      final remote = <String, dynamic>{
        'theme': 'dark',
        'locale': 'hi',
        'view': 'globe',
        'city': 'delhi',
        'birthDateMs': 1000,
        'tonightAlert': true,
        'tonightMinutes': 1260,
        'textScale': 130,
      };
      final kept = mergeSync(local, remote, remoteWins: false);
      expect(kept.themeMode, ThemeMode.light);
      expect(kept.cityId, 'yerevan');
      final won = mergeSync(local, remote, remoteWins: true);
      expect(won.themeMode, ThemeMode.dark);
      expect(won.localeCode, 'hi');
      expect(won.viewMode, ViewMode.globe);
      expect(won.cityId, 'delhi');
      expect(won.birthDateMs, 1000);
      expect(won.tonightAlert, isTrue);
      expect(won.tonightMinutes, 1260);
      expect(won.textScalePercent, 130);
      // Not synced, so untouched.
      expect(won.reminders, <String>['event:1']);
      expect(won.onlineFeatures, isTrue);
    });

    test('missing or empty account values never erase the phone', () {
      final merged = mergeSync(
        local.copyWith(birthDateMs: 555),
        <String, dynamic>{'city': '', 'birthDateMs': 0},
        remoteWins: true,
      );
      expect(merged.cityId, 'yerevan');
      expect(merged.birthDateMs, 555);
      expect(merged.themeMode, ThemeMode.light);
      expect(merged.localeCode, 'en');
    });

    test('an unknown city from the account is ignored', () {
      final merged = mergeSync(
          local, <String, dynamic>{'city': 'atlantis'},
          remoteWins: true);
      expect(merged.cityId, 'yerevan');
    });

    test('merging what was just built changes nothing', () {
      final merged = mergeSync(
          local, Map<String, dynamic>.of(buildSyncPayload(local)),
          remoteWins: true);
      expect(canonicalJson(buildSyncPayload(merged)),
          canonicalJson(buildSyncPayload(local)));
    });
  });

  group('settings and cities', () {
    test('the phone location survives a save and load', () {
      const s = HelioraSettings(cityId: gpsCityId, myLat: 40.18, myLon: 44.51);
      final back = HelioraSettings.fromJson(
          jsonDecode(jsonEncode(s.toJson())) as Map<String, dynamic>);
      expect(back.cityId, gpsCityId);
      expect(back.myLat, 40.18);
      expect(back.myLon, 44.51);
    });

    test('broken coordinates fall back to zero', () {
      final back = HelioraSettings.fromJson(
          <String, dynamic>{'myLat': 500, 'myLon': 'x'});
      expect(back.myLat, 0);
      expect(back.myLon, 0);
    });

    test('cityById answers for the GPS city only once it is set', () {
      setMyLocation(null, null);
      expect(cityById(gpsCityId), isNull);
      setMyLocation(12.5, 77.5);
      final city = cityById(gpsCityId);
      expect(city, isNotNull);
      expect(city!.lat, 12.5);
      expect(city.lon, 77.5);
      expect(cityById('yerevan'), isNotNull);
      setMyLocation(null, null);
      expect(cityById(gpsCityId), isNull);
    });
  });

  group('account prefs', () {
    test('device ids look like random ids and differ', () {
      final a = newDeviceId(Random(1));
      final b = newDeviceId(Random(2));
      expect(a, matches(RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[0-9a-f]{4}-[0-9a-f]{12}$')));
      expect(a, isNot(b));
    });

    test('prefs survive a save and load, session included', () {
      const prefs = AccountPrefs(
        deviceId: 'abc-12345678',
        promptDone: true,
        syncOn: false,
        countMe: true,
        shareCountry: true,
        shareLocation: true,
        syncedMs: 99,
        lastPingMs: 5,
        lastLocationMs: 6,
        session: AccountSession(
          accessToken: 'a',
          refreshToken: 'r',
          expiresAt: 123,
          userId: 'u',
          username: 'adity',
        ),
      );
      final back = AccountPrefs.fromJson(
          jsonDecode(jsonEncode(prefs.toJson())) as Map<String, dynamic>);
      expect(back.deviceId, 'abc-12345678');
      expect(back.promptDone, isTrue);
      expect(back.syncOn, isFalse);
      expect(back.countMe, isTrue);
      expect(back.shareCountry, isTrue);
      expect(back.shareLocation, isTrue);
      expect(back.syncedMs, 99);
      expect(back.session?.username, 'adity');
      expect(back.session?.refreshToken, 'r');
    });

    test('everything is off by default and a broken file is harmless', () {
      final back = AccountPrefs.fromJson(<String, dynamic>{'session': 'x'});
      expect(back.promptDone, isFalse);
      expect(back.countMe, isFalse);
      expect(back.shareCountry, isFalse);
      expect(back.shareLocation, isFalse);
      expect(back.syncOn, isTrue);
      expect(back.session, isNull);
    });

    test('clearSession removes the login only', () {
      const prefs = AccountPrefs(
        countMe: true,
        session: AccountSession(
            accessToken: 'a',
            refreshToken: 'r',
            expiresAt: 1,
            userId: 'u',
            username: 'n'),
      );
      final out = prefs.copyWith(clearSession: true);
      expect(out.session, isNull);
      expect(out.countMe, isTrue);
    });
  });

  group('the backend files exist', () {
    test('the function, the SQL and the keep-alive are in the repo', () {
      expect(File('supabase/functions/account/index.ts').existsSync(), isTrue);
      expect(File('supabase/migrations/001_init.sql').existsSync(), isTrue);
    });

    test('the SQL locks every table', () {
      final sql = File('supabase/migrations/001_init.sql').readAsStringSync();
      for (final t in <String>['profiles', 'recovery', 'user_data', 'pings', 'rate']) {
        expect(sql.contains('alter table public.$t'), isTrue, reason: t);
        expect(sql.contains('create table if not exists public.$t'), isTrue,
            reason: t);
      }
      expect(sql.contains('create policy'), isFalse);
    });

    test('no secret key is in the app', () {
      final text = File('lib/data/sync.dart').readAsStringSync();
      expect(text.contains('service_role'), isFalse);
      expect(text.contains('sb_secret'), isFalse);
      expect(accountApiKey.startsWith('sb_publishable_'), isTrue);
    });
  });
}
