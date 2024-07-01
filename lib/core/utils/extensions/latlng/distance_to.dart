import 'dart:math';

import 'package:latlong2/latlong.dart';

extension DistanceTo on LatLng {
  double distanceTo(LatLng other) {
    const p = 0.017453292519943295;
    const c = cos;
    final a = 0.5 -
        c((other.latitude - latitude) * p) / 2 +
        c(latitude * p) *
            c(other.latitude * p) *
            (1 - c((other.longitude - longitude) * p)) /
            2;
    return 12742 * asin(sqrt(a));
  }
}
