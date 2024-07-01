import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfiguration {
  static String overpassHost = dotenv.get('OVERPASS_HOST');
  static String overpassPath = dotenv.get('OVERPASS_PATH');
  static String osrmHost = dotenv.get('OSRM_HOST');
}
