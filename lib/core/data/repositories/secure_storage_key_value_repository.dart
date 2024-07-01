import 'dart:developer';

import 'package:cyber_map/core/domain/repositories/i_key_value_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IKeyValueRepository)
class SecureStorageKeyValueRepository implements IKeyValueRepository {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  Future<void> saveKeyValue(String key, String value) async {
    log(
      'Saving key value pair: $key',
      name: 'SecureStorageKeyValueRepository',
    );
    await _secureStorage.write(key: key, value: value);
    log(
      'Saved key value pair: $key ${value.length} characters',
      name: 'SecureStorageKeyValueRepository',
    );

    return;
  }

  @override
  Future<String?> loadKeyValue(String key) async {
    log(
      'Loading key value pair: $key',
      name: 'SecureStorageKeyValueRepository',
    );
    final String? value = await _secureStorage.read(key: key);
    log(
      'Loaded key value pair: $key ${value!.length} character',
      name: 'SecureStorageKeyValueRepository',
    );
    return value;
  }

  @override
  Future<List<String>> getAllKeys() async {
    return (await _secureStorage.readAll()).keys.toList();
  }

  @override
  Future<void> deleteKeyValue(String key) async {
    await _secureStorage.delete(key: key);
    return;
  }
}
