import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cyber_map/core/config/theme/map_theme_data.dart';
import 'package:cyber_map/core/domain/repositories/i_theme_data_repository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

class JsonThemeDataRepository implements IThemeDataRepository {
  @override
  Map<String, dynamic> getDefaultThemeData() {
    log('Returning default theme data', name: 'ThemeDataRepository');
    return Map<String, dynamic>.from(defaultThemeData);
  }

  @override
  Future<Map<String, dynamic>> loadThemeData() async {
    log('Loading theme data', name: 'ThemeDataRepository');
    final String? path =
        await getApplicationDocumentsDirectory().then((value) => value.path);
    if (path != null) {
      final File file = File('$path/themeData.json');
      if (await file.exists()) {
        log('File exists, reading contents', name: 'ThemeDataRepository');
        final String contents = await file.readAsString();
        return json.decode(contents) as Map<String, dynamic>;
      }
    }
    log('Returning default theme data', name: 'ThemeDataRepository');
    return Map<String, dynamic>.from(defaultThemeData);
  }

  @override
  Future<void> saveThemeData(Map<String, dynamic> themeDataToSave) async {
    log('Saving theme data', name: 'ThemeDataRepository');
    final String? path =
        await getApplicationDocumentsDirectory().then((value) => value.path);
    if (path != null) {
      final File file = File('$path/themeData.json');
      await file.writeAsString(json.encode(themeDataToSave));
      log('Theme data saved', name: 'ThemeDataRepository');
    }
  }

  @override
  Future<void> exportThemeData(Map<String, dynamic> themeDataToExport) async {
    final bytes = utf8.encode(json.encode(themeDataToExport));
    final path = await FilePicker.platform.saveFile(
      allowedExtensions: ['json'],
      fileName: 'themeData.json',
      bytes: bytes,
      type: FileType.custom,
    );

    if (Platform.isMacOS || Platform.isLinux || Platform.isWindows) {
      if (path != null) {
        final file = File(path);
        await file.writeAsBytes(bytes);
      }
    }
  }

  @override
  Future<Map<String, dynamic>> importThemeData() async {
    log('Importing theme data', name: 'ThemeDataRepository');
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result != null) {
      final File file = File(result.files.single.path!);
      final String contents = await file.readAsString();
      log('Theme data imported', name: 'ThemeDataRepository');
      return json.decode(contents) as Map<String, dynamic>;
    } else {
      log('Returning default theme data', name: 'ThemeDataRepository');
      return Map<String, dynamic>.from(defaultThemeData);
    }
  }
}
