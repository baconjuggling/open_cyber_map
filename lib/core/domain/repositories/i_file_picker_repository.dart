import 'dart:async';
import 'dart:io';

abstract class IFilePickerRepository {
  Future<File?> pickFile();
}
