import 'package:cyber_map/core/domain/models/osm_object/osm_object.dart';

abstract class ILocalOSMRepository {
  Future<List<OSMObject>> loadOSMObjects({required String filePath});
  Future<void> saveOSMObjects(List<OSMObject> osmObjects, {String? filePath});
}
