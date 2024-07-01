import 'dart:ui';

import 'package:cyber_map/core/domain/models/map_paint/map_paint.dart';
import 'package:cyber_map/core/utils/extensions/color/to_map_color_string.dart';

class SymbolPaint extends MapPaint {
  SymbolPaint({
    this.textColor,
    this.textSize,
    this.textHaloColor,
    this.textHaloWidth,
    this.textOpacity,
    this.iconColor,
    this.iconImage,
    this.iconSize,
    this.iconOpacity,
    this.iconRotate,
    this.iconOffset,
    this.textHaloBlur,
  });
  Color? textColor;
  double? textSize;
  Color? textHaloColor;
  double? textHaloWidth;
  double? textOpacity;
  String? iconImage;
  double? iconSize;
  double? iconOpacity;
  double? iconRotate;
  double? iconOffset;
  double? textHaloBlur;
  Color? iconColor;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {};
    if (textColor != null) data['text-color'] = textColor!.toMapColorString();
    if (textSize != null) data['text-size'] = textSize;
    if (textHaloColor != null) {
      data['text-halo-color'] = textHaloColor!.toMapColorString();
    }
    if (textHaloWidth != null) data['text-halo-width'] = textHaloWidth;
    if (textOpacity != null) data['text-opacity'] = textOpacity;
    if (iconImage != null) data['icon-image'] = iconImage;
    if (iconSize != null) data['icon-size'] = iconSize;
    if (iconOpacity != null) data['icon-opacity'] = iconOpacity;
    if (iconRotate != null) data['icon-rotate'] = iconRotate;
    if (iconOffset != null) data['icon-offset'] = iconOffset;
    if (textHaloBlur != null) data['text-halo-blur'] = textHaloBlur;
    if (iconColor != null) data['icon-color'] = iconColor!.toMapColorString();
    return data;
  }
}
