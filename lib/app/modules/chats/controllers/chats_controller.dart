import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:prajalok/app/data/serlization/normal_chat/message.dart';
import 'package:prajalok/app/utils/api_const.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:prajalok/app/utils/customeSnackbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/serlization/normal_chat/chat_user_list_model.dart';
import '../views/chats_view.dart';
import 'package:path_provider/path_provider.dart';

class ChatsController extends GetxController {
  final messageModelsResult = <MessageModels>[].obs;
  final chatUserListList = <ChatUserListModel>[].obs;
  final isLoading = false.obs;
  final showCheckbox = false.obs;

  @override
  void onInit() {
    getUserConversations();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    isSelctedId.clear();
    super.onClose();
  }

  Rx<Color?> selectedColor = AppColors.searchLawAppBarColors.obs;
  List<Color> colorList = [
    const Color.fromARGB(255, 221, 221, 221),
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
  ];

  final pickedFileList = <File>[].obs;
  final Rx<File?> selectedFileList = Rx<File?>(null);
  final isSelctedId = <int>[].obs;
  final isvisible = false.obs;
  final selcetdDataShare = "".obs;

  void selectable(int id) {
    if (isSelctedId.contains(id)) {
      // If already selected, remove it
      isvisible.value = false;
      isSelctedId.remove(id);
    } else {
      isSelctedId.add(id);
    }
    isvisible.value = isSelctedId.isNotEmpty;
    print("Selected IDs: $isSelctedId");
    print("isvisible: ${isvisible.value}");
  }

//conversationId
  Future<dynamic> getUserConversations() async {
    return supabase
        .schema("network")
        .rpc("get_user_conversations_with_latest_messageses", params: {"user_id": uuid, "conv_limit": 20, "conv_offset": 0})
        .select()
        .then((value) {
          print('--result--9968 $value');
          chatUserListList.value = value.map((result) => ChatUserListModel.fromJson(result)).toList();
          return value;
        })
        .onError((error, stackTrace) {
          print('--error--9968 $error');
          return [];
        });
  }

