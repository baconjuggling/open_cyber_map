import 'package:cyber_map/core/domain/models/osm_object/osm_object.dart';
import 'package:cyber_map/core/domain/models/relation_member/relation_member.dart';

class Relation extends OSMObject {
  const Relation({
    required super.id,
    required super.tags,
    required this.members,
  });
  final Set<RelationMember> members;

  @override
  int get hashCode {
    return id.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Relation && id == other.id;
  }
}
