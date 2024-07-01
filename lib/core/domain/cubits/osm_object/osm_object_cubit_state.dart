import 'package:cyber_map/core/domain/models/node/node.dart';
import 'package:cyber_map/core/domain/models/osm_object/osm_object.dart';
import 'package:cyber_map/core/domain/models/osm_type/osm_type.dart';
import 'package:cyber_map/core/domain/models/relation/relation.dart';
import 'package:cyber_map/core/domain/models/way/way.dart';
import 'package:cyber_map/core/utils/extensions/latlng/distance_to.dart';
import 'package:cyber_map/core/utils/route_util.dart';
import 'package:latlong2/latlong.dart';

class OsmDataCubitState {
  const OsmDataCubitState();
}

class OsmDataCubitInitial extends OsmDataCubitState {
  const OsmDataCubitInitial();
}

class OsmDataCubitLoading extends OsmDataCubitState {
  const OsmDataCubitLoading();
}

class OsmDataCubitLoaded extends OsmDataCubitState {
  OsmDataCubitLoaded({
    required Map<int, Node> nodeMap,
    required Map<int, Way> wayMap,
    required Map<int, Relation> relationMap,
    required double radius,
    required LatLng center,
  })  : _radius = radius,
        _nodeMap = nodeMap,
        _wayMap = wayMap,
        _center = center,
        _relationMap = relationMap {
    final allObjects = [
      ..._nodeMap.values,
      ..._wayMap.values,
      ..._relationMap.values,
    ];

    final tagMap = <String, Map<String, List<OSMObject>>>{};
    for (final obj in getObjectsInRadius(
      center,
      radius,
      allObjects,
    )) {
      for (final entry in obj.tags.entries) {
        tagMap
            .putIfAbsent(
              RouteUtil.formatRouteName(entry.key),
              () => {},
            )
            .putIfAbsent(
              RouteUtil.formatRouteName(entry.value.toString()),
              () => [],
            )
            .add(obj);
      }
    }
    _tagMap = tagMap;
  }

  final double _radius;
  final LatLng _center;
  final Map<int, Node> _nodeMap;
  final Map<int, Way> _wayMap;
  final Map<int, Relation> _relationMap;
  late final Map<String, Map<String, List<OSMObject>>> _tagMap;

  LatLng get center => _center;
  Map<int, Node> get nodeMap => _nodeMap;

  Map<int, Way> get wayMap => _wayMap;

  Map<int, Relation> get relationMap => _relationMap;

  Map<String, Map<String, List<OSMObject>>> get tagMap => _tagMap;

  double get radius => _radius;

  List<OSMObject> getObjectsInRadius(
    LatLng center,
    double radius,
    List<OSMObject> allObjects,
  ) {
    final objectsInRadius = allObjects
        .where(
          (obj) =>
              getCenter(
                obj is Node
                    ? OSMType.node
                    : obj is Way
                        ? OSMType.way
                        : OSMType.relation,
                obj.id,
              ).distanceTo(center) <=
              radius,
        )
        .toList();

    objectsInRadius.sort(
      (a, b) => getCenter(
        a is Node
            ? OSMType.node
            : a is Way
                ? OSMType.way
                : OSMType.relation,
        a.id,
      ).distanceTo(center).compareTo(
            getCenter(
              b is Node
                  ? OSMType.node
                  : b is Way
                      ? OSMType.way
                      : OSMType.relation,
              b.id,
            ).distanceTo(center),
          ),
    );

    return objectsInRadius;
  }

  LatLng getCenter(OSMType osmType, int id) {
    if (osmType == OSMType.node) {
      return LatLng(_nodeMap[id]!.latitude, _nodeMap[id]!.longitude);
    }
    if (osmType == OSMType.way) {
      final way = _wayMap[id]!;
      final nodes = way.nodes
          .map((nodeId) => _nodeMap[nodeId])
          .where((node) => node != null)
          .toList();
      final latitudes = nodes.map((node) => node!.latitude).toList();
      final longitudes = nodes.map((node) => node!.longitude).toList();
      double latitude;
      double longitude;
      if (latitudes.isNotEmpty) {
        latitude = latitudes.reduce((a, b) => a + b) / latitudes.length;
      } else {
        latitude = 0.0;
      }

      if (longitudes.isNotEmpty) {
        longitude = longitudes.reduce((a, b) => a + b) / longitudes.length;
      } else {
        longitude = 0.0;
      }

      return LatLng(latitude, longitude);
    } else if (osmType == OSMType.relation) {
      return const LatLng(0, 0);
    }
    throw Exception('Invalid OSM Type');
  }

  OSMObject getObject(OSMType osmType, int id) {
    switch (osmType) {
      case OSMType.node:
        return _nodeMap[id]!;
      case OSMType.way:
        return _wayMap[id]!;
      case OSMType.relation:
        return _relationMap[id]!;
      default:
        throw Exception('Invalid OSM Type');
    }
  }
}

class OsmDataCubitSyncing extends OsmDataCubitLoaded {
  OsmDataCubitSyncing({
    required super.nodeMap,
    required super.wayMap,
    required super.relationMap,
    required super.radius,
    required super.center,
    required this.progress,
    required this.message,
    required this.fetchedItems,
  });
  final double progress;
  final String message;
  final int fetchedItems;
}
