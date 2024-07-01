import 'package:cyber_map/core/domain/models/navigation_route_leg/navigation_route_leg.dart';
import 'package:latlong2/latlong.dart';

class NavigationRoute {
  NavigationRoute({required this.legs});

  final List<NavigationRouteLeg> legs;

  List<LatLng> get polyline {
    return legs.fold(
      [],
      (previousValue, element) => [...previousValue, ...element.polyline],
    );
  }

  Duration get totalDuration {
    return legs.fold(
      Duration.zero,
      (previousValue, element) => previousValue + element.totalDuration,
    );
  }

  double get totalDistance {
    return legs.fold(
      0,
      (previousValue, element) => previousValue + element.totalDistance,
    );
  }

  String get totalDistanceString {
    return totalDistance.toStringAsFixed(2);
  }

  String get totalDurationString {
    return totalDuration.toString();
  }
}
