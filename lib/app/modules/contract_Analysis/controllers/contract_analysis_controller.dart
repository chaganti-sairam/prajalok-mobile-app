import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:prajalok/app/data/serlization/analysis_res_model.dart';
import 'package:prajalok/app/data/serlization/contract_analysis_res_model.dart';
import 'package:prajalok/app/data/serlization/newCheckFileModel.dart';
import 'package:prajalok/app/data/webSoketModel.dart/contractAnalysisModel.dart';
import 'package:prajalok/app/modules/document_chat/views/subscription_plans.dart';
import 'package:prajalok/app/utils/api_const.dart';
import 'package:prajalok/app/utils/customer_loading.dart';
import 'dart:developer' as dev;
import 'package:path/path.dart' as path;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

import '../views/contract_analysis_result.dart';

class ContractAnalysisController extends GetxController {
  final Rx<FileCheckModel> contarctAnlysisFileChekingModel = FileCheckModel().obs;
  final RxString loaclfilePath = "".obs;
  final isLoading = false.obs;
  final RxInt moduleId = 10.obs;
  final uuid = supabase.auth.currentUser?.id;
  final RxString publicUrl = "".obs;
  final RxInt queryId = 0.obs;
  var isDialogVisible = false.obs;
  final RxList pickedFile = [].obs;

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
      contarctAnlysisFileChekingModel.value = FileCheckModel.fromJson(decodedResponse);
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
    contarctAnlysisFileChekingModel.value.isAgreement = null;
    contarctAnlysisFileChekingModel.value.isLegal = null;
    contarctAnlysisFileChekingModel.value.isEnglish = null;
    contarctAnlysisFileChekingModel.value.isPageLimit = null;
    contarctAnlysisFileChekingModel.value.isReadable = null;
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
        String newPath = path.join(dir, 'prajalokCam.jpg');
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

