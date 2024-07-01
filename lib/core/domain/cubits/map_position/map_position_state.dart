import 'package:cyber_map/core/domain/models/navigation_instruction/navigation_instruction.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:routing_client_dart/routing_client_dart.dart';

abstract class MapPositionState {}

class MapPositionStateLoaded extends MapPositionState {
  MapPositionStateLoaded({
    required this.position,
    required this.zoom,
    required this.rotation,
  });
  final LatLng position;
  final double zoom;
  final double rotation;
}

extension ToLatLng on LngLat {
  LatLng toLatLng() => LatLng(lat, lng);
}

extension ToLngLat on LatLng {
  LngLat toLngLat() => LngLat(lng: longitude, lat: latitude);
}

class RoadInstructionMarker extends Marker {
  const RoadInstructionMarker({
    required this.instruction,
    required super.child,
    required super.point,
    super.width,
    super.height,
    bool super.rotate = true,
  });
  final NavigationInstruction instruction;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RoadInstructionMarker &&
        other.instruction == instruction &&
        other.point == point &&
        other.width == width &&
        other.height == height &&
        other.rotate == rotate;
  }

  @override
  int get hashCode {
    return instruction.hashCode ^
        point.hashCode ^
        width.hashCode ^
        height.hashCode ^
        rotate.hashCode;
  }
}
