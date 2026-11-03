import 'package:flutter/foundation.dart';

import '../core/sgp4.dart';
import '../data/online_service.dart';

/// The data for the optional online features: the orbits of the space
/// station, Tiangong and Hubble, the list of rocket launches and the space
/// news. It is kept on the phone, so all of it keeps working offline with
/// what was downloaded last.
class OnlineState extends ChangeNotifier {
  OnlineState({OnlineService? service, OnlineStore? store})
      : _service = service ?? OnlineService(),
        _store = store ?? OnlineStore();

  final OnlineService _service;
  OnlineStore _store;

  /// Where the saved files live. Set once the app knows its folder.
  void useStore(OnlineStore store) => _store = store;

  IssTle? _tle;
  Sgp4? _sat;
  List<Launch> _launches = const <Launch>[];
  int _launchesFetchedMs = 0;

  bool _loadingIss = false;
  bool _issFailed = false;
  bool _loadingLaunches = false;
  bool _launchesFailed = false;

  // Tiangong and Hubble, by satellite id.
  final Map<String, IssTle> _satTles = <String, IssTle>{};
  final Map<String, Sgp4> _sats = <String, Sgp4>{};
  final Set<String> _loadingSats = <String>{};
  final Set<String> _failedSats = <String>{};

  List<NewsItem> _news = const <NewsItem>[];
  int _newsFetchedMs = 0;
  bool _loadingNews = false;
  bool _newsFailed = false;

  IssTle? get tle => _tle;

  /// The orbit of the station, or null until it was downloaded once.
  Sgp4? get sat => _sat;
  List<Launch> get launches => _launches;
  bool get loadingIss => _loadingIss;
  bool get issFailed => _issFailed;
  bool get loadingLaunches => _loadingLaunches;
  bool get launchesFailed => _launchesFailed;

  /// The orbit of Tiangong or Hubble, or null until downloaded once.
  Sgp4? satFor(String id) => _sats[id];
  IssTle? tleFor(String id) => _satTles[id];
  bool loadingSat(String id) => _loadingSats.contains(id);
  bool satFailed(String id) => _failedSats.contains(id);

  List<NewsItem> get news => _news;
  int get newsFetchedMs => _newsFetchedMs;
  bool get loadingNews => _loadingNews;
  bool get newsFailed => _newsFailed;

  static const Duration _issMaxAge = Duration(hours: 12);
  static const Duration _launchMaxAge = Duration(hours: 3);
  static const Duration _newsMaxAge = Duration(hours: 3);

  /// Reads what was saved by an earlier download.
  Future<void> loadCache() async {
    final tle = IssTle.fromJson(await _store.read('iss_tle.json'));
    if (tle != null) {
      final sat = tle.toSgp4();
      if (sat != null) {
        _tle = tle;
        _sat = sat;
      }
    }
    final saved = await _store.read('launches.json');
    if (saved is Map<String, dynamic>) {
      final list = saved['items'];
      final at = saved['fetchedAtMs'];
      if (list is List) {
        _launches = <Launch>[
          for (final item in list)
            if (Launch.fromJson(item) != null) Launch.fromJson(item)!,
        ];
      }
      if (at is int) {
        _launchesFetchedMs = at;
      }
    }
    for (final sat in trackedSatellites) {
      final tle = IssTle.fromJson(await _store.read('sat_${sat.id}.json'));
      final orbit = tle?.toSgp4();
      if (tle != null && orbit != null) {
        _satTles[sat.id] = tle;
        _sats[sat.id] = orbit;
      }
    }
    final savedNews = await _store.read('news.json');
    if (savedNews is Map<String, dynamic>) {
      final list = savedNews['items'];
      final at = savedNews['fetchedAtMs'];
      if (list is List) {
        _news = <NewsItem>[
          for (final item in list)
            if (NewsItem.fromJson(item) != null) NewsItem.fromJson(item)!,
        ];
      }
      if (at is int) {
        _newsFetchedMs = at;
      }
    }
    notifyListeners();
  }

