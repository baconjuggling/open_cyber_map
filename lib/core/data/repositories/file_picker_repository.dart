import 'dart:async';
import 'dart:io';

import 'package:cyber_map/core/domain/repositories/i_file_picker_repository.dart';
import 'package:file_picker/file_picker.dart';

class FilePickerRepository implements IFilePickerRepository {
  @override
  Future<File?> pickFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      return File(result.files.single.path!);
    } else {
      return null;
    }
  }
}
