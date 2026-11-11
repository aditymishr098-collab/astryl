import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

/// About 1.7 lakh cities and towns from GeoNames (CC BY 4.0), one file per
/// first letter in assets/cities/ (made by tools/build_cities.py). A file is
/// read only when someone searches for a name starting with that letter.
class WorldCity {
  const WorldCity(this.name, this.countryCode, this.lat, this.lon);

  final String name;

  /// Two-letter country code, such as IN or AM.
  final String countryCode;
  final double lat;
  final double lon;
}

final Map<String, Future<List<WorldCity>>> _shards = <String, Future<List<WorldCity>>>{};

const String _from = 'àáâãäåāăąçćčďèéêëēėęěìíîïīįłñńňòóôõöøōőřśšşťùúûüūůűýÿžźżđ';
const String _to = 'aaaaaaaaaccccdeeeeeeeeiiiiiilnnnooooooooorsssstuuuuuuuyyzzzd';

/// Lower case without accents, so "sao paulo" finds "São Paulo".
String foldName(String text) {
  final out = StringBuffer();
  for (final r in text.toLowerCase().runes) {
    final ch = String.fromCharCode(r);
    final i = _from.indexOf(ch);
    out.write(i < 0 ? ch : _to[i]);
  }
  return out.toString().trim();
}

String _shardFor(String folded) {
  final f = folded.isEmpty ? '' : folded[0];
  return f.compareTo('a') >= 0 && f.compareTo('z') <= 0 && f.length == 1 ? f : '_';
}

/// Reads one letter file. Broken rows are skipped.
List<WorldCity> parseShard(String text) {
  final rows = jsonDecode(text);
  final out = <WorldCity>[];
  if (rows is! List) {
    return out;
  }
  for (final r in rows) {
    if (r is List && r.length >= 4 && r[0] is String && r[1] is String && r[2] is num && r[3] is num) {
      out.add(WorldCity(r[0] as String, r[1] as String, (r[2] as num).toDouble(), (r[3] as num).toDouble()));
    }
  }
  return out;
}

Future<List<WorldCity>> _load(String key) => _shards.putIfAbsent(
    key,
    () => rootBundle
        .loadString('assets/cities/$key.json')
        .then(parseShard)
        .catchError((Object _) => <WorldCity>[]));

/// Cities whose name starts with [query] (then ones with a word starting
/// with it), shortest names first, at most [limit].
Future<List<WorldCity>> searchWorldCities(String query, {int limit = 30}) async {
  final q = foldName(query);
  if (q.length < 2) {
    return const <WorldCity>[];
  }
  final rows = await _load(_shardFor(q));
  return filterCities(rows, q, limit: limit);
}

List<WorldCity> filterCities(List<WorldCity> rows, String folded, {int limit = 30}) {
  final starts = <WorldCity>[];
  final inside = <WorldCity>[];
  for (final c in rows) {
    final n = foldName(c.name);
    if (n.startsWith(folded)) {
      starts.add(c);
      if (starts.length >= limit) {
        break;
      }
    } else if (inside.length < 10 && n.contains(' $folded')) {
      inside.add(c);
    }
  }
  return <WorldCity>[...starts, ...inside].take(limit).toList();
}
