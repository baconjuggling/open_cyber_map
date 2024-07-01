import 'package:cyber_map/core/domain/models/bounding_box/bounding_box.dart';
import 'package:cyber_map/core/domain/models/osm_object/osm_object.dart';
import 'package:cyber_map/core/domain/models/osm_type/osm_type.dart';

abstract class IOSMRepository {
  Future<List<OSMObject>> fetchOSMObjects({
    required List<OSMType> types,
    double? latitude,
    double? longitude,
    double? radius,
    BoundingBox? boundingBox,
    List<Map>? tags,
  });
}
