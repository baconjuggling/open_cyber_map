// ignore: avoid_classes_with_only_static_members
abstract class RouteUtil {
  static String formatRouteName(String route) {
    var routeName = route;

    routeName = routeName.trim();

    routeName = routeName.toLowerCase();

    routeName = routeName.replaceAll(RegExp(' +'), ' ');

    routeName = routeName.replaceAll(RegExp('[^a-z0-9 ]'), '_');

    routeName = routeName.replaceAll(' ', '_');

    routeName = routeName.replaceAll(RegExp('_+'), '_');

    routeName = routeName.replaceAll(RegExp('^_|_\$'), '');

    return routeName;
  }
}
