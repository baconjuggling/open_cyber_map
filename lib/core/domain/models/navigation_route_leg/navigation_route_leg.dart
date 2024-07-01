import 'package:cyber_map/core/domain/models/navigation_instruction/navigation_instruction.dart';
import 'package:latlong2/latlong.dart';

class NavigationRouteLeg {
  NavigationRouteLeg({required this.instructions, required this.polyline});

  final List<NavigationInstruction> instructions;
  final List<LatLng> polyline;

  Duration get totalDuration {
    return instructions.fold(
      Duration.zero,
      (previousValue, element) => previousValue + element.duration,
    );
  }

  double get totalDistance {
    return instructions.fold(
      0,
      (previousValue, element) => previousValue + element.distance,
    );
  }

  String get totalDistanceString {
    return totalDistance.toStringAsFixed(2);
  }

  String get totalDurationString {
    return totalDuration.toString();
  }
}
