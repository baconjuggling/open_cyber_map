import 'package:flutter/widgets.dart';

extension ToMapColorString on Color {
  String toMapColorString() {
    return 'rgba($red,$green,$blue,${alpha / 255})';
  }
}
