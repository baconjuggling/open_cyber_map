import 'dart:developer';

import 'package:cyber_map/core/domain/models/bounding_box/bounding_box.dart';
import 'package:cyber_map/core/domain/models/osm_type/osm_type.dart';

class OverpassQueryBuilder {
  String buildQuery({
    required List<OSMType> types,
    double? centerLatitude,
    double? centerLongitude,
    double? radius,
    List<Map>? tags,
    BoundingBox? boundingBox,
  }) {
    if (centerLatitude == null &&
        centerLongitude == null &&
        boundingBox == null) {
      throw ArgumentError('Either center or boundingBox must be provided.');
    }

    final query = StringBuffer('[out:json];\n');

    var tagConditions = '';
    if (tags != null) {
      tagConditions = tags
          .map((tag) {
            if (tag['value'] != null) {
              return '[${tag['key']}=${tag['value']}]';
            } else {
              return '[${tag['key']}]';
            }
          })
          .toList()
          .join(';');
    }
    if (types.length > 1) {
      query.write('(');
    }

    for (final type in types) {
      final elementType = type.toString().split('.').last;

      if (radius != null && centerLatitude != null && centerLongitude != null) {
        query.write(
          '($elementType(around:$radius,$centerLatitude,$centerLongitude)$tagConditions;);\n',
        );
      } else if (boundingBox != null) {
        query.write(
          '($elementType(${boundingBox.toOSMString()})$tagConditions;);\n',
        );
      } else {
        throw ArgumentError(
          'Either radius with center or boundingBox should be provided.',
        );
      }
    }

    if (types.length > 1) {
      query.write(');');
    }

    query.write('out body;\n');

    query.write('>;\nout skel qt;');

    log(query.toString().trim());

    return query.toString().trim();
  }
}
