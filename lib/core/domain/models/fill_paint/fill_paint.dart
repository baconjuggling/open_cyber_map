import 'dart:ui';

import 'package:cyber_map/core/domain/models/map_paint/map_paint.dart';
import 'package:cyber_map/core/domain/models/map_theme_property/interface/i_map_theme_property.dart';

class FillPaint extends MapPaint {
  FillPaint({
    this.fillColor,
    this.fillOpacity,
    this.fillOutlineColor,
    this.fillPattern,
    this.fillTranslate,
    this.fillDashArray,
    this.fillWidth,
  });
  IMapThemeProperty<Color?>? fillColor;
  IMapThemeProperty<double?>? fillOpacity;
  IMapThemeProperty<Color?>? fillOutlineColor;
  IMapThemeProperty<String?>? fillPattern;
  IMapThemeProperty<List<double>?>? fillTranslate;
  IMapThemeProperty<List<double>?>? fillDashArray;
  IMapThemeProperty<double?>? fillWidth;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {};
    if (fillColor != null) data['fill-color'] = fillColor!.toMapThemeData;
    if (fillOpacity != null) data['fill-opacity'] = fillOpacity!.toMapThemeData;
    if (fillOutlineColor != null) {
      data['fill-outline-color'] = fillOutlineColor!.toMapThemeData;
    }
    if (fillPattern != null) data['fill-pattern'] = fillPattern!.toMapThemeData;
    if (fillTranslate != null) {
      data['fill-translate'] = fillTranslate!.toMapThemeData;
    }
    if (fillDashArray != null) {
      data['fill-dasharray'] = fillDashArray!.toMapThemeData;
    }
    if (fillWidth != null) data['fill-width'] = fillWidth!.toMapThemeData;
    return data;
  }
}
