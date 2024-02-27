import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:prajalok/app/data/serlization/doc_talk_sessionModel.dart';
import 'package:prajalok/app/data/serlization/message_model.dart';
import 'package:prajalok/app/data/serlization/newCheckFileModel.dart';
import 'package:prajalok/app/utils/customeSnackbar.dart';
import 'package:prajalok/app/utils/customer_loading.dart';
import 'package:prajalok/app/utils/icons_const.dart';
import 'package:prajalok/app/utils/re_usable_class.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../utils/api_const.dart';
import '../views/docChat_chat.dart';
import '../views/document_referances.dart';
import '../views/subscription_plans.dart';
import 'dart:developer' as dev;

class DocumentChatController extends GetxController {
  final loaclfilePath = "".obs;
  final files = <File>[].obs;
  final isLoading = false.obs;
  final selectedIndex = 0.obs;
  final docChatModuleId = 5.obs;
  final uuid = supabase.auth.currentUser?.id;
  final RxInt sessionId = 0.obs;
  var isDialogVisible = false.obs;
  final Rx<FocusNode> myFocusNode = FocusNode().obs;
  final RxString paths = "".obs;
  final RxString publicUrl = "".obs;
  final RxList uploadedUrl = [].obs;
  final boxdocChatGenerationid = GetStorage();
  int? readId() {
    int? userId = boxdocChatGenerationid.read('id');
    if (userId != null) {
      if (kDebugMode) {
        print('The stored ID is: $userId');
      }
    } else {
      if (kDebugMode) {
        print('No ID is stored');
      }
    }
    return userId;
  }

  final Rx<FileCheckModel> docChatfileCheckModel = FileCheckModel().obs;
  final fileCheckResults = <FileCheckModel>[].obs;

  Future<bool?> checkFile() async {
    isLoading.value = true;
    try {
      for (var i = 0; i < files.length; i++) {
        var request = http.MultipartRequest('POST', Uri.parse(ApiConst.lawyerDeskCheckFile));
        paths.value = files[i].path;
        request.files.add(await http.MultipartFile.fromPath('file', files[i].path.toString()));
        http.StreamedResponse response = await request.send();
        if (response.statusCode == 200) {
          String responseBody = await response.stream.bytesToString();
          var decodedResponse = jsonDecode(responseBody);
          dev.log("sssssssssssss ${decodedResponse.toString()}");
          docChatfileCheckModel.value = FileCheckModel.fromJson(decodedResponse);
          fileCheckResults.add(docChatfileCheckModel.value);
        } else {
          if (kDebugMode) {
            print('Request failed with status: ${response.statusCode}');
          }
          isLoading.value = false;
          return false;
        }
      }
      isLoading.value = false;
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      isLoading.value = false;
      return false;
    }
  }

