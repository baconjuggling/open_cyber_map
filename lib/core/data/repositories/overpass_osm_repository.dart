import 'dart:convert';
import 'dart:developer';

import 'package:cyber_map/core/config/app_configuration.dart';
import 'package:cyber_map/core/data/data_transfer_objects/node_dto.dart';
import 'package:cyber_map/core/data/data_transfer_objects/relation_dto.dart';
import 'package:cyber_map/core/data/data_transfer_objects/way_dto.dart';
import 'package:cyber_map/core/domain/models/bounding_box/bounding_box.dart';
import 'package:cyber_map/core/domain/models/osm_object/osm_object.dart';
import 'package:cyber_map/core/domain/models/osm_type/osm_type.dart';
import 'package:cyber_map/core/domain/repositories/i_osm_repository.dart';
import 'package:cyber_map/core/utils/overpass_query_builder.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

@Injectable(as: IOSMRepository)
@Environment(Environment.dev)
class OverpassOSMRepository implements IOSMRepository {
  OverpassOSMRepository(this._client);

  final http.Client _client;

  final Uri _apiUri = Uri.parse(
    '${AppConfiguration.overpassHost}${AppConfiguration.overpassPath}',
  );

  final Map<String, String> _headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  @override
  Future<List<OSMObject>> fetchOSMObjects({
    required List<OSMType> types,
    double? latitude,
    double? longitude,
    double? radius,
    BoundingBox? boundingBox,
    List<Map>? tags,
  }) async {
    log(name: 'OverpassOSMRepository', 'fetchOSMObjects');
    final buildOSMQuery = OverpassQueryBuilder();
    final overpassQuery = buildOSMQuery.buildQuery(
      types: types,
      centerLatitude: latitude,
      centerLongitude: longitude,
      radius: radius,
      boundingBox: boundingBox,
      tags: tags,
    );

    final jsonData = await _fetchDataFromOverpassAPI(overpassQuery);
    return _parseOSMObjects(jsonData);
  }

  Future<Map<String, dynamic>> _fetchDataFromOverpassAPI(String query) async {
    final response = await _client.post(
      _apiUri,
      headers: _headers,
      body: {'data': query},
    ).timeout(
      const Duration(seconds: 180),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }

  List<OSMObject> _parseOSMObjects(Map<String, dynamic> jsonData) {
    final overpassObjects = <OSMObject>[];
    final elements = jsonData['elements'] as List<dynamic>;
    for (final dynamic element in elements) {
      final Map<String, dynamic>? mapElement = element as Map<String, dynamic>?;
      if (mapElement != null) {
        switch (mapElement['type']) {
          case 'node':
            final node = NodeDTO.toEntity(map: mapElement);
            overpassObjects.add(node);

          case 'way':
            final way = WayDTO.toEntity(map: mapElement);
            overpassObjects.add(way);

          case 'relation':
            final relation = RelationDTO.toEntity(map: mapElement);
            overpassObjects.add(relation);

          default:
            throw ArgumentError('Unknown type: ${mapElement['type']}');
        }
      }
    }

    return overpassObjects;
  }
}
