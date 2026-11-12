/// Famous space missions for the missions timeline. Names and agencies are
/// proper names and stay as they are in every language; the short story of
/// each mission is translated (see `missionText` in names.dart).
class Mission {
  const Mission({
    required this.id,
    required this.name,
    required this.agency,
    required this.year,
    required this.month,
    required this.day,
  });

  /// Short id, also the last part of the l10n key.
  final String id;
  final String name;
  final String agency;

  /// The date of the moment the mission is known for.
  final int year;
  final int month;
  final int day;

  DateTime get date => DateTime(year, month, day);
}

/// Oldest first.
const List<Mission> missions = <Mission>[
  Mission(
      id: 'sputnik1',
      name: 'Sputnik 1',
      agency: 'USSR',
      year: 1957,
      month: 10,
      day: 4),
  Mission(
      id: 'vostok1',
      name: 'Vostok 1',
      agency: 'USSR',
      year: 1961,
      month: 4,
      day: 12),
  Mission(
      id: 'apollo11',
      name: 'Apollo 11',
      agency: 'NASA',
      year: 1969,
      month: 7,
      day: 20),
  Mission(
      id: 'venera7',
      name: 'Venera 7',
      agency: 'USSR',
      year: 1970,
      month: 12,
      day: 15),
  Mission(
      id: 'viking1',
      name: 'Viking 1',
      agency: 'NASA',
      year: 1976,
      month: 7,
      day: 20),
  Mission(
      id: 'voyager1',
      name: 'Voyager 1',
      agency: 'NASA',
      year: 1977,
      month: 9,
      day: 5),
  Mission(
      id: 'hubble',
      name: 'Hubble Space Telescope',
      agency: 'NASA / ESA',
      year: 1990,
      month: 4,
      day: 24),
  Mission(
      id: 'huygens',
      name: 'Cassini–Huygens',
      agency: 'NASA / ESA / ASI',
      year: 2005,
      month: 1,
      day: 14),
  Mission(
      id: 'curiosity',
      name: 'Curiosity',
      agency: 'NASA',
      year: 2012,
      month: 8,
      day: 6),
  Mission(
      id: 'mangalyaan',
      name: 'Mangalyaan',
      agency: 'ISRO',
      year: 2014,
      month: 9,
      day: 24),
  Mission(
      id: 'rosetta',
      name: 'Rosetta and Philae',
      agency: 'ESA',
      year: 2014,
      month: 11,
      day: 12),
  Mission(
      id: 'newhorizons',
      name: 'New Horizons',
      agency: 'NASA',
      year: 2015,
      month: 7,
      day: 14),
  Mission(
      id: 'perseverance',
      name: 'Perseverance and Ingenuity',
      agency: 'NASA',
      year: 2021,
      month: 2,
      day: 18),
  Mission(
      id: 'jwst',
      name: 'James Webb Space Telescope',
      agency: 'NASA / ESA / CSA',
      year: 2021,
      month: 12,
      day: 25),
  Mission(
      id: 'chandrayaan3',
      name: 'Chandrayaan-3',
      agency: 'ISRO',
      year: 2023,
      month: 8,
      day: 23),
];