  void handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );
    if (result != null && result.files.isNotEmpty) {
      pickedFileList.addAll(result.files.map((e) => File(e.path!)));
      Get.back();
      Get.bottomSheet(
        HandlePreviewBottomSheet(),
      );
    }
  }

  String fileSize(File? file) {
    if (file != null) {
      int fileSizeInBytes = file.lengthSync();
      double fileSizeInMB = fileSizeInBytes / 1024;
      return fileSizeInMB.toStringAsFixed(2);
    } else {
      return "0.00";
    }
  }

  String fileSize1(File? file) {
    if (file != null) {
      int fileSizeInBytes = file.lengthSync();
      double fileSizeInMB = fileSizeInBytes / 1024;
      return fileSizeInMB.toStringAsFixed(2);
    } else {
      return "0.00";
    }
  }

  // void handleCameraPicker() async {
  //   final result = await ImagePicker().(
  //     imageQuality: 70,
  //     maxWidth: 1440,
  //     source: ImageSource.gallery,
  //   );
  //   if (result != null && result.path.isNotEmpty) {
  //     File imageFile = File(result.path);
  //     pickedFileList.add(imageFile);
  //     Get.back();
  //     Get.bottomSheet(
  //       HandlePreviewBottomSheet(),
  //     );
  //   }
  // }

  void handleImageSelection() async {
    final results = await ImagePicker().pickMultiImage(
      imageQuality: 70,
      maxWidth: 1440,
    );
    if (results != null && results.isNotEmpty) {
      List<File> imageFiles = results.map((result) => File(result.path)).toList();
      pickedFileList.addAll(imageFiles);
      Get.back();
      Get.bottomSheet(
        isScrollControlled: true,
        HandlePreviewBottomSheet(),
      );
    }
  }

  final uploadedUrl = <String>[].obs;

  Future<bool?> uploadFiles(List<File> files) async {
    try {
      for (var i = 0; i < files.length; i++) {
        var file = files[i];
        var request = http.MultipartRequest('POST', Uri.parse(ApiConst.gcsFileuploadUrl));
        request.fields.addAll({'bucket_name': 'ld_user_bucket', 'gcs_folder_path': '$uuid/chat', 'make_public': 'true'});
        var multipartFile = await http.MultipartFile.fromPath('file_upload', file.path);
        request.files.add(multipartFile);
        // Send the HTTP request for each file sequentially
        http.StreamedResponse response = await request.send();
        if (response.statusCode == 200) {
          var decodedResponse = await response.stream.bytesToString();
          var responseData = jsonDecode(decodedResponse);
          var publicUrl = responseData["public_url"];
          // Store the public URL in the list
          uploadedUrl.add(publicUrl);
          if (kDebugMode) {
            print("Uploaded successfullyPublic URL: $publicUrl");
          }
          submitMessage(true);
        } else {
          if (kDebugMode) {
            print("Upload failed with status code: ${response.statusCode}");
            print("Reason: ${response.reasonPhrase}");
          }
          return false;
        }
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Exception during file upload: $e");
      }
      return false;
    }
  }

  Future<bool?> deleteSlectedMessage() async {
    for (int i = 0; i < isSelctedId.length; i++) {
      await supabase
          .schema("network")
          .from("messages")
          .delete()
          .match({'id': isSelctedId[i]})
          .select()
          .then((value) {
            isSelctedId.clear();
            Get.snackbar("Deleted", "Message deleted successfully");
            if (kDebugMode) {
              print("valuSuccesDeleteReslt $value");
            }
            return true;
          })
          .onError((error, stackTrace) {
            if (kDebugMode) {
              print("erroror $stackTrace  $error");
            }
            return false;
          });
    }
    return null;
  }

  final textMessageController = TextEditingController().obs;
  final conversationId = 0.obs;
  final recipientId = "".obs;
  final responseList = [].obs;

  Future<void> submitMessage(bool isImage) async {
    if (!isImage) {
      return;
    }
    try {
      for (var i = 0; i < uploadedUrl.length; i++) {
        await supabase
            .schema(ApiConst.networkShema)
            .from('messages')
            .insert({
              "conversation_id": conversationId.value,
              'sender_id': uuid,
              'recipient_id': recipientId.value,
              "content_data": uploadedUrl[i],
              "content_type": "image",
              "file_size": fileSize1(pickedFileList[i]),
              "file_name": pickedFileList[i].path.split('/').last,
            })
            .select()
            .then((value) {
              if (kDebugMode) {
                print("valuSuccesReslt $value");
              }
              responseList.add(value);
            });
      }
      if (responseList.length == uploadedUrl.length) {
        uploadedUrl.clear();
      }
    } on PostgrestException catch (error) {
      CustomSnackBar.showCustomErrorToast(message: error.message);
    } catch (_) {
      CustomSnackBar.showCustomErrorToast(message: "unexpectedErrorMessage");
    }
  }

  void submittxtMessage() async {
    final text = textMessageController.value.text;
    if (text.isEmpty) {
      return;
    }
    textMessageController.value.clear();
    try {
      await supabase.schema(ApiConst.networkShema).from('messages').insert({
        "conversation_id": conversationId.value,
        'sender_id': uuid,
        'recipient_id': recipientId.value,
        "content_data": text,
        "content_type": "text",
      });
    } on PostgrestException catch (error) {
      CustomSnackBar.showCustomErrorToast(message: error.message);
    } catch (_) {
      CustomSnackBar.showCustomErrorToast(message: "unexpectedErrorMessage");
    }
  }

  final isHovered = false.obs;
  void handleHover(bool hover) {
    isHovered.value = hover;
  }

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
        if (!await downloadDirectory.exists()) downloadDirectory = (await getExternalStorageDirectory())!;
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
          int totalBytes = response.contentLength;
          int receivedBytes = 0;
          response.listen(
            (List<int> chunk) async {
              downloadData.addAll(chunk);
              receivedBytes += chunk.length;
              double progress = receivedBytes / totalBytes;
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
