import 'package:cyber_map/core/domain/models/way/way.dart';
import 'package:cyber_map/core/utils/tag_utils.dart';

//ignore: avoid_classes_with_only_static_members
class WayDTO {
  static Way toEntity({required Map<String, dynamic> map}) {
    return Way(
      id: map['id'] as int,
      nodes: (map['nodes'] as List<dynamic>).map((e) => e as int).toList(),
      tags: TagUtils.expandTags(
        (map['tags'] ?? <String, dynamic>{}) as Map<String, dynamic>,
      ),
    );
  }

  static Map<String, dynamic> toDto({required Way way}) {
    return {
      'id': way.id,
      'nodes': way.nodes,
      'tags': TagUtils.flattenTags(way.tags),
    };
  }
}
