import 'dart:async';

import 'package:cyber_map/core/config/app_configuration.dart';
import 'package:cyber_map/core/domain/cubits/map_position/map_position_state.dart';
import 'package:cyber_map/core/domain/cubits/navigation/navigation_route_cubit_state.dart';
import 'package:cyber_map/core/domain/models/navigation_instruction/navigation_instruction.dart';
import 'package:cyber_map/core/domain/models/navigation_route/navigation_route.dart';
import 'package:cyber_map/core/domain/models/navigation_route_leg/navigation_route_leg.dart';
import 'package:cyber_map/core/domain/repositories/i_navigation_route_repository.dart';
import 'package:cyber_map/core/presentation/widgets/fragments/map_layers/navigation_layer.dart';
import 'package:latlong2/latlong.dart';
import 'package:routing_client_dart/routing_client_dart.dart';

class NavigationRouteRepository implements INavigationRouteRepository {
  NavigationRouteRepository();

  final OSRMManager manager = OSRMManager.custom(
    server: AppConfiguration.osrmHost,
    roadType: RoadType.foot,
  );

  @override
  Future<NavigationRoute> getRoute({
    required List<LatLng> selectedLocations,
    required bool roundTrip,
    required bool travelingSalesman,
  }) async {
    final waypoints = [
      ...selectedLocations.map((location) => location.toLngLat()),
    ];

    if (travelingSalesman) {
      final route = await manager.getTrip(
        roundTrip: roundTrip,
        source: SourceGeoPointOption.first,
        destination: DestinationGeoPointOption.last,
        geometries: Geometries.polyline6,
        roadType: RoadType.foot,
        waypoints: waypoints,
      );

      final instructions = await manager.buildInstructions(route);
      final List<NavigationRouteLeg> legs = [];
      final List<LatLng> allPointPolyline =
          PolylineDecoder.decode(route.polylineEncoded!);

      List<NavigationInstruction> currentLegInstructions = [];
      for (final instruction in instructions) {
        if (instruction.instruction.toLowerCase().contains('arrive')) {
          currentLegInstructions.add(
            createNavigationInstructionFromRoadInstruction(instruction),
          );
          final List<LatLng> currentPolyline = allPointPolyline.sublist(
            0,
            allPointPolyline.indexOf(instruction.location.toLatLng()) + 1,
          );
          allPointPolyline.removeRange(0, currentPolyline.length);

          legs.add(
            NavigationRouteLeg(
              instructions: currentLegInstructions,
              polyline: currentPolyline,
            ),
          );
          currentLegInstructions = [];
        } else {
          currentLegInstructions.add(
            createNavigationInstructionFromRoadInstruction(instruction),
          );
        }
      }

      return NavigationRoute(
        legs: legs,
      );
    } else {
      final route = await manager.getRoad(
        waypoints: waypoints,
        geometries: Geometries.polyline6,
        roadType: RoadType.foot,
      );

      final List<LatLng> allPointPolyline =
          PolylineDecoder.decode(route.polylineEncoded!);

      final instructions = await manager.buildInstructions(route);
      final List<NavigationRouteLeg> legs = [];
      List<NavigationInstruction> currentLegInstructions = [];
      for (final instruction in instructions) {
        if (instruction.instruction.toLowerCase().contains('arrive')) {
          currentLegInstructions.add(
            createNavigationInstructionFromRoadInstruction(instruction),
          );
          final List<LatLng> currentPolyline = allPointPolyline.sublist(
            0,
            allPointPolyline.indexOf(instruction.location.toLatLng()) + 1,
          );

          allPointPolyline.removeRange(0, currentPolyline.length);

          legs.add(
            NavigationRouteLeg(
              instructions: currentLegInstructions,
              polyline: currentPolyline,
            ),
          );
          currentLegInstructions = [];
        } else {
          currentLegInstructions.add(
            createNavigationInstructionFromRoadInstruction(instruction),
          );
        }
      }

      return NavigationRoute(
        legs: legs,
      );
    }
  }
}
