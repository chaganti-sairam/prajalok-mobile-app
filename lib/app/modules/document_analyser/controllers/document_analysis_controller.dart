// ignore_for_file: unnecessary_overrides

import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:prajalok/app/data/serlization/analysisWebSoketModel.dart';
import 'package:prajalok/app/data/serlization/analysis_res_model.dart';
import 'package:prajalok/app/data/serlization/newCheckFileModel.dart';
import 'package:prajalok/app/data/serlization/staticlegaldocumentsModel.dart';
import 'package:prajalok/app/utils/api_const.dart';
import 'package:path/path.dart' as path;
import 'package:prajalok/app/utils/customer_loading.dart';
import 'package:prajalok/app/utils/re_usable_class.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:developer' as dev;
import '../../document_chat/views/subscription_plans.dart';
import '../views/document_analysis_result.dart';

class DocumentAnalysisController extends GetxController {
  final RxList files = [].obs;
  final RxString loaclfilePath = "".obs;
  final isLoading = false.obs;
  final RxInt moduleId = 1.obs;
  final uuid = supabase.auth.currentUser?.id;
  final RxString publicUrl = "".obs;
  final RxInt queryId = 0.obs;
  var isDialogVisible = false.obs;
  RxBool isFocused = false.obs;
  final Rx<FileCheckModel> fileCheckModel = FileCheckModel().obs;
//  Rx<FileCheckModel?> fileCheckModel = Rx<FileCheckModel?>(null);

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

      fileCheckModel.value = FileCheckModel.fromJson(decodedResponse);
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
    fileCheckModel.value.isAgreement = null;
    fileCheckModel.value.isLegal = null;
    fileCheckModel.value.isEnglish = null;
    fileCheckModel.value.isPageLimit = null;
    fileCheckModel.value.isReadable = null;
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
      files.add(filePath?.replaceAll("/data/user/0/com.example.prajalok/cache/file_picker/", ""));
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
        if (kDebugMode) {
          print("ggggggg $newPath");
        }
        files.add(newPath);
      } else {
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<bool?> uploadFileAnalysis() async {
    var request = http.MultipartRequest('POST', Uri.parse(ApiConst.gcsFileuploadUrl));
    request.fields.addAll({'bucket_name': 'ld_user_bucket', 'gcs_folder_path': "$uuid/doc_analyser", 'make_public': 'true'});
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

  Future<bool?> sendDocumentAnalysis() async {
    try {
      final result = await supabase.schema(ApiConst.analysisSchema).from("document_analysis").insert({
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

  // Future<bool?> getCredit() async {
  //   try {
  //     final res = await supabase.schema("billing").rpc("has_sufficient_credits", params: {
  //       'p_module_id': moduleId.value.toInt(),
  //       'p_credits_required': 1,
  //       'p_profile_id': uuid,
  //     });
  //     if (kDebugMode) {
  //       print("available_credits $res");
  //     }
  //     if (res["has_sufficient_credits"] == true) {
  //       GetCreditCustomDialog.showConfirmationDialog(
  //         subtitle: "Credit Usage Confirmation!",
  //         message: "Specified number of credits will be deducted from your account.",
  //         buttonText: "Continue",
  //         context: Get.context!,
  //         onPressed: () async {
  //           Get.back();
  //           deductCredits(
  //             moduleId: moduleId.value.toInt(),
  //           );
  //           final res = await uploadFileAnalysis();
  //           if (res != null) {
  //             final response = await sendDocumentAnalysis();
  //             if (response != null) {
  //               supabase.schema(ApiConst.analysisSchema).from("document_analysis").stream(primaryKey: ["id"]).eq('id', queryId.value).listen((data) {
  //                     if (data[0]['task_id'] != null) {
  //                       // Get.back();
  //                       webSocketConnect(data[0]['task_id']);
  //                       if (kDebugMode) {
  //                         print("TaskIDDDD  :${data[0]['task_id'].toString()}");
  //                       }
  //                     }
  //                   });
  //             } else {
  //               Get.dialog(const ReusableProcessingDialog());
  //             }
  //           }
  //         },
  //         res: res["available_credits"],
  //       );
  //     } else {
  //       GetCreditCustomDialog.showConfirmationDialog(
  //         subtitle: "Insufficient Credits !",
  //         message: "Looks like you've run out of credits. Buy more to continue accessing this feature",
  //         buttonText: "Buy credits",
  //         context: Get.context!,
  //         onPressed: () {
  //           Get.to(const SubScriptionPlan());
  //         },
  //         res: res["available_credits"],
  //       );
  //     }
  //     return true;
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //   }
  //   return null;
  // }

  Future<dynamic> deductCredits({required int moduleId}) async {
    return supabase
        .schema("billing")
        .rpc("deduct_user_credits", params: {"p_module_id": moduleId, "p_credits_to_deduct": 1, 'p_profile_id': uuid}).then((value) {
      if (kDebugMode) {
        print("deductcreadit $value");
      }
      return value;
    }).onError((error, stackTrace) {
      return {};
    });
  }

  @override
  void onInit() {
    fileCheckModel.update((val) {
      fileCheckModel.value = val!;
    });
    super.onInit();
    getLegalDocuments();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  final docAnylysisControllertext = TextEditingController().obs;

  bool isDialogOpen = false;
  Map<String, dynamic> webSocketIntialResponse = {};
  void webSocketConnect(taskid) {
    final wsUrl = Uri.parse("ws://redis-manager-yxfpjr3pvq-el.a.run.app/ws/$taskid");
    var channel = WebSocketChannel.connect(wsUrl);
    channel.stream.listen((message) {
      final data = jsonDecode(message);
      webSocketIntialResponse = data;
      if (data["overall_status"] == true) {
        fetchAnlysisedData();
        closeDialog();
        Get.off(() => DocAnalysisResult());

        files.clear();
      } else {
        if (!isDialogOpen) {
          isDialogOpen = true;
          showResponseWebSoketDialog(Get.context!, "Doc Analysis!", webSocketIntialResponse);
        }
      }
      channel.sink.add('received!');
      if (kDebugMode) {
        print("webSocketMessage $message");
      }
    });
  }

  final legalDocuments = <LegalDocument>[].obs;
  void fetchAnlysisedData() async {
    try {
      final analysisRes = await supabase.schema(ApiConst.analysisSchema).from("document_analysis").select().eq("id", queryId.value);
      final res = analysisRes;
      legalDocuments.value = res.map((json) => LegalDocument.fromJson(json)).toList();
      dev.log(analysisRes.toString());
      if (kDebugMode) {
        print(jsonEncode(analysisRes));
      }
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

  final staticLegalDocumentsModel = <StaticLegalDocumentsModel>[].obs;

  void getLegalDocuments() async {
    try {
      await supabase.schema(ApiConst.staticshema).from("legal_documents").select().then((value) {
        staticLegalDocumentsModel.value = value.map((json) => StaticLegalDocumentsModel.fromJson(json)).toList();
      }).catchError((value) {
        if (kDebugMode) {
          print(value);
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