  /// Downloads fresh orbit data when there is none or it is over 12 hours
  /// old (or when [force] is set). Does nothing while a download runs.
  Future<void> refreshIss({bool force = false}) async {
    if (_loadingIss) {
      return;
    }
    final tle = _tle;
    if (!force && tle != null) {
      final age = DateTime.now().millisecondsSinceEpoch - tle.fetchedAtMs;
      if (age < _issMaxAge.inMilliseconds) {
        return;
      }
    }
    _loadingIss = true;
    _issFailed = false;
    notifyListeners();
    try {
      final fresh = await _service.fetchIssTle();
      final sat = fresh.toSgp4();
      if (sat != null) {
        _tle = fresh;
        _sat = sat;
        await _store.write('iss_tle.json', fresh.toJson());
      }
    } on Exception {
      _issFailed = true;
    } finally {
      _loadingIss = false;
      notifyListeners();
    }
  }

  /// Downloads the launch list when it is over 3 hours old (or [force]).
  Future<void> refreshLaunches({bool force = false}) async {
    if (_loadingLaunches) {
      return;
    }
    final age = DateTime.now().millisecondsSinceEpoch - _launchesFetchedMs;
    if (!force && _launches.isNotEmpty && age < _launchMaxAge.inMilliseconds) {
      return;
    }
    _loadingLaunches = true;
    _launchesFailed = false;
    notifyListeners();
    try {
      final list = await _service.fetchLaunches();
      _launches = list;
      _launchesFetchedMs = DateTime.now().millisecondsSinceEpoch;
      await _store.write('launches.json', <String, Object>{
        'fetchedAtMs': _launchesFetchedMs,
        'items': <Object>[for (final l in list) l.toJson()],
      });
    } on Exception {
      _launchesFailed = true;
    } finally {
      _loadingLaunches = false;
      notifyListeners();
    }
  }

  /// Downloads the orbit of Tiangong or Hubble ([id] from
  /// `trackedSatellites`) when there is none or it is over 12 hours old.
  Future<void> refreshSatellite(String id, {bool force = false}) async {
    final sat = trackedSatelliteById(id);
    if (sat == null || _loadingSats.contains(id)) {
      return;
    }
    final tle = _satTles[id];
    if (!force && tle != null) {
      final age = DateTime.now().millisecondsSinceEpoch - tle.fetchedAtMs;
      if (age < _issMaxAge.inMilliseconds) {
        return;
      }
    }
    _loadingSats.add(id);
    _failedSats.remove(id);
    notifyListeners();
    try {
      final fresh = await _service.fetchSatelliteTle(sat);
      final orbit = fresh.toSgp4();
      if (orbit != null) {
        _satTles[id] = fresh;
        _sats[id] = orbit;
        await _store.write('sat_$id.json', fresh.toJson());
      }
    } on Exception {
      _failedSats.add(id);
    } finally {
      _loadingSats.remove(id);
      notifyListeners();
    }
  }

  /// Downloads the news when it is over 3 hours old (or [force]).
  Future<void> refreshNews({bool force = false}) async {
    if (_loadingNews) {
      return;
    }
    final age = DateTime.now().millisecondsSinceEpoch - _newsFetchedMs;
    if (!force && _news.isNotEmpty && age < _newsMaxAge.inMilliseconds) {
      return;
    }
    _loadingNews = true;
    _newsFailed = false;
    notifyListeners();
    try {
      final list = await _service.fetchNews();
      _news = list;
      _newsFetchedMs = DateTime.now().millisecondsSinceEpoch;
      await _store.write('news.json', <String, Object>{
        'fetchedAtMs': _newsFetchedMs,
        'items': <Object>[for (final n in list) n.toJson()],
      });
    } on Exception {
      _newsFailed = true;
    } finally {
      _loadingNews = false;
      notifyListeners();
    }
  }
}
