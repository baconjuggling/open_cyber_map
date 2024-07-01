import 'dart:ui';

import 'package:cyber_map/core/domain/models/map_paint/map_paint.dart';
import 'package:cyber_map/core/domain/models/map_theme_property/interface/i_map_theme_property.dart';

class LinePaint extends MapPaint {
  LinePaint({
    this.lineColor,
    this.lineOpacity,
    this.lineWidth,
    this.lineDashArray,
  });
  IMapThemeProperty<Color?>? lineColor;
  IMapThemeProperty<double?>? lineOpacity;
  IMapThemeProperty<double?>? lineWidth;
  IMapThemeProperty<String?>? lineDashArray;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {};
    if (lineColor != null) data['line-color'] = lineColor!.toMapThemeData;
    if (lineOpacity != null) data['line-opacity'] = lineOpacity!.toMapThemeData;
    if (lineWidth != null) data['line-width'] = lineWidth!.toMapThemeData;
    if (lineDashArray != null) {
      data['line-dasharray'] = lineDashArray!.toMapThemeData;
    }
    return data;
  }
}
