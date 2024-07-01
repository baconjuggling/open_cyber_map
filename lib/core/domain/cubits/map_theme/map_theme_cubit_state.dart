import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:cyber_map/core/domain/models/map_theme_property/interface/i_map_theme_property.dart';
import 'package:cyber_map/core/domain/models/map_theme_property/map_theme_property.dart';
import 'package:cyber_map/core/domain/models/map_theme_property/map_theme_property_with_stops.dart';
import 'package:cyber_map/core/utils/extensions/string/to_color.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';
import 'package:vector_tile_renderer/vector_tile_renderer.dart' as vtr;

abstract class MapThemeCubitState {}

class MapThemeCubitStateLoaded extends MapThemeCubitState {
  MapThemeCubitStateLoaded({
    required this.themeData,
    this.spriteStyle,
  }) {
    theme = vtr.ThemeReader().read(themeData);
  }
  late vtr.Theme theme;
  final Map<String, dynamic> themeData;
  SpriteStyle? spriteStyle;

  List<String> get layerIds {
    return (themeData['layers'] as List<dynamic>)
        .map<String>((layer) => layer['id'] as String)
        .toList();
  }

  Map<String, List<String>> get sourceLayers {
    final Map<String, List<String>> sourceLayers = {};

    for (final element in layerIds) {
      final layer = themeData['layers'].firstWhere(
        (layer) => layer['id'] == element,
      );

      if (layer['source-layer'] != null) {
        final source = layer['source-layer'] as String;
        if (sourceLayers.containsKey(source)) {
          sourceLayers[source]!.add(element);
        } else {
          sourceLayers[source] = [element];
        }
      }
    }

    return sourceLayers;
  }

  List<String> get layersWithoutSource {
    final List<String> layersWithoutSource = [];

    for (final element in layerIds) {
      final layer = themeData['layers'].firstWhere(
        (layer) => layer['id'] == element,
        orElse: () => <String, Object>{},
      );

      if (layer['source-layer'] == null) {
        layersWithoutSource.add(element);
      }
    }

    return layersWithoutSource;
  }

  String getColorString(String colorKey, String layerId) {
    return themeData['layers']
            .firstWhere(
              (element) => element['id'] == layerId,
              orElse: () => {
                'paint': {colorKey: ''},
              },
            )['paint'][colorKey]
            ?.toString() ??
        '';
  }

  String getLayerType(String layerId) {
    return themeData['layers'].firstWhere(
      (element) => element['id'] == layerId,
      orElse: () => {'type': ''},
    )['type'] as String;
  }

  IMapThemeProperty getPaintColor(String layerId) {
    String? colorString;
    if (getLayerType(layerId) == 'line') {
      colorString = getColorString('line-color', layerId);
    } else if (getLayerType(layerId) == 'fill') {
      colorString = getColorString('fill-color', layerId);
    } else if (getLayerType(layerId) == 'symbol') {
      colorString = getColorString('text-color', layerId);
    } else if (getLayerType(layerId) == 'background') {
      colorString = getColorString('background-color', layerId);
    }

    if (colorString == '' || colorString == null) {
      return MapThemeProperty<Color>(value: const Color(0x00000000));
    }

    if (colorString.startsWith('{') || colorString.startsWith('[')) {
      log('colorString: $colorString');
      colorString = colorString.replaceAll('base', '"base"');
      colorString = colorString.replaceAll('stops', '"stops"');

      colorString.replaceAllMapped(
        RegExp(r'(\w+):'),
        (match) => '"${match.group(1)}":',
      );

      colorString = colorString.replaceAllMapped(
        RegExp(r'rgba\(([^)]+)\)'),
        (match) => '"rgba(${match.group(1)})"',
      );

      colorString = colorString.replaceAllMapped(
        RegExp(r'hsla\(([^)]+)\)'),
        (match) => '"hsla(${match.group(1)})"',
      );

      colorString = colorString.replaceAllMapped(
        RegExp(r'rgb\(([^)]+)\)'),
        (match) => '"rgb(${match.group(1)})"',
      );

      colorString = colorString.replaceAllMapped(
        RegExp('#([0-9a-fA-F]+)'),
        (match) => '"#${match.group(1)}"',
      );

      final Map<String, dynamic> colorData =
          jsonDecode(colorString) as Map<String, dynamic>;

      if (colorData.containsKey('stops')) {
        return MapThemePropertyWithStops(
          base: colorData['base'],
          stops: List<List<dynamic>>.from(colorData['stops'] as List<dynamic>)
              .map(
                (stop) => [
                  stop[0],
                  stop[1].toString().colorFromMapColorString(),
                ],
              )
              .toList(),
        );
      }
    } else {
      return MapThemeProperty<Color>(
        value: colorString.colorFromMapColorString()!,
      );
    }
    throw Exception('Failed to parse color data');
  }
}

class MapThemeCubitStateInitial extends MapThemeCubitState {}
