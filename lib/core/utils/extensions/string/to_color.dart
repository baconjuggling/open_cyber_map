import 'package:flutter/widgets.dart';

extension ColorFromMapColorString on String {
  Color? colorFromMapColorString() {
    if (isEmpty) {
      throw Exception('Color string is empty');
    }
    if (startsWith("#") && length == 10) {
      return Color.fromARGB(
        int.parse(substring(1, 3), radix: 16),
        int.parse(substring(3, 5), radix: 16),
        int.parse(substring(5, 7), radix: 16),
        int.parse(substring(7, 9), radix: 16),
      );
    }

    if (startsWith("#") && length == 9) {
      return Color.fromARGB(
        int.parse(substring(1, 3), radix: 16),
        int.parse(substring(3, 5), radix: 16),
        int.parse(substring(5, 7), radix: 16),
        int.parse(substring(7, 9), radix: 16),
      );
    }
    if (startsWith("#") && length == 7) {
      return Color.fromARGB(
        0xff,
        int.parse(substring(1, 3), radix: 16),
        int.parse(substring(3, 5), radix: 16),
        int.parse(substring(5, 7), radix: 16),
      );
    }
    if (startsWith("#") && length == 4) {
      final String r = substring(1, 2) + substring(1, 2);
      final String g = substring(2, 3) + substring(2, 3);
      final String b = substring(3, 4) + substring(3, 4);
      return Color.fromARGB(
        0xff,
        int.parse(r, radix: 16),
        int.parse(g, radix: 16),
        int.parse(b, radix: 16),
      );
    }
    if ((startsWith('hsla(') || startsWith('hsl(')) && endsWith(')')) {
      final components = replaceAll(RegExp(r"hsla?\("), '')
          .replaceAll(RegExp(r"\)"), '')
          .split(',')
          .map((s) => s.trim())
          .toList();
      if (components.length == 4 || components.length == 3) {
        final hue = double.tryParse(components[0]);
        final saturation =
            double.tryParse(components[1].replaceAll(RegExp('%'), ''));
        final lightness =
            double.tryParse(components[2].replaceAll(RegExp('%'), ''));
        final alpha =
            components.length == 3 ? 1.0 : alphaValueToDouble(components[3]);

        if (hue != null && saturation != null && lightness != null) {
          return HSLColor.fromAHSL(
            alpha,
            hue,
            saturation / 100,
            lightness / 100,
          ).toColor();
        }
      }
    }
    if ((startsWith('rgba(') || startsWith('rgb(')) && endsWith(')')) {
      final components = replaceAll(RegExp(r"rgba?\("), '')
          .replaceAll(RegExp(r"\)"), '')
          .split(',')
          .map((s) => s.trim())
          .toList();
      if (components.length == 4 || components.length == 3) {
        final red = int.tryParse(components[0]);
        final green = int.tryParse(components[1]);
        final blue = int.tryParse(components[2]);
        final alpha =
            components.length == 3 ? 1.0 : alphaValueToDouble(components[3]);

        if (red != null && green != null && blue != null) {
          return Color.fromARGB(
            (alpha * 255).round(),
            red,
            green,
            blue,
          );
        }
      }
    }
    return null;
  }

  double alphaValueToDouble(String alphaValue) {
    if (alphaValue.contains('.')) {
      return double.tryParse(alphaValue) ?? 1.0;
    } else {
      return int.tryParse(alphaValue)?.toDouble() ?? 1.0;
    }
  }
}
