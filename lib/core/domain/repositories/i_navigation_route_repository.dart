import 'dart:async';

import 'package:cyber_map/core/domain/models/navigation_route/navigation_route.dart';
import 'package:latlong2/latlong.dart';

abstract class INavigationRouteRepository {
  Future<NavigationRoute> getRoute({
    required List<LatLng> selectedLocations,
    required bool roundTrip,
    required bool travelingSalesman,
  });
}
