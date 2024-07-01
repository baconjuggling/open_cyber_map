import 'package:cyber_map/core/domain/cubits/route_planner/route_planner_state.dart';
import 'package:cyber_map/core/domain/models/osm_object/osm_object.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@singleton
@injectable
class RoutePlannerCubit extends Cubit<RoutePlannerState> {
  RoutePlannerCubit() : super(RoutePlannerInitial());
  void clearWaypoints() {
    if (state is RoutePlannerLoaded) {
      emit(
        RoutePlannerLoaded(
          waypoints: [],
          isRoundTrip: (state as RoutePlannerLoaded).isRoundTrip,
          travelingSalesman: (state as RoutePlannerLoaded).travelingSalesman,
        ),
      );
    }
  }

  void toggleRoundTrip() {
    if (state is RoutePlannerLoaded) {
      emit(
        RoutePlannerLoaded(
          waypoints: (state as RoutePlannerLoaded).waypoints,
          isRoundTrip: !(state as RoutePlannerLoaded).isRoundTrip,
          travelingSalesman: (state as RoutePlannerLoaded).travelingSalesman,
        ),
      );
    }
  }

  void toggleTravelingSalesman() {
    if (state is RoutePlannerLoaded) {
      emit(
        RoutePlannerLoaded(
          waypoints: (state as RoutePlannerLoaded).waypoints,
          isRoundTrip: (state as RoutePlannerLoaded).isRoundTrip,
          travelingSalesman: !(state as RoutePlannerLoaded).travelingSalesman,
        ),
      );
    }
  }

  void reorderWaypoints(int oldIndex, int newIndex) {
    if (state is RoutePlannerLoaded) {
      final List<OSMObject> oldWaypoints =
          (state as RoutePlannerLoaded).waypoints;

      int adjustedNewIndex = newIndex;

      if (oldIndex < 0 ||
          oldIndex >= oldWaypoints.length ||
          adjustedNewIndex < 0 ||
          adjustedNewIndex > oldWaypoints.length) {
        return;
      }

      final List<OSMObject> newWaypoints = List<OSMObject>.from(oldWaypoints);
      final OSMObject object = newWaypoints.removeAt(oldIndex);

      if (adjustedNewIndex > oldIndex) {
        adjustedNewIndex -= 1;
      }

      if (adjustedNewIndex >= newWaypoints.length) {
        adjustedNewIndex = newWaypoints.length;
      }

      newWaypoints.insert(adjustedNewIndex, object);

      emit(
        RoutePlannerLoaded(
          travelingSalesman: (state as RoutePlannerLoaded).travelingSalesman,
          waypoints: newWaypoints,
          isRoundTrip: (state as RoutePlannerLoaded).isRoundTrip,
        ),
      );
    }
  }

  void removeWaypoint(OSMObject object) {
    if (state is RoutePlannerLoaded) {
      final List<OSMObject> newWaypoints =
          (state as RoutePlannerLoaded).waypoints;

      newWaypoints.remove(object);

      emit(
        RoutePlannerLoaded(
          waypoints: newWaypoints,
          isRoundTrip: (state as RoutePlannerLoaded).isRoundTrip,
          travelingSalesman: (state as RoutePlannerLoaded).travelingSalesman,
        ),
      );
    }
  }

  void addWaypoint(OSMObject object) {
    if (state is RoutePlannerInitial) {
      emit(
        RoutePlannerLoaded(
          waypoints: [object],
          isRoundTrip: false,
          travelingSalesman: false,
        ),
      );
    } else if (state is RoutePlannerLoaded) {
      final List<OSMObject> newWaypoints =
          (state as RoutePlannerLoaded).waypoints;

      newWaypoints.add(object);

      emit(
        RoutePlannerLoaded(
          waypoints: newWaypoints,
          isRoundTrip: (state as RoutePlannerLoaded).isRoundTrip,
          travelingSalesman: (state as RoutePlannerLoaded).travelingSalesman,
        ),
      );
    }
  }
}
