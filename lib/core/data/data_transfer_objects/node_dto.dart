import 'package:cyber_map/core/domain/models/node/node.dart';
import 'package:cyber_map/core/utils/tag_utils.dart';

// ignore: avoid_classes_with_only_static_members
class NodeDTO {
  static Node toEntity({required Map<String, dynamic> map}) {
    return Node(
      id: map['id'] as int,
      latitude: map['lat'] as double,
      longitude: map['lon'] as double,
      tags: TagUtils.expandTags(
        (map['tags'] ?? <String, dynamic>{}) as Map<String, dynamic>,
      ),
    );
  }

  static Map<String, dynamic> toDto({required Node node}) {
    return {
      'id': node.id,
      'lat': node.latitude,
      'lon': node.longitude,
      'tags': TagUtils.flattenTags(node.tags),
    };
  }
}
