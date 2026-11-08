import 'package:flutter/services.dart';

/// Where the back of the phone points.
class PhoneDirection {
  const PhoneDirection(this.azimuth, this.altitude, this.accuracy);

  /// Degrees from true north towards east.
  final double azimuth;

  /// Degrees above the horizon (negative = below).
  final double altitude;

  /// Android sensor accuracy: 0 unreliable, 1 low, 2 medium, 3 high.
  final int accuracy;

  bool get needsCalibration => accuracy < 2;
}

/// Listens to the phone's compass and motion sensors through
/// OrientationStream.kt. [lat] and [lon] turn magnetic north into true north.
Stream<PhoneDirection> phoneDirections(double lat, double lon) {
  const channel = EventChannel('space.astryl.app/orientation');
  return channel
      .receiveBroadcastStream(<String, double>{'lat': lat, 'lon': lon})
      .map((event) {
    final list = event as List<dynamic>;
    return PhoneDirection(
      (list[0] as num).toDouble(),
      (list[1] as num).toDouble(),
      (list[2] as num).toInt(),
    );
  });
}