  void filepickerDocChat() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );
    if (result != null) {
      files.addAll(result.paths.map((path) => File(path!)).toList());
      Get.back();
    } else {
      return null;
    }
  }

  File? imgFile;
  void takeSnapshot() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? img = await picker.pickImage(
        source: ImageSource.camera,
      );
      if (img != null) {
        Get.back();
        imgFile = File(img.path);
        files.addAll([imgFile as File]);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  final contextController = TextEditingController().obs;
  Future<bool?> sendDocTalkSession() async {
    try {
      final result = await supabase.schema(ApiConst.doctalkShema).from("sessions").insert({
        "context": contextController.value.text.toString(),
        "vector_db_collection_name": "doc_talk_vector_db",
        "profile_id": uuid,
        "case_doc_urls": uploadedUrl
      }).select();
      sessionId.value = result[0]["id"];
      boxdocChatGenerationid.write('id', result[0]["id"]);
      if (kDebugMode) {
        print('ResponseBody: ${result[0]["id"]}');
      }
      return true;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("stackTrace $e, $stackTrace");
      }
    }
    return false;
  }

  Future<bool?> getCredit() async {
    try {
      final res = await supabase.schema("billing").rpc("has_sufficient_credits", params: {
        'p_module_id': docChatModuleId.value.toInt(),
        'p_credits_required': 1,
        'p_profile_id': uuid,
      });
      if (kDebugMode) {
        print("available_credits $res");
      }
      if (res["has_sufficient_credits"] == true) {
        Get.back();
        GetCreditCustomDialog.showConfirmationDialog(
          subtitle: "Credit Usage Confirmation!",
          message: "Specified number of credits will be deducted from your account.",
          buttonText: "Continue",
          context: Get.context!,
          onPressed: () async {
            Get.back();
            deductCredits(
              moduleId: docChatModuleId.value.toInt(),
            );
            Get.dialog(const ReusableProcessingDialog());
            final res = await uploadFiles(files, uuid.toString());
            if (res != null) {
              var response = await sendDocTalkSession();
              if (response != null) {
                Get.back();
                Future.delayed(Duration.zero, () {
                  supabase.schema(ApiConst.doctalkShema).from("sessions").stream(primaryKey: ["id"]).eq('id', sessionId.value).listen((data) {
                        if (data[0]['task_id'] != null) {
                          if (kDebugMode) {
                            print("amreshhhhrrrrr ${data[0]['task_id']}");
                          }
                          final taskId = data[0]['task_id'];
                          webSocketFirstConnect(taskId);
                        }
                      });
                });
              } else {
                return Get.dialog(const ReusableProcessingDialog());
              }
            }
          },
          res: res["available_credits"],
        );
      } else {
        GetCreditCustomDialog.showConfirmationDialog(
          subtitle: "Insufficient Credits !",
          message: "Looks like you've run out of credits. Buy more to continue accessing this feature",
          buttonText: "Buy credits",
          context: Get.context!,
          onPressed: () {
            Get.to(const SubScriptionPlan());
          },
          res: res["available_credits"],
        );
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }

  Future<dynamic> deductCredits({required int moduleId}) async {
    return supabase
        .schema("billing")
        .rpc("deduct_user_credits", params: {"p_module_id": moduleId, "p_credits_to_deduct": 1, 'p_profile_id': uuid}).then((value) {
      if (kDebugMode) {
        print(value);
      }
      return value;
    }).onError((error, stackTrace) {
      return {};
    });
  }

  Future<bool?> uploadFiles(List<File> files, String uuid) async {
    try {
      for (var i = 0; i < files.length; i++) {
        var file = files[i];
        var request = http.MultipartRequest('POST', Uri.parse(ApiConst.gcsFileuploadUrl));
        request.fields.addAll({'bucket_name': 'ld_user_bucket', 'gcs_folder_path': '$uuid/doc_talk', 'make_public': 'true'});
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
        } else {
          if (kDebugMode) {
            print("Upload failed with status code: ${response.statusCode}");
            print("Reason: ${response.reasonPhrase}");
          }
          // If any file upload fails, return false immediately
          return false;
        }
      }
      // All files uploaded successfully, return true
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Exception during file upload: $e");
      }
      return false;
    }
  }

  bool isDialogOpen = false;
  Map<String, dynamic> webSocketIntialResponse = {};
  void webSocketFirstConnect(taskid) {
    final wsUrl = Uri.parse("ws://redis-manager-yxfpjr3pvq-el.a.run.app/ws/$taskid");
    var channel = WebSocketChannel.connect(wsUrl);
    channel.stream.listen((message) {
      final data = jsonDecode(message);
      webSocketIntialResponse = data;
      if (data["overall_status"] == true) {
        Get.off(() => DocReferanceChat());
        files.clear();
      } else {
        if (!isDialogOpen) {
          isDialogOpen = true;
          showResponseWebSoketDialog(Get.context!, "Doc Chat!", webSocketIntialResponse);
        }
      }
      channel.sink.add('received!');
      if (kDebugMode) {
        print("webSocketMessage $message");
      }
    });
  }

  // void closeFirstDialog() {
  //   if (isDialogVisible.value) {
  //     Get.back();
  //     isDialogVisible.toggle();
  //   }
  // }

  @override
  void onInit() {
    myFocusNode.value = FocusNode();
    msgtxtController.value = TextEditingController();
    super.onInit();
    fileCheckResults.clear();
    pageController = PageController(initialPage: currentIndex.value);
  }

  void requestFocus(context) {
    FocusScope.of(context).requestFocus(myFocusNode.value);
  }

  @override
  void onReady() {
    super.onReady();
  }

  RxBool isExpanded = false.obs;
  void expansionchnage(value) {
    isExpanded.value = !isExpanded.value;
  }

