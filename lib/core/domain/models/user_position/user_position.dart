import 'package:latlong2/latlong.dart';

class UserPosition {
  UserPosition({
    required this.latitude,
    required this.longitude,
    required this.heading,
    required this.accuracy,
  });
  double latitude;
  double longitude;
  double heading;
  double accuracy;

  LatLng getLatLng() {
    return LatLng(latitude, longitude);
  }
}
