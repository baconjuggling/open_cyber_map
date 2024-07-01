import 'dart:math' as math;

class BoundingBox {
  const BoundingBox({
    required this.minLat,
    required this.minLon,
    required this.maxLat,
    required this.maxLon,
  });
  final double minLat;
  final double minLon;
  final double maxLat;
  final double maxLon;

  double get north => math.max(maxLat, minLat);
  double get south => math.min(maxLat, minLat);
  double get east => math.max(maxLon, minLon);
  double get west => math.min(maxLon, minLon);

  String toOSMString() => '$south,$west,$north,$east';
}