// document chat for referencePage

  final Rx<String> selectedOptions = ''.obs;
  void onChange(value) {
    selectedOptions.value = value;
  }

  Future<bool?> supabseInsertUserRole() async {
    isLoading.value = true;
    try {
      await supabase
          .schema(ApiConst.doctalkShema)
          .from('sessions')
          .update({
            'user_role': selectedOptions.value,
          })
          .eq("id", sessionId.value)
          .select()
          .then((value) => print("supabaseInsertUserRole $value"));
      isLoading.value = false;
      return true;
    } on PostgrestException catch (error) {
      CustomSnackBar.showCustomErrorToast(message: error.message);
    } catch (_) {
      CustomSnackBar.showCustomErrorToast(message: "unexpectedErrorMessage");
    }
    isLoading.value = false;
    return false;
  }

  final RxList<String> listOfIcons = [SvgIcons.dochatchoose, SvgIcons.uploadIconContainer, SvgIcons.docChatcontainer].obs;
  final RxList<String> listOfTitles = ["Choose", "Upload", "Chat"].obs;
  final RxInt currentIndex = 0.obs;
  void changeSateFunc(indexx) {
    currentIndex.value = indexx;
  }

  late PageController pageController;
  void moveToStepersPage() {
    pageController = PageController(initialPage: currentIndex.value);
    Get.to(() => DocReferanceChat());
  }

  void moveToStepersPage1() {
    changeSateFunc(currentIndex.value + 1);
    pageController.animateToPage(
      currentIndex.value,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  Future<bool?> postReferences() async {
    try {
      final response = await http.post(
        Uri.parse(ApiConst.getReferencesUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'id': sessionId.value, "limit": null}),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (kDebugMode) {
          print("responseBody  $responseData");
        }
        return true;
      } else {
        throw Exception('Failed to post data');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Map<String, dynamic> webSocketReferencesResponse = {};

  void webSocketReferences(taskid1) {
    final wsUrl = Uri.parse("ws://redis-manager-yxfpjr3pvq-el.a.run.app/ws/$taskid1");
    var channel = WebSocketChannel.connect(wsUrl);
    channel.stream.listen((message) {
      final data = jsonDecode(message);
      webSocketReferencesResponse = data;
      if (data["overall_status"] == true) {
        fetchdocTalkSession();
        isDialogOpen = false;
      } else {
        if (!isDialogOpen) {
          isDialogOpen = true;
          showResponseWebSoketDialog(Get.context!, "DocTalk References!", webSocketReferencesResponse);
        }
      }
      channel.sink.add('received!');
      if (kDebugMode) {
        print("webSocketMessage $message");
      }
    });
  }

  final docTalkSessionModel = <DocTalkSessionModel>[].obs;
  final List listData = [];
  void fetchdocTalkSession() async {
    try {
      final sessionRes = await supabase.schema(ApiConst.doctalkShema).from("sessions").select().eq("id", sessionId.value);
      docTalkSessionModel.value = sessionRes.map((e) => DocTalkSessionModel.fromJson(e)).toList(growable: false);
      listData.addAll((docTalkSessionModel.first.recommendedDocUrls ?? []));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

// get chat ready----------------
  Future<bool?> postchatReady() async {
    try {
      final response = await http.post(
        Uri.parse(ApiConst.chatReady),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id': sessionId.value,
        }),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (kDebugMode) {
          print("responseBody  $responseData");
        }
        return true;
      } else {
        throw Exception('Failed to post data');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Map<String, dynamic> webSocketgetChatReadyResponse = {};

  void webSocketgetChatReady(taskid2) {
    final wsUrl = Uri.parse("ws://redis-manager-yxfpjr3pvq-el.a.run.app/ws/$taskid2");
    var channel = WebSocketChannel.connect(wsUrl);
    channel.stream.listen((message) {
      final data = jsonDecode(message);
      webSocketReferencesResponse = data;
      if (data["overall_status"] == true) {
        Get.off(() => DocChat());
        // Get.to(() => DocChat());
        isDialogOpen = false;
        fetchdocTalkSession();
      } else {
        if (!isDialogOpen) {
          isDialogOpen = true;
          showResponseWebSoketDialog(Get.context!, "DocTalk Chat Ready!", webSocketgetChatReadyResponse);
        }
      }
      channel.sink.add('received!');
      if (kDebugMode) {
        print("webSocketMessage $message");
      }
    });
  }

//   during chat functionality
  final msgtxtController = TextEditingController().obs;

  Future<void> submitMessage() async {
    isLoading.value = true;
    final text = msgtxtController.value.text;
    if (text.isEmpty) {
      return;
    }
    msgtxtController.value.clear();
    try {
      await supabase.schema(ApiConst.doctalkShema).from('messages').insert({
        'session_id': sessionId.value,
        'message_type': "text",
        'content': text,
        'chat_user_type': "user",
      }).then((value) {
        isLoading.value = false;
      });
    } on PostgrestException catch (error) {
      CustomSnackBar.showCustomErrorToast(message: error.message);
    } catch (_) {
      CustomSnackBar.showCustomErrorToast(message: "unexpectedErrorMessage");
    }
  }

  final messageresponseModel = <MessageModel>[].obs;

  @override
  void onClose() {
    myFocusNode.value.dispose();
    msgtxtController.value.dispose();

    clear();
    super.onClose();
  }

  void closeDialog() {
    if (isDialogVisible.value) {
      Get.back();
      isDialogVisible.toggle();
    }
  }

  void clear() {
    docChatfileCheckModel.value.isAgreement = null;
    docChatfileCheckModel.value.isLegal = null;
    docChatfileCheckModel.value.isEnglish = null;
    docChatfileCheckModel.value.isPageLimit = null;
    docChatfileCheckModel.value.isReadable = null;
  }
}
