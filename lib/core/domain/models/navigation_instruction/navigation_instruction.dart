import 'package:latlong2/latlong.dart';

abstract class NavigationInstruction {
  NavigationInstruction({
    required this.instruction,
    required this.duration,
    required this.distance,
    required this.location,
  });

  final String instruction;
  final Duration duration;
  final double distance;
  final LatLng location;
}
