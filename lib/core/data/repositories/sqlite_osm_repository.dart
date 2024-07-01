import 'dart:convert';

import 'package:cyber_map/core/data/data_transfer_objects/relation_member_dto.dart';
import 'package:cyber_map/core/domain/models/node/node.dart';
import 'package:cyber_map/core/domain/models/osm_object/osm_object.dart';
import 'package:cyber_map/core/domain/models/relation/relation.dart';
import 'package:cyber_map/core/domain/models/way/way.dart';
import 'package:cyber_map/core/domain/repositories/i_local_osm_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';

@Injectable(as: ILocalOSMRepository)
@Environment(Environment.dev)
class SQLiteOSMRepository implements ILocalOSMRepository {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('osmObjects.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final path = await getDatabasesPath();
    final dbPath = '$path/$filePath';
    return await openDatabase(dbPath, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE nodes(id INTEGER PRIMARY KEY, tags TEXT, latitude REAL, longitude REAL)',
    );
    await db.execute(
      'CREATE TABLE ways(id INTEGER PRIMARY KEY, tags TEXT, nodes TEXT)',
    );
    await db.execute(
      'CREATE TABLE relations(id INTEGER PRIMARY KEY, tags TEXT, members TEXT)',
    );
  }

  @override
  Future<List<OSMObject>> loadOSMObjects({required String filePath}) async {
    final db = await database;
    final nodes = await db.query('nodes');
    final ways = await db.query('ways');
    final relations = await db.query('relations');
    final osmObjects = <OSMObject>[];
    for (final node in nodes) {
      osmObjects.add(
        Node(
          id: node['id']! as int,
          tags: json.decode(node['tags']! as String) as Map<String, dynamic>,
          latitude: node['latitude']! as double,
          longitude: node['longitude']! as double,
        ),
      );
    }
    for (final way in ways) {
      osmObjects.add(
        Way(
          id: way['id']! as int,
          tags: json.decode(way['tags']! as String) as Map<String, dynamic>,
          nodes: (json.decode(way['nodes']! as String) as List<dynamic>)
              .map((item) => item as int)
              .toList(),
        ),
      );
    }
    for (final relation in relations) {
      osmObjects.add(
        Relation(
          id: relation['id']! as int,
          tags:
              json.decode(relation['tags']! as String) as Map<String, dynamic>,
          members:
              (json.decode(relation['members']! as String) as List<dynamic>)
                  .map((item) => item as Map<String, dynamic>)
                  .map((item) => RelationMemberDTO.toEntity(map: item))
                  .toSet(),
        ),
      );
    }
    return osmObjects;
  }

  @override
  Future<void> saveOSMObjects(
    List<OSMObject> osmObjects, {
    String? filePath,
  }) async {
    final db = await database;
    final batch = db.batch();
    for (final osmObject in osmObjects) {
      final tags = json.encode(osmObject.tags);
      bool exists = false;
      // Check if the object exists based on its type and ID
      switch (osmObject.runtimeType) {
        case Node:
          final node = osmObject as Node;
          final existingNode = await db.query(
            'nodes',
            where: 'id = ?',
            whereArgs: [node.id],
          );
          exists = existingNode.isNotEmpty;
          if (!exists) {
            final nodeMap = {
              'id': node.id,
              'tags': tags,
              'latitude': node.latitude,
              'longitude': node.longitude,
            };
            batch.insert(
              'nodes',
              nodeMap,
              conflictAlgorithm: ConflictAlgorithm.ignore,
            );
          }
        case Way:
          final way = osmObject as Way;
          final existingWay = await db.query(
            'ways',
            where: 'id = ?',
            whereArgs: [way.id],
          );
          exists = existingWay.isNotEmpty;
          if (!exists) {
            final wayMap = {
              'id': way.id,
              'tags': tags,
              'nodes': json.encode(way.nodes),
            };
            batch.insert(
              'ways',
              wayMap,
              conflictAlgorithm: ConflictAlgorithm.ignore,
            );
          }
        case Relation:
          final relation = osmObject as Relation;
          final existingRelation = await db.query(
            'relations',
            where: 'id = ?',
            whereArgs: [relation.id],
          );
          exists = existingRelation.isNotEmpty;
          if (!exists) {
            final relationMap = {
              'id': relation.id,
              'tags': tags,
              'members': json.encode(
                relation.members
                    .map((e) => RelationMemberDTO.toDto(relationMember: e))
                    .toList(),
              ),
            };
            batch.insert(
              'relations',
              relationMap,
              conflictAlgorithm: ConflictAlgorithm.ignore,
            );
          }
        default:
          throw ArgumentError('Unknown type: ${osmObject.runtimeType}');
      }
    }
    await batch.commit(noResult: true);
  }
}
