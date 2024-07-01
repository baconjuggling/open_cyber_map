import 'package:cyber_map/core/domain/models/osm_object/osm_object.dart';

abstract class RoutePlannerState {}

class RoutePlannerInitial extends RoutePlannerState {}

class RoutePlannerLoading extends RoutePlannerState {}

class RoutePlannerLoaded extends RoutePlannerState {
  RoutePlannerLoaded({
    required this.waypoints,
    required this.isRoundTrip,
    required this.travelingSalesman,
  });
  final List<OSMObject> waypoints;
  final bool isRoundTrip;
  final bool travelingSalesman;
}
