abstract class IThemeDataRepository {
  Map<String, dynamic> getDefaultThemeData();
  Future<Map<String, dynamic>> loadThemeData();
  Future<void> saveThemeData(Map<String, dynamic> themeData);
  Future<void> exportThemeData(Map<String, dynamic> themeData);
  Future<void> importThemeData();
}
