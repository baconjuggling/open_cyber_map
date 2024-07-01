import 'package:cyber_map/core/data/data_transfer_objects/relation_member_dto.dart';
import 'package:cyber_map/core/domain/models/relation/relation.dart';
import 'package:cyber_map/core/utils/tag_utils.dart';

// ignore: avoid_classes_with_only_static_members
class RelationDTO {
  static Relation toEntity({required Map<String, dynamic> map}) {
    return Relation(
      id: map['id'] as int,
      tags: TagUtils.expandTags(
        (map['tags'] ?? <String, dynamic>{}) as Map<String, dynamic>,
      ),
      members: (map['members'] as List<dynamic>)
          .map(
            (e) => RelationMemberDTO.toEntity(map: e as Map<String, dynamic>),
          )
          .toSet(),
    );
  }

  static Map<String, dynamic> toDto({required Relation relation}) {
    return {
      'id': relation.id,
      'tags': TagUtils.flattenTags(relation.tags),
      'members': relation.members
          .map((member) => RelationMemberDTO.toDto(relationMember: member))
          .toSet(),
    };
  }
}
