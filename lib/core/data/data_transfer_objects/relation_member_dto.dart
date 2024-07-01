import 'package:cyber_map/core/domain/models/relation_member/relation_member.dart';

// ignore: avoid_classes_with_only_static_members
class RelationMemberDTO {
  static RelationMember toEntity({required Map<String, dynamic> map}) {
    return RelationMember(
      type: map['type'] as String,
      ref: map['ref'] as int,
      role: map['role'] as String,
    );
  }

  static Map<String, dynamic> toDto({required RelationMember relationMember}) {
    return {
      'type': relationMember.type,
      'ref': relationMember.ref,
      'role': relationMember.role,
    };
  }
}
