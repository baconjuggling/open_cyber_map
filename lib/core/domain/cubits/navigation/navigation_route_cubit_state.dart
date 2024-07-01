import 'package:cyber_map/core/domain/cubits/map_position/map_position_state.dart';
import 'package:cyber_map/core/domain/models/latlng_instruction/lat_lng_instruction.dart';
import 'package:cyber_map/core/domain/models/navigation_instruction/navigation_instruction.dart';
import 'package:cyber_map/core/domain/models/navigation_route/navigation_route.dart';
import 'package:cyber_map/core/domain/models/navigation_route_leg/navigation_route_leg.dart';
import 'package:routing_client_dart/routing_client_dart.dart';

abstract class NavigationRouteCubitState {}

class NavigationRouteCubitStateInitial extends NavigationRouteCubitState {}

class NavigationRouteCubitStateLoaded extends NavigationRouteCubitState {
  NavigationRouteCubitStateLoaded({
    required this.route,
    required this.currentLeg,
    required this.currentInstruction,
  });

  final NavigationRoute route;
  final NavigationRouteLeg currentLeg;
  final NavigationInstruction currentInstruction;

  NavigationInstruction? get previousInstruction {
    final currentLegInstructions = currentLeg.instructions;
    final currentInstructionIndex =
        currentLegInstructions.indexOf(currentInstruction);
    final previousInstructionIndex = currentInstructionIndex - 1;
    if (previousInstructionIndex >= 0) {
      return currentLegInstructions[previousInstructionIndex];
    } else {
      final currentLegIndex = route.legs.indexOf(currentLeg);
      final previousLegIndex = currentLegIndex - 1;
      if (previousLegIndex >= 0) {
        return route.legs[previousLegIndex].instructions.last;
      } else {
        return null;
      }
    }
  }

  NavigationInstruction? get nextInstruction {
    final currentLegInstructions = currentLeg.instructions;
    final currentInstructionIndex =
        currentLegInstructions.indexOf(currentInstruction);
    final nextInstructionIndex = currentInstructionIndex + 1;
    if (nextInstructionIndex < currentLegInstructions.length) {
      return currentLegInstructions[nextInstructionIndex];
    } else {
      final currentLegIndex = route.legs.indexOf(currentLeg);
      final nextLegIndex = currentLegIndex + 1;
      if (nextLegIndex < route.legs.length) {
        return route.legs[nextLegIndex].instructions.first;
      } else {
        return null;
      }
    }
  }
}

class NavigationRouteCubitStateError extends NavigationRouteCubitState {
  NavigationRouteCubitStateError({
    required this.error,
  });

  final String error;
}

NavigationInstruction createNavigationInstructionFromRoadInstruction(
  RoadInstruction instruction,
) {
  return LatLngInstruction(
    instruction: instruction.instruction,
    duration: Duration(seconds: instruction.duration.toInt()),
    distance: instruction.distance,
    location: instruction.location.toLatLng(),
  );
}
