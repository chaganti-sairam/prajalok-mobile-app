import 'dart:io';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class FileDownloader {
  RxDouble downloadProgress = 0.0.obs;
  RxString downloadMessage = "".obs;
  Rx<File> downloadedFile = File("").obs;

  Future<void> downloadFile({required String url, required String filename}) async {
    try {
      HttpClient client = HttpClient();
      List<int> downloadData = [];
      Directory downloadDirectory;

      if (Platform.isIOS) {
        downloadDirectory = await getApplicationDocumentsDirectory();
      } else {
        downloadDirectory = Directory('/storage/emulated/0/Download');
        if (!await downloadDirectory.exists()) {
          downloadDirectory = (await getExternalStorageDirectory())!;
        }
      }

      HttpClientRequest request = await client.getUrl(Uri.parse(url));
      HttpClientResponse response = await request.close();

      if (response.statusCode == 200) {
        String extension = _getExtensionFromUrl(url);
        String filePathName = "${downloadDirectory.path}/$filename$extension";
        File savedFile = File(filePathName);
        bool fileExists = await savedFile.exists();

        if (fileExists) {
          Get.snackbar("Info", "File already downloaded");
        } else {
          response.listen(
            (List<int> chunk) async {
              downloadData.addAll(chunk);
              double progress = downloadData.length / response.contentLength;
              downloadProgress.value = progress;
            },
            onDone: () async {
              await savedFile.writeAsBytes(downloadData);
              downloadedFile.value = savedFile;
              downloadMessage.value = "Download complete";
              downloadProgress.value = 0.0;
            },
          );
        }
      } else {
        downloadMessage.value = "Failed to download file. Status code: ${response.statusCode}";
      }
    } catch (error) {
      downloadMessage.value = "Some error occurred -> $error";
      downloadProgress.value = 0.0;
    }
  }

  String _getExtensionFromUrl(String url) {
    List<String> pathSegments = Uri.parse(url).pathSegments;
    if (pathSegments.isNotEmpty) {
      String lastSegment = pathSegments.last;
      int dotIndex = lastSegment.lastIndexOf('.');
      if (dotIndex != -1 && dotIndex < lastSegment.length - 1) {
        return lastSegment.substring(dotIndex);
      }
    }
    return '.dat';
  }
}
