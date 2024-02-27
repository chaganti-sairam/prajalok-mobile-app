import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prajalok/app/data/serlization/leagalIssueModel.dart';
import 'package:prajalok/app/data/serlization/newCheckFileModel.dart';
import 'package:prajalok/app/modules/document_chat/views/subscription_plans.dart';
import 'package:prajalok/app/utils/api_const.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'dart:developer' as dev;
import 'package:prajalok/app/utils/customer_loading.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

import '../../../data/webSoketModel.dart/LeagalIssueWebSoketModel.dart';
import '../views/leagal_issue_spotter_result.dart';

class LegalIssueSpotterController extends GetxController {
  final Rx<FileCheckModel> filecheklegalIsuueSpoterModel = FileCheckModel().obs;

  final RxString loaclfilePath = "".obs;
  final isLoading = false.obs;
  final RxInt moduleId = 13.obs;
  final uuid = supabase.auth.currentUser?.id;
  final RxString publicUrl = "".obs;
  final RxInt queryId = 0.obs;
  var isDialogVisible = false.obs;
  final RxList pickedFile = [].obs;

  final inputdocUrl = "".obs;
  final leagalIssue = 0.obs;
  final totalSection = 0.obs;

  Future<bool?> checkFile() async {
    isLoading.value = true;
    var request = http.MultipartRequest('POST', Uri.parse(ApiConst.lawyerDeskCheckFile));
    request.files.add(await http.MultipartFile.fromPath(
      'file',
      loaclfilePath.value.toString(),
    ));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      var decodedResponse = jsonDecode(responseBody);
      filecheklegalIsuueSpoterModel.value = FileCheckModel.fromJson(decodedResponse);
      dev.log(decodedResponse.toString());
      isLoading.value = false;
      return true;
    } else {
      if (kDebugMode) {
        print('Request failed with status: ${response.statusCode}');
      }
      isLoading.value = false;
      return false;
    }
  }

  void clear() {
    filecheklegalIsuueSpoterModel.value.isAgreement = null;
    filecheklegalIsuueSpoterModel.value.isLegal = null;
    filecheklegalIsuueSpoterModel.value.isEnglish = null;
    filecheklegalIsuueSpoterModel.value.isPageLimit = null;
    filecheklegalIsuueSpoterModel.value.isReadable = null;
  }

  void docAnlysisfilepicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'png', "doc"],
    );
    if (result != null) {
      Get.back();
      final filePath = result.files.single.path;
      loaclfilePath.value = filePath.toString();
      pickedFile.add(filePath?.replaceAll("/data/user/0/com.example.prajalok/cache/file_picker/", ""));
      if (kDebugMode) {
        print("hhhhhhhhh $filePath");
      }
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
        String dir = path.dirname(img.path);
        String newPath = path.join(dir, 'prajalokCamera.jpg');
        loaclfilePath.value = newPath;
        imgFile?.renameSync(newPath);
        pickedFile.add(newPath);
      } else {
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<bool?> uploadFileLeagalIssueSpotter() async {
    var request = http.MultipartRequest('POST', Uri.parse(ApiConst.gcsFileuploadUrl));
    request.fields.addAll({'bucket_name': 'ld_user_bucket', 'gcs_folder_path': "$uuid/leagal_issue", 'make_public': 'true'});
    request.files.add(await http.MultipartFile.fromPath('file_upload', loaclfilePath.value.toString()));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var decodedResponse = jsonDecode(await response.stream.bytesToString());
      publicUrl.value = decodedResponse["public_url"];
      if (kDebugMode) {
        print("ggggggggg ${publicUrl.value}");
      }
      return true;
    } else {
      if (kDebugMode) {
        print(response.reasonPhrase);
      }
    }
    return false;
  }

  Future<bool?> sendleagalIssueSpotter() async {
    try {
      final result = await supabase.schema(ApiConst.analysisSchema).from("issue_spotter").insert({
        "profile_id": supabase.auth.currentUser!.id,
        "doc_urls": [publicUrl.value.toString()],
      }).select();
      queryId.value = result[0]["id"];
      if (kDebugMode) {
        print('ResponseBody: ${queryId.value}');
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
        'p_module_id': moduleId.value.toInt(),
        'p_credits_required': 1,
        'p_profile_id': uuid,
      });
      if (kDebugMode) {
        print("available_credits $res");
      }
      if (res["has_sufficient_credits"] == true) {
        GetCreditCustomDialog.showConfirmationDialog(
          subtitle: "Credit Usage Confirmation!",
          message: "Specified number of credits will be deducted from your account.",
          buttonText: "Continue",
          context: Get.context!,
          onPressed: () async {
            Get.back();
            deductCredits(
              moduleId: moduleId.value.toInt(),
            );
            final res = await uploadFileLeagalIssueSpotter();
            if (res != null) {
              final response = await sendleagalIssueSpotter();
              if (response != null) {
                supabase.schema(ApiConst.analysisSchema).from("issue_spotter").stream(primaryKey: ["id"]).eq('id', queryId.value).listen((data) {
                      if (data[0]['task_id'] != null) {
                        Get.back();
                        webSocketConnect(data[0]['task_id']);
                        if (kDebugMode) {
                          print("TaskIDDDD  ${data[0]['task_id'].toString()}");
                        }
                      } else {
                        Get.dialog(const ReusableProcessingDialog());
                      }
                    });
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
        print("deductcreadit $value");
      }
      return value;
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
      return error;
    });
  }

  @override
  void onInit() {
    filecheklegalIsuueSpoterModel.update((val) {
      filecheklegalIsuueSpoterModel.value = val!;
    });
    super.onInit();
    fetchContractAnalysisData();

    pageController = PageController(initialPage: currentIndex.value);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Rx<LeagalIssueWebSoketModel?> leagalIssueWebSoketModel = Rx<LeagalIssueWebSoketModel?>(null);

  void webSocketConnect(taskid) {
    final wsUrl = Uri.parse("ws://redis-manager-yxfpjr3pvq-el.a.run.app/ws/$taskid");
    var channel = WebSocketChannel.connect(wsUrl);
    channel.stream.listen((message) {
      final data = jsonDecode(message);
      leagalIssueWebSoketModel.value = LeagalIssueWebSoketModel.fromJson(data);
      if (data["overall_status"] == true) {
        fetchContractAnalysisData();
        closeDialog();
        Get.off(() => LegalIssueSpotterResult()); // Use Get.off to replace the current page
        // channel.sink.close(status.goingAway);
      } else {
        showStatusLeagalIssueSpotterDilog();
      }
      channel.sink.add('received!');
      if (kDebugMode) {
        print("webSocketMessage $message");
      }
    });
  }

  void showStatusLeagalIssueSpotterDilog() {
    if (!isDialogVisible.value) {
      isDialogVisible.toggle();
      Get.dialog(
        barrierDismissible: false,
        AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          contentPadding: EdgeInsets.zero,
          title: const Text(
            'Leagal Issue Spotter! \nWe are processing',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFFF5C40),
              fontSize: 20,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Obx(
            () => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                WebSoketDilog(
                  label: leagalIssueWebSoketModel.value?.updateMessage?.textProcessing?.label,
                  description: leagalIssueWebSoketModel.value?.updateMessage?.textProcessing?.description,
                  status: leagalIssueWebSoketModel.value?.updateMessage?.textProcessing?.status,
                ),
                WebSoketDilog(
                  label: leagalIssueWebSoketModel.value?.updateMessage?.findlegalissue?.label,
                  description: leagalIssueWebSoketModel.value?.updateMessage?.findlegalissue?.description,
                  status: leagalIssueWebSoketModel.value?.updateMessage?.findlegalissue?.status,
                ),
                WebSoketDilog(
                  label: leagalIssueWebSoketModel.value?.updateMessage?.finalizeResult?.label,
                  description: leagalIssueWebSoketModel.value?.updateMessage?.finalizeResult?.description,
                  status: leagalIssueWebSoketModel.value?.updateMessage?.finalizeResult?.status,
                ),
                WebSoketDilog(
                  label: "overall status",
                  description: leagalIssueWebSoketModel.value?.overallStatus == true ? "complete" : "overall status is processing",
                  status: leagalIssueWebSoketModel.value?.overallStatus,
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  final leagalIssueModel = <LeagalIssueModel>[].obs;

  void fetchContractAnalysisData() async {
    try {
      final leagalAnalysisRes = await supabase.schema(ApiConst.analysisSchema).from("issue_spotter").select().eq("id", queryId.value);
      leagalIssueModel.value = leagalAnalysisRes.map((json) => LeagalIssueModel.fromJson(json)).toList();
      dev.log("leagalAnalysisRes ${jsonEncode(leagalAnalysisRes)}");
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void closeDialog() {
    if (isDialogVisible.value) {
      Get.back();
      isDialogVisible.toggle();
    }
  }

  final RxList<String> listOfTitles = ["All", "High risk", "Medium risk", "Low risk"].obs;

  final RxInt currentIndex = 0.obs;
  void changeSateFunc(indexx) {
    currentIndex.value = indexx;
  }

  late PageController pageController;
}
