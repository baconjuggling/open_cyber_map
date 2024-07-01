import 'dart:async';

import 'package:cyber_map/core/config/theme/map_theme_data.dart';
import 'package:cyber_map/core/data/repositories/json_theme_data_repository.dart';
import 'package:cyber_map/core/domain/cubits/map_theme/map_theme_cubit_state.dart';
import 'package:cyber_map/core/utils/extensions/color/to_map_color_string.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MapThemeCubit extends Cubit<MapThemeCubitState> {
  MapThemeCubit() : super(MapThemeCubitStateInitial()) {
    loadMapTheme();
  }

  JsonThemeDataRepository themeDataRepository = JsonThemeDataRepository();

  Future<void> loadMapTheme() async {
    emit(
      MapThemeCubitStateLoaded(
        themeData: await themeDataRepository.loadThemeData(),
      ),
    );
  }

  Future<void> saveMapTheme() async {
    if (state is MapThemeCubitStateLoaded) {
      await themeDataRepository.saveThemeData(
        (state as MapThemeCubitStateLoaded).themeData,
      );
    }
  }

  void resetMapTheme() {
    emit(
      MapThemeCubitStateLoaded(
        themeData: Map<String, dynamic>.from(
          themeDataRepository.getDefaultThemeData(),
        ),
      ),
    );
  }

  Future<void> importThemeData() async {
    emit(
      MapThemeCubitStateLoaded(
        themeData: await themeDataRepository.importThemeData(),
      ),
    );
  }

  Future<void> exportThemeData() async {
    await themeDataRepository.exportThemeData(
      (state as MapThemeCubitStateLoaded).themeData,
    );
  }

  void setLayerVisibility(String layerId, String visibility) {
    late final Map<String, dynamic> newThemeData;
    if (state is MapThemeCubitStateLoaded) {
      newThemeData = Map<String, dynamic>.from(
        (state as MapThemeCubitStateLoaded).themeData,
      );
    } else {
      newThemeData = Map<String, dynamic>.from(defaultThemeData);
    }
    newThemeData['layers'].forEach((layer) {
      if (layer['id'] == layerId) {
        layer['layout'] = layer['layout'] ?? {};
        layer['layout'].putIfAbsent('visibility', () => 'none');
        layer['layout']['visibility'] = visibility;
      }
    });

    emit(
      MapThemeCubitStateLoaded(
        themeData: newThemeData,
        spriteStyle: (state as MapThemeCubitStateLoaded).spriteStyle,
      ),
    );
  }

  void setPaintColor(String layerId, Color color) {
    if (state is MapThemeCubitStateLoaded) {
      if ((state as MapThemeCubitStateLoaded).getLayerType(layerId) == 'line') {
        changeLayerColor(layerId, color);
      } else if ((state as MapThemeCubitStateLoaded).getLayerType(layerId) ==
          'fill') {
        changeLayerColor(layerId, color);
      } else if ((state as MapThemeCubitStateLoaded).getLayerType(layerId) ==
          'symbol') {
        changeLayerColor(layerId, color);
      } else if ((state as MapThemeCubitStateLoaded).getLayerType(layerId) ==
          'background') {
        changeLayerColor(layerId, color);
      }
    }
  }

  void changeLayerColor(String layerId, Color color) {
    late final Map<String, dynamic> newThemeData;
    if (state is MapThemeCubitStateLoaded) {
      newThemeData = Map<String, dynamic>.from(
        (state as MapThemeCubitStateLoaded).themeData,
      );
    } else {
      newThemeData = Map<String, dynamic>.from(defaultThemeData);
    }
    newThemeData['layers'].forEach((layer) {
      if (layer['id'] == layerId) {
        final String colorString = color.toMapColorString();
        final String opacityString = color.opacity.toString();
        if (layer['type'] == 'line') {
          layer['paint']['line-color'] = colorString;
          layer['paint']['line-opacity'] = opacityString;
        } else if (layer['type'] == 'fill') {
          layer['paint']['fill-color'] = colorString;
          layer['paint']['fill-opacity'] = opacityString;
        } else if (layer['type'] == 'symbol') {
          layer['paint']['text-color'] = colorString;
          layer['paint']['text-opacity'] = opacityString;
        } else if (layer['type'] == 'background') {
          layer['paint']['background-color'] = colorString;
          layer['paint']['background-opacity'] = opacityString;
        }
      }
    });

    emit(
      MapThemeCubitStateLoaded(
        themeData: newThemeData,
        spriteStyle: (state as MapThemeCubitStateLoaded).spriteStyle,
      ),
    );
  }

  toggleLayer(String id) {
    late final Map<String, dynamic> newThemeData;
    if (state is MapThemeCubitStateLoaded) {
      newThemeData = Map<String, dynamic>.from(
        (state as MapThemeCubitStateLoaded).themeData,
      );
    } else {
      newThemeData = Map<String, dynamic>.from(defaultThemeData);
    }
    newThemeData['layers'].forEach((layer) {
      if (layer['id'] == id) {
        layer['layout'] = layer['layout'] ?? {};
        layer['layout'].putIfAbsent('visibility', () => 'none');
        layer['layout']['visibility'] =
            layer['layout']['visibility'] == 'visible' ? 'none' : 'visible';
      }
    });

    emit(
      MapThemeCubitStateLoaded(
        themeData: newThemeData,
        spriteStyle: (state as MapThemeCubitStateLoaded).spriteStyle,
      ),
    );
  }

  Future<Uint8List> loadAtlas() async {
    final ByteData data =
        await rootBundle.load('assets/images/osm-liberty.png');
    return data.buffer.asUint8List();
  }
}
