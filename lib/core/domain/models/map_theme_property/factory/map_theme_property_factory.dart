import 'package:cyber_map/core/domain/models/map_theme_property/interface/i_map_theme_property.dart';
import 'package:cyber_map/core/domain/models/map_theme_property/map_theme_property.dart';
import 'package:cyber_map/core/domain/models/map_theme_property/map_theme_property_with_stops.dart';

class MapThemePropertyFactory {
  static IMapThemeProperty<T> createMapThemeProperty<T>(T value) {
    if (value is Map<String, dynamic> && value.containsKey('stops')) {
      return MapThemePropertyWithStops<T>(
        base: value['base'] as T,
        stops: value['stops'] as List<List<dynamic>>,
      );
    }
    return MapThemeProperty<T>(value: value);
  }
}
