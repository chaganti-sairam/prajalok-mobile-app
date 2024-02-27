import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:prajalok/app/utils/api_const.dart';
import 'package:http/http.dart' as http;

class Functions {
  Future<List<File>> pickFiles({bool allowMultiple = true}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: allowMultiple,
      type: FileType.any,
    );
    if (result != null) {
      return result.paths.map((path) => File(path!)).toList();
    } else {
      return []; // Return an empty list if no files were picked
    }
  }

  Future<File?> captureImage({
    ImageSource source = ImageSource.camera,
    String? newPath, // Optional path for renaming (if required)
  }) async {
    try {
      final picker = ImagePicker();
      final XFile? img = await picker.pickImage(source: source);
      if (img != null) {
        final file = File(img.path);
        if (newPath != null) {
          // Rename the file if a new path is provided
          final dir = path.dirname(img.path);
          final renamedPath = path.join(dir, newPath);
          await file.renameSync(renamedPath);
          return File(renamedPath);
        } else {
          return file;
        }
      } else {
        return null; // Handle case where no image is selected
      }
    } catch (e) {
      print(e); // Log or handle the error appropriately
      return null;
    }
  }

  Future<dynamic> sendGcsFile(String filePath) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(ApiConst.gcsFileuploadUrl));
      request.fields.addAll({
        'bucket_name': 'ld_user_bucket',
        'gcs_folder_path': "$uuid/doc_analyser",
        'make_public': 'true',
      });
      request.files.add(await http.MultipartFile.fromPath('file_upload', filePath));
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(await response.stream.bytesToString());
        return decodedResponse; // Return parsed response data
      } else {
        if (kDebugMode) {
          print('File upload failed with status code: ${response.statusCode}');
        }
        return null; // Indicate an error occurred
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error encountered during file upload: $e');
      }
      return null; // Indicate an error occurred
    }
  }
}
