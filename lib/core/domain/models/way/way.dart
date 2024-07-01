import 'package:cyber_map/core/domain/models/osm_object/osm_object.dart';

class Way extends OSMObject {
  const Way({
    required super.id,
    required super.tags,
    required this.nodes,
  });
  final List<int> nodes;

  bool get isArea =>
      nodes.first == (nodes.last) && !tags.containsKey('highway');

  @override
  int get hashCode {
    return id.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Way && id == other.id;
  }
}
