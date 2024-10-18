import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path_module;

class FileUtils {
  FileUtils._();

  static final _picker = ImagePicker();

  static Future<File?> pickImage(ImageSource source) async {
    try {
      XFile? xFile = await _picker.pickImage(source: source);
      if (xFile != null) {
        return File(xFile.path);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<File?> pickFile({String dialogTitle = 'Select Proof of Delivery file'}) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        allowedExtensions: ['jpeg', 'png', 'jpg', 'mp4'],
        type: FileType.custom,
        dialogTitle: dialogTitle,
      );

      if (result != null) {
        if (result.files.single.path != null) {
          return File(result.files.single.path!);
        }
      }
      return null;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}

extension FileEx on File {
  double get size {
    int sizeInBytes = lengthSync();
    double sizeInMb = sizeInBytes / (1024 * 1024);
    return sizeInMb;
  }

  String get name => path_module.basename(path).split('.').first;

  String get toBase64 {
    List<int> fileInByte = readAsBytesSync();
    String fileInBase64 = base64Encode(fileInByte);
    return fileInBase64;
  }

  bool get isVideo {
    return path.split('/').last.split('.').last == 'mp4';
  }
}
