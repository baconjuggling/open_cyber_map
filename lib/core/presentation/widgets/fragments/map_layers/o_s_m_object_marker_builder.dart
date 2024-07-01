import 'package:cyber_map/core/domain/models/marker/o_s_m_object_marker.dart';
import 'package:cyber_map/core/domain/models/osm_object/osm_object.dart';
import 'package:flutter/widgets.dart';
import 'package:latlong2/latlong.dart';

abstract class OSMObjectMarkerBuilder {
  static OSMObjectMarker buildOSMObjectMarker({
    required OSMObject osmObject,
    required LatLng point,
    required String emoji,
  }) {
    return OSMObjectMarker(
      object: osmObject,
      width: 40,
      height: 40,
      point: point,
      child: Text(
        emoji,
        style: TextStyle(
          shadows: [
            const Shadow(
              blurRadius: 8,
            ).scale(1.5),
          ],
          fontSize: 30,
        ),
      ),
    );
  }
}
