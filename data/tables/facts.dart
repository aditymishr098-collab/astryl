/// The bodies that have "Did you know?" facts, in a fixed order. Every body
/// has [factsPerBody] facts.
const List<String> factBodyIds = <String>[
  'sun',
  'mercury',
  'venus',
  'earth',
  'mars',
  'jupiter',
  'saturn',
  'uranus',
  'neptune',
  'moon',
  'pluto',
  'io',
  'europa',
  'ganymede',
  'callisto',
  'titan',
  'enceladus',
  'triton',
];

const int factsPerBody = 2;

/// One fact: a body and which of its facts (0 or 1).
typedef FactRef = ({String bodyId, int index});

/// The fact for [day]. It changes every day and goes through all the facts
/// before it repeats, and the same day always gives the same fact.
FactRef factOfTheDay(DateTime day) {
  final days = DateTime.utc(day.year, day.month, day.day)
      .difference(DateTime.utc(2020))
      .inDays;
  final total = factBodyIds.length * factsPerBody;
  final n = ((days % total) + total) % total;
  return (
    bodyId: factBodyIds[n % factBodyIds.length],
    index: n ~/ factBodyIds.length,
  );
}

/// How high someone jumps on a world with [relativeGravity] (Earth = 1)
/// when they jump [earthCm] centimetres on Earth with the same push-off.
double jumpHeightCm(double earthCm, double relativeGravity) {
  if (relativeGravity <= 0) {
    return 0;
  }
  return earthCm / relativeGravity;
}
