import 'package:cyber_map/core/domain/models/osm_object/osm_object.dart';
import 'package:flutter_map/flutter_map.dart';

class OSMObjectMarker extends Marker {
  const OSMObjectMarker({
    required this.object,
    required super.child,
    required super.point,
    super.width,
    super.height,
    bool super.rotate = true,
  });
  final OSMObject object;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OSMObjectMarker &&
        other.object == object &&
        other.point == point &&
        other.width == width &&
        other.height == height &&
        other.rotate == rotate;
  }

  @override
  int get hashCode {
    return object.hashCode ^
        point.hashCode ^
        width.hashCode ^
        height.hashCode ^
        rotate.hashCode;
  }
}
