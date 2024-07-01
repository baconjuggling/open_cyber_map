abstract class IKeyValueRepository {
  Future<void> saveKeyValue(String key, String value);
  Future<String?> loadKeyValue(String key);
  Future<List<String>> getAllKeys();
  Future<void> deleteKeyValue(String key);
}
