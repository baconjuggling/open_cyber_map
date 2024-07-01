import 'dart:ui';

import 'package:cyber_map/core/domain/models/map_theme_property/interface/i_map_theme_property.dart';
import 'package:cyber_map/core/utils/extensions/color/to_map_color_string.dart';

class MapThemeProperty<T> extends IMapThemeProperty<T> {
  MapThemeProperty({
    required this.value,
  });
  final T value;

  @override
  Object? get toMapThemeData {
    if (value is Color) {
      return (value as Color).toMapColorString();
    }
    return value;
  }
}
