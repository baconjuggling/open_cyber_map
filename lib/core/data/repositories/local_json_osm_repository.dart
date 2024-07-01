import 'dart:convert';
import 'dart:io';

import 'package:cyber_map/core/data/data_transfer_objects/node_dto.dart';
import 'package:cyber_map/core/data/data_transfer_objects/relation_dto.dart';
import 'package:cyber_map/core/data/data_transfer_objects/way_dto.dart';
import 'package:cyber_map/core/domain/models/node/node.dart';
import 'package:cyber_map/core/domain/models/osm_object/osm_object.dart';
import 'package:cyber_map/core/domain/models/relation/relation.dart';
import 'package:cyber_map/core/domain/models/way/way.dart';
import 'package:cyber_map/core/domain/repositories/i_local_osm_repository.dart';

class LocalJsonOSMRepository implements ILocalOSMRepository {
  @override
  Future<List<OSMObject>> loadOSMObjects({required String filePath}) async {
    final file = File(filePath);
    final jsonString = await file.readAsString();
    final jsonData = json.decode(jsonString) as Map<String, dynamic>;
    final osmObjects = <OSMObject>[];

    for (final element in jsonData['elements'] as List) {
      switch ((element as Map<String, dynamic>)['type']) {
        case 'node':
          final node = NodeDTO.toEntity(map: element);
          osmObjects.add(node);
        case 'way':
          final way = WayDTO.toEntity(map: element);
          osmObjects.add(way);
        case 'relation':
          final relation = RelationDTO.toEntity(map: element);
          osmObjects.add(relation);
        default:
          throw ArgumentError('Unknown type: ${element['type']}');
      }
    }

    return osmObjects;
  }

  @override
  Future<void> saveOSMObjects(List<OSMObject> osmObjects, {String? filePath}) {
    final jsonData = <String, dynamic>{
      'elements': osmObjects.map((e) {
        if (e is Node) {
          return NodeDTO.toDto(node: e);
        } else if (e is Way) {
          return WayDTO.toDto(way: e);
        } else if (e is Relation) {
          return RelationDTO.toDto(relation: e);
        } else {
          throw ArgumentError('Unknown type: ${e.runtimeType}');
        }
      }).toList(),
    };

    final file = File(filePath!);
    return file.writeAsString(json.encode(jsonData));
  }
}
