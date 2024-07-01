import 'package:cyber_map/core/config/injectable/injection.dart';
import 'package:cyber_map/core/data/repositories/navigation_route_repository.dart';
import 'package:cyber_map/core/domain/cubits/navigation/navigation_route_cubit_state.dart';
import 'package:cyber_map/core/domain/cubits/user_position/user_position_cubit.dart';
import 'package:cyber_map/core/domain/cubits/user_position/user_position_state.dart';
import 'package:cyber_map/core/utils/extensions/latlng/distance_to.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';

@singleton
@injectable
class NavigationRouteCubit extends Cubit<NavigationRouteCubitState> {
  NavigationRouteCubit({required this.userPositionCubit})
      : super(NavigationRouteCubitStateInitial());
  NavigationRouteRepository repository = NavigationRouteRepository();
  UserPositionCubit userPositionCubit = getIt<UserPositionCubit>();

  bool isWithin10M(LatLng userPosition, LatLng instructionPosition) {
    return userPosition.distanceTo(instructionPosition) * 1000 < 10;
  }

  void previousInstruction() {
    final state = this.state;
    if (state is NavigationRouteCubitStateLoaded) {
      final currentLeg = state.currentLeg;
      final currentInstruction = state.currentInstruction;
      final currentLegInstructions = currentLeg.instructions;
      final currentInstructionIndex =
          currentLegInstructions.indexOf(currentInstruction);
      final previousInstructionIndex = currentInstructionIndex - 1;
      if (previousInstructionIndex >= 0) {
        emit(
          NavigationRouteCubitStateLoaded(
            route: state.route,
            currentLeg: currentLeg,
            currentInstruction:
                currentLegInstructions[previousInstructionIndex],
          ),
        );
      } else {
        final currentLegIndex = state.route.legs.indexOf(currentLeg);
        final previousLegIndex = currentLegIndex - 1;
        if (previousLegIndex >= 0) {
          final previousLeg = state.route.legs[previousLegIndex];
          final previousLegInstructions = previousLeg.instructions;

          emit(
            NavigationRouteCubitStateLoaded(
              route: state.route,
              currentLeg: previousLeg,
              currentInstruction: previousLegInstructions.last,
            ),
          );
        } else {
          emit(NavigationRouteCubitStateInitial());
        }
      }
    }
  }

  void nextInstruction() {
    final state = this.state;
    if (state is NavigationRouteCubitStateLoaded) {
      final currentLeg = state.currentLeg;
      final currentInstruction = state.currentInstruction;
      final currentLegInstructions = currentLeg.instructions;
      final currentInstructionIndex =
          currentLegInstructions.indexOf(currentInstruction);
      final nextInstructionIndex = currentInstructionIndex + 1;
      if (nextInstructionIndex < currentLegInstructions.length) {
        emit(
          NavigationRouteCubitStateLoaded(
            route: state.route,
            currentLeg: currentLeg,
            currentInstruction: currentLegInstructions[nextInstructionIndex],
          ),
        );
      } else {
        final currentLegIndex = state.route.legs.indexOf(currentLeg);
        final nextLegIndex = currentLegIndex + 1;
        if (nextLegIndex < state.route.legs.length) {
          emit(
            NavigationRouteCubitStateLoaded(
              route: state.route,
              currentLeg: state.route.legs[nextLegIndex],
              currentInstruction:
                  state.route.legs[nextLegIndex].instructions.first,
            ),
          );
        } else {
          emit(NavigationRouteCubitStateInitial());
        }
      }
    }
  }

  void getRoute({
    required List<LatLng> selectedLocations,
    required bool roundTrip,
    required bool travelingSalesman,
  }) {
    emit(NavigationRouteCubitStateInitial());
    final userPositionState = userPositionCubit.state;
    if (userPositionState is UserPositionLoaded) {
      repository.getRoute(
        selectedLocations: [
          ...selectedLocations,
        ],
        roundTrip: roundTrip,
        travelingSalesman: travelingSalesman,
      ).then((route) {
        emit(
          NavigationRouteCubitStateLoaded(
            route: route,
            currentLeg: route.legs.first,
            currentInstruction: route.legs.first.instructions.first,
          ),
        );
      }).catchError((error) {
        emit(NavigationRouteCubitStateError(error: error.toString()));
      });
    }
  }

  void clearRoute() {
    emit(NavigationRouteCubitStateInitial());
  }
}