  Future<bool?> uploadFileContarctAnalysis() async {
    var request = http.MultipartRequest('POST', Uri.parse(ApiConst.gcsFileuploadUrl));
    request.fields.addAll({'bucket_name': 'ld_user_bucket', 'gcs_folder_path': "$uuid/contarct_analysis", 'make_public': 'true'});
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

  Future<bool?> sendContractAnalysis() async {
    try {
      final result = await supabase.schema(ApiConst.analysisSchema).from("contract_analysis").insert({
        "profile_id": supabase.auth.currentUser!.id,
        "doc_url": publicUrl.value.toString(),
      }).select();
      queryId.value = result[0]["id"];
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
            final res = await uploadFileContarctAnalysis();
            if (res != null) {
              final response = await sendContractAnalysis();
              if (response != null) {
                supabase.schema(ApiConst.analysisSchema).from("contract_analysis").stream(primaryKey: ["id"]).eq('id', queryId.value).listen((data) {
                      if (data[0]['task_id'] != null) {
                        Get.back();
                        webSocketConnect(data[0]['task_id']);
                        if (kDebugMode) {
                          print("TaskIDDDD  ${data[0]['task_id'].toString()}");
                        }
                      }
                    });
              } else {
                Get.dialog(const ReusableProcessingDialog());
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
    contarctAnlysisFileChekingModel.update((val) {
      contarctAnlysisFileChekingModel.value = val!;
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

  Rx<ContarctAnalysisWebSoketModel?> contractAnalysisWebSoketModel = Rx<ContarctAnalysisWebSoketModel?>(null);

  void webSocketConnect(taskid) {
    final wsUrl = Uri.parse("ws://redis-manager-yxfpjr3pvq-el.a.run.app/ws/$taskid");
    var channel = WebSocketChannel.connect(wsUrl);
    channel.stream.listen((message) {
      final data = jsonDecode(message);
      contractAnalysisWebSoketModel.value = ContarctAnalysisWebSoketModel.fromJson(data);
      if (data["overall_status"] == true) {
        channel.sink.close(status.goingAway);
        fetchContractAnalysisData();
        closeDialog();
        Get.to(() => ContractAnalysisResult());
      } else {
        contractAnalysisWebSoketModel.value = ContarctAnalysisWebSoketModel.fromJson(data);
        showStatusDialogContractAnlysis();
      }
      channel.sink.add('received!');
      if (kDebugMode) {
        print("webSocketMessage $message");
      }
    });
  }

  void showStatusDialogContractAnlysis() {
    if (!isDialogVisible.value) {
      isDialogVisible.toggle();
      Get.dialog(
        barrierDismissible: false,
        AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          contentPadding: EdgeInsets.zero,
          title: const Text(
            'Contarct Analysis! \nWe are processing',
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
                  label: contractAnalysisWebSoketModel.value?.updateMessage?.textProcessing?.label,
                  description: contractAnalysisWebSoketModel.value?.updateMessage?.textProcessing?.description,
                  status: contractAnalysisWebSoketModel.value?.updateMessage?.textProcessing?.status,
                ),
                WebSoketDilog(
                  label: contractAnalysisWebSoketModel.value?.updateMessage?.summaryAndLegibility?.label,
                  description: contractAnalysisWebSoketModel.value?.updateMessage?.summaryAndLegibility?.description,
                  status: contractAnalysisWebSoketModel.value?.updateMessage?.summaryAndLegibility?.status,
                ),
                WebSoketDilog(
                  label: contractAnalysisWebSoketModel.value?.updateMessage?.clauseAndPartyIdentification?.label,
                  description: contractAnalysisWebSoketModel.value?.updateMessage?.clauseAndPartyIdentification?.description,
                  status: contractAnalysisWebSoketModel.value?.updateMessage?.clauseAndPartyIdentification?.status,
                ),
                WebSoketDilog(
                  label: contractAnalysisWebSoketModel.value?.updateMessage?.fairnessAndRiskAssessment?.label,
                  description: contractAnalysisWebSoketModel.value?.updateMessage?.fairnessAndRiskAssessment?.description,
                  status: contractAnalysisWebSoketModel.value?.updateMessage?.fairnessAndRiskAssessment?.status,
                ),
                WebSoketDilog(
                  label: contractAnalysisWebSoketModel.value?.updateMessage?.clauseNamesGeneration?.label,
                  description: contractAnalysisWebSoketModel.value?.updateMessage?.clauseNamesGeneration?.description,
                  status: contractAnalysisWebSoketModel.value?.updateMessage?.clauseNamesGeneration?.status,
                ),
                WebSoketDilog(
                  label: contractAnalysisWebSoketModel.value?.updateMessage?.comprehensiveClauseAnalysis?.label,
                  description: contractAnalysisWebSoketModel.value?.updateMessage?.comprehensiveClauseAnalysis?.description,
                  status: contractAnalysisWebSoketModel.value?.updateMessage?.comprehensiveClauseAnalysis?.status,
                ),
                WebSoketDilog(
                  label: "overall status",
                  description: contractAnalysisWebSoketModel.value?.overallStatus == true ? "complete" : "overall status is processing",
                  status: contractAnalysisWebSoketModel.value?.overallStatus,
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  final contractAnalysisResponseModel = <ContractAnalysisResponseModel>[].obs;
  void fetchContractAnalysisData() async {
    try {
      final analysisRes = await supabase
          .schema(ApiConst.analysisSchema)
          .from("contract_analysis")
          .select()
          .eq("id", queryId.value)
          .order("created_at", ascending: false);
      contractAnalysisResponseModel.value = analysisRes.map((json) => ContractAnalysisResponseModel.fromJson(json)).toList();
      dev.log(jsonEncode(analysisRes));
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

  // final staticLegalDocumentsModel = <StaticLegalDocumentsModel>[].obs;
  // void getLegalDocuments() async {
  //   //.eq("id", 58).
  //   try {
  //     await supabase.schema(ApiConst.staticshema).from("legal_documents").select().then((value) {
  //       staticLegalDocumentsModel.value = value.map((json) => StaticLegalDocumentsModel.fromJson(json)).toList();
  //     }).catchError((value) {
  //       if (kDebugMode) {
  //         print(value);
  //       }
  //     });
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //   }
  // }

  final RxList<String> listOfTitles = ["Overall analysis", "Clause by clause"].obs;
  final RxInt currentIndex = 0.obs;

  void changeSateFunc(indexx) {
    currentIndex.value = indexx;
  }

  late PageController pageController;
}
