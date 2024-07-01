import 'package:cyber_map/core/domain/models/osm_object/osm_object.dart';

class Node extends OSMObject {
  const Node({
    required super.id,
    required super.tags,
    required this.latitude,
    required this.longitude,
  });
  final double latitude;
  final double longitude;

  @override
  int get hashCode {
    return id.hashCode ^ latitude.hashCode ^ longitude.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Node && id == other.id;
  }
}
