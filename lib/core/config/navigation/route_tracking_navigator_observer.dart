import 'package:flutter/widgets.dart';

class RouteTrackingNavigatorObserver extends NavigatorObserver {
  List<Route<dynamic>> routeStack = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    routeStack.add(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    routeStack.remove(route);
  }
}
