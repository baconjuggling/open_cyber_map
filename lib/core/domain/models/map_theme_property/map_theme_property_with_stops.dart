import 'dart:ui';

import 'package:cyber_map/core/domain/models/map_theme_property/interface/i_map_theme_property.dart';
import 'package:cyber_map/core/utils/extensions/color/to_map_color_string.dart';

class MapThemePropertyWithStops<T> extends IMapThemeProperty<T> {
  MapThemePropertyWithStops({
    required this.base,
    required this.stops,
  });
  T base;
  List<List<dynamic>> stops;
  @override
  Map<String, Object?> get toMapThemeData {
    for (final stop in stops) {
      if (stop[1] is Color) {
        stop[1] = (stop[1] as Color).toMapColorString();
      }
    }

    return {
      'base': base is Color ? (base as Color).toMapColorString() : base,
      'stops': stops,
    };
  }
}
