import 'dart:convert';
import 'dart:io';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:prajalok/app/data/serlization/doc_generation_model.dart';
import 'package:prajalok/app/data/serlization/staticlegaldocumentsModel.dart';
import 'package:prajalok/app/data/webSoketModel.dart/DocWriterDocGenerationModel.dart';
import 'package:prajalok/app/modules/document_chat/views/subscription_plans.dart';
import 'package:prajalok/app/utils/api_const.dart';
import 'dart:developer' as dev;
import 'package:http/http.dart' as http;
import 'package:prajalok/app/utils/color_const.dart';
import 'package:prajalok/app/utils/icons_const.dart';
import 'package:prajalok/app/utils/re_usable_class.dart';
import 'package:prajalok/app/utils/widgetButton.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../data/serlization/newCheckFileModel.dart';
import '../../../utils/customer_loading.dart';
import '../views/doc_writer_page_stepers.dart';
import '../views/generated_document.dart';

class DocumentWriteController extends GetxController {
  final FocusNode focusNode = FocusNode();
  RxBool isFocused = false.obs;

  final RxBool isLoading = false.obs;
  final docSummryContrller = TextEditingController().obs;
  final uuid = supabase.auth.currentUser?.id;
  final legalDocumentId = 0.obs;
  final RxList<dynamic> uploadedUrl = <dynamic>[].obs;
  final listfileCheckResultsobx = <FileCheckModel>[].obs;
  final boxdocGenerationid = GetStorage();
  final RxString paths = "".obs;
  final RxInt docWriterModuleID = 4.obs;
  final selectedIndex = 0.obs;

  int? readId() {
    int? userId = boxdocGenerationid.read('id');
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

  void getStaticLeagalDocument() async {
    await supabase
        .schema(ApiConst.staticshema)
        .from("legal_documents")
        .select()
        .eq("is_template", "TRUE")
        .order("id", ascending: false)
        .then((value) {
      legalDocumentId.value = value[0]["id"];
      staticlegaldocumentsModel.value = value.map((e) => StaticLegalDocumentsModel.fromJson(e)).toList();
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
    });
  }

  final Rx<FileCheckModel> checkFileModel = FileCheckModel().obs;
  void clearCheckFileDocWriter() {
    docriterfileCheckModel.value.isAgreement = null;
    docriterfileCheckModel.value.isLegal = null;
    docriterfileCheckModel.value.isEnglish = null;
    docriterfileCheckModel.value.isPageLimit = null;
    docriterfileCheckModel.value.isReadable = null;
  }

  Future<bool?> insertDataDocgenerations() async {
    isLoading.value = true;
    try {
      final res = await supabase.schema(ApiConst.templatecshema).from("doc_generations").insert({
        "profile_id": uuid,
        "legal_document_id": legalDocumentId.value,
        "case_context": docSummryContrller.value.text,
        "case_files": uploadedUrl.map((url) => url.toString()).toList(),
      }).select();
      boxdocGenerationid.write('id', res[0]["id"]);
      // docGenerationid.value = res[0]["id"];
      print("luuuuuuuuudddn ${readId().toString()}");
      isLoading.value = false;
      return true;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("Error: $e, StackTrace: $stackTrace");
      }
      isLoading.value = false;
      return false;
    }
  }

  final files = <File>[].obs;

  /// RECENT ACTIVITY IN DOC WRITER
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

  /// file cheking and repsone file picker herer
  final Rx<FileCheckModel> docriterfileCheckModel = FileCheckModel().obs;
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
          print("responseBody $responseBody");
          docriterfileCheckModel.refresh();
          var decodedResponse = jsonDecode(responseBody);
          docriterfileCheckModel.value = FileCheckModel.fromJson(decodedResponse);
          fileCheckResults.add(docriterfileCheckModel.value);
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

  void filepickerDocWriter() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.any,
      );
      if (result != null && result.files.isNotEmpty) {
        Get.back();
        files.addAll(result.paths.map((path) => File(path!)).toList());
      } else {
        Get.snackbar("No Files Selected", "Please select one or more documents.");
      }
    } catch (error) {
      print("File picker error: $error");
      Get.snackbar("Error", "An error occurred while picking files.");
    }
  }

  File? imgFile;
  void takeSnapshotDocWriter() async {
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

  /// file cheking and repsone file picker close here

//credit and gcs uploading file
  Future<bool?> getCredit() async {
    try {
      final res = await supabase.schema("billing").rpc("has_sufficient_credits", params: {
        'p_module_id': docWriterModuleID.value.toInt(),
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
              moduleId: docWriterModuleID.value.toInt(),
            );
            Get.dialog(const ReusableProcessingDialog());
            final res = await uploadFiles(files, uuid.toString());
            if (res != null) {
              var response = await insertDataDocgenerations();
              if (response != null) {
                Future.delayed(Duration.zero, () {
                  supabase
                      .schema(ApiConst.templatecshema)
                      .from("doc_generations")
                      .stream(primaryKey: ["id"])
                      .eq('id', readId() ?? 0.toInt())
                      .listen((data) {
                        if (data[0]['task_id'] != null) {
                          Get.back();
                          if (kDebugMode) {
                            print("amreshhhhrrrrr ${data[0]['task_id']}");
                          }
                          final taskId = data[0]['task_id'];
                          webSocketFirstConnect(taskId);
                        }
                      });
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
            Get.to(() => const SubScriptionPlan());
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
        request.fields.addAll({'bucket_name': 'ld_user_bucket', 'gcs_folder_path': '$uuid/docwriter', 'make_public': 'true'});

        var multipartFile = await http.MultipartFile.fromPath('file_upload', file.path);
        request.files.add(multipartFile);
        http.StreamedResponse response = await request.send();
        if (response.statusCode == 200) {
          var decodedResponse = await response.stream.bytesToString();
          var responseData = jsonDecode(decodedResponse);
          uploadedUrl.add(responseData["public_url"]);
          var publicUrl = responseData["public_url"];
          if (kDebugMode) {
            print("Uploaded successfully. Public URL: $publicUrl");
          }
        } else {
          if (kDebugMode) {
            print("Upload failed with status code: ${response.statusCode}");
            print("Reason: ${response.reasonPhrase}");
          }
          return false;
        }
      }
      // All files uploaded successfully
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Exception during file upload: $e");
      }
      return false;
    }
  }

  bool isDialogVisibledocWiriter = false;

  Map<String, dynamic> webSocketIntialResponse = {};
  void webSocketFirstConnect(taskid) {
    final wsUrl = Uri.parse("ws://redis-manager-yxfpjr3pvq-el.a.run.app/ws/$taskid");
    var channel = WebSocketChannel.connect(wsUrl);
    channel.stream.listen((message) {
      final data = jsonDecode(message);
      webSocketIntialResponse = data;
      if (data["overall_status"] == true) {
        moveToStepersPage();
        files.clear();
      } else {
        if (!isDialogVisibledocWiriter) {
          isDialogVisibledocWiriter = true;
          showResponseWebSoketDialog(Get.context!, "Document Writer!", webSocketIntialResponse);
        }
      }
      channel.sink.add('received!');
      if (kDebugMode) {
        print("Document Writer! $message");
      }
    });
  }

// *************************Started Get refernce for DocWiter here**********************

  final isDialogGetReferncesVisible = false.obs;
  final isExpanded = false.obs;
  final RxList referancedata = [].obs;
  void expansionchnage(value) {
    isExpanded.value = !isExpanded.value;
  }

  Future<bool?> postReferences() async {
    try {
      final response = await http.post(
        Uri.parse(ApiConst.docWriterftRefernacesUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'id': readId(), "limit": null}),
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

  bool isDialogOpen = false;
  Map<String, dynamic> referanceWebSoketrResponse = {};
  void webSocketgetRefernces(String refferenceTaskID) {
    final wsUrl = Uri.parse("ws://redis-manager-yxfpjr3pvq-el.a.run.app/ws/$refferenceTaskID");
    var channel = WebSocketChannel.connect(wsUrl);
    channel.stream.listen((message) async {
      final data = jsonDecode(message);
      referanceWebSoketrResponse = data;
      if (data["overall_status"] == true) {
        fetchGetRefernceDocgeneration();
      } else {
        if (!isDialogOpen) {
          isDialogOpen = true;
          showResponseWebSoketDialog(Get.context!, "Document References!", referanceWebSoketrResponse);
        }
      }
      channel.sink.add('received!');
      if (kDebugMode) {
        print("Document Writer! $message");
      }
    });
  }

  final docWriterDocGenerationModel = <DocWriterDocGenerationModel>[].obs;
  void fetchGetRefernceDocgeneration() async {
    try {
      final sessionRes = await supabase.schema(ApiConst.templatecshema).from("doc_generations").select().eq("id", readId() ?? 0);
      dev.log("sessionRessessionRes ${jsonEncode(sessionRes)} ${readId() ?? 0}");
      final sessionResres = sessionRes as List;
      docWriterDocGenerationModel.value = sessionResres.map((e) => DocWriterDocGenerationModel.fromJson(e)).toList(growable: false);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // try {
  //       await channel.sink.close();
  //       if (kDebugMode) {
  //         print("WebSocket closed successfully${channel.sink.close()}");
  //       }
  //     } catch (error) {
  //       if (kDebugMode) {
  //         print("Error closing WebSocket: $error");
  //       }
  //     }

  //?? **************  close DocWriter GetReference here ************

  final RxList<String> listOfIcons = [SvgIcons.uploadIconStep, SvgIcons.penEditingStep, SvgIcons.docviewStep].obs;
  final RxList<String> listOfTitles = ["Upload", "Answer", "Review"].obs;
  final RxInt currentIndex = 0.obs;

  void changeSateFunc(indexx) {
    currentIndex.value = indexx;
  }

  late PageController pageController;
  void moveToStepersPage() {
    pageController = PageController(initialPage: currentIndex.value);
    Get.to(() => DocWriterStepeps());
    //        Get.off(() => DocReferanceChat());
  }

  void moveToStepersPage1() {
    changeSateFunc(currentIndex.value + 1);
    pageController.animateToPage(
      currentIndex.value,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  @override
  void onInit() {
    getStaticLeagalDocument();
    pageController = PageController(initialPage: currentIndex.value);
    focusNode.addListener(() {
      isFocused.value = focusNode.hasFocus;
    });
    getLegalDocuments();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    docSummryContrller.value.dispose();
    focusNode.dispose();
    super.onClose();
  }

  RxBool isChecked = false.obs;
  void chekbox(value) {
    isChecked.value = value!;
  }

//?? **************** ****************  upload Amress Referance file here *******************************************

  // final filepathRef = ''.obs;
  // final filesRef = <File>[].obs;
  // final Rx<FileCheckModel> fileCheckModelRef = FileCheckModel().obs;
  // void clear() {
  //   fileCheckModelRef.value.isAgreement = null;
  //   fileCheckModelRef.value.isLegal = null;
  //   fileCheckModelRef.value.isEnglish = null;
  //   fileCheckModelRef.value.isPageLimit = null;
  //   fileCheckModelRef.value.isReadable = null;
  // }

  // void filepickeReference() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     allowMultiple: true,
  //     type: FileType.any,
  //   );
  //   if (result != null && result.paths.isNotEmpty) {
  //     Get.back();
  //     filesRef.addAll(result.paths.map((path) => File(path!)).toList());
  //   } else {
  //     Get.snackbar("Files${filesRef.isEmpty}", "No file picked");
  //     if (kDebugMode) {
  //       print('No files picked');
  //     }
  //   }
  // }

  // Future<void> checkMultipleFilesRef() async {
  //   for (var i = 0; i < filesRef.length; i++) {
  //     bool? result = await checkSingleFilRef(filesRef[i]);
  //     if (result != null && result) {
  //       if (kDebugMode) {
  //         print("  Filecheck succeeded for   ${filesRef[i].path}");
  //       }
  //     } else {
  //       Get.snackbar(
  //           "File check failed", "File check failed for ${filesRef[i].path}");
  //       if (kDebugMode) {
  //         print("File check failed for ${filesRef[i].path}");
  //       }
  //     }
  //   }
  // }

  // final decodedResponse1 = ''.obs;

  // Future<bool?> checkSingleFilRef(File fileref1) async {
  //   isLoading.value = true;
  //   var request =
  //       http.MultipartRequest('POST', Uri.parse(ApiConst.lawyerDeskCheckFile));
  //   request.files.add(await http.MultipartFile.fromPath('file', fileref1.path));
  //   filepathRef.value = fileref1.path;
  //   try {
  //     http.StreamedResponse response = await request.send();
  //     if (response.statusCode == 200) {
  //       String responseBody = await response.stream.bytesToString();
  //       var decodedResponse = jsonDecode(responseBody);
  //       decodedResponse1.value = responseBody;
  //       fileCheckModelRef.value = FileCheckModel.fromJson(decodedResponse);
  //       if (kDebugMode) {
  //         print("decodedResponse for }: ${decodedResponse1.value}");
  //       }
  //       isLoading.value = false;
  //       return true;
  //     } else {
  //       if (kDebugMode) {
  //         print('Request failed with status: ${response.statusCode}');
  //       }
  //     }
  //     isLoading.value = false;
  //     return false;
  //   } catch (error) {
  //     Get.snackbar("Error", "$error");
  //   } finally {
  //     isLoading.value = false;
  //   }
  //   return false;
  // }

  // Future<bool?> uploadFilesRef(List<File> files, String uuid) async {
  //   try {
  //     for (var i = 0; i < filesRef.length; i++) {
  //       var file = filesRef[i];
  //       var request =
  //           http.MultipartRequest('POST', Uri.parse(ApiConst.gcsFileuploadUrl));
  //       request.fields.addAll({
  //         'bucket_name': 'ld_user_bucket',
  //         'gcs_folder_path': '$uuid/doc_talk',
  //         'make_public': 'true'
  //       });
  //       var multipartFile =
  //           await http.MultipartFile.fromPath('file_upload', file.path);
  //       request.files.add(multipartFile);

  //       http.StreamedResponse response = await request.send();
  //       if (response.statusCode == 200) {
  //         var decodedResponse = await response.stream.bytesToString();
  //         var responseData = jsonDecode(decodedResponse);
  //         uploadedUrl.add(responseData["public_url"]);
  //         var publicUrl = responseData["public_url"];
  //         if (kDebugMode) {
  //           print("Uploaded successfully. Public URL: $publicUrl");
  //         }
  //       } else {
  //         if (kDebugMode) {
  //           print("Upload failed with status code: ${response.statusCode}");
  //           print("Reason: ${response.reasonPhrase}");
  //         }
  //         return false;
  //       }
  //     }
  //     return true;
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print("Exception during file upload: $e");
  //     }
  //     return false;
  //   }
  // }

  Future<bool?> insertDataDocreferances() async {
    isLoading.value = true;
    try {
      final res = await supabase
          .schema(ApiConst.templatecshema)
          .from("doc_generations")
          .update({
            "profile_id": uuid,
            "ref_doc_urls": uploadedUrl.map((url) => url.toString()).toList(),
          })
          .eq("id", readId() ?? 0)
          .select();
      if (kDebugMode) {
        print(res);
      }
      isLoading.value = false;
      return true;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("Error: $e, StackTrace: $stackTrace");
      }
      isLoading.value = false;
      return false;
    }
  }

  Future<bool?> postdraftquestions() async {
    try {
      final response = await http.post(
        Uri.parse(ApiConst.docWriterftQuestionUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': readId()}),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (kDebugMode) {
          print("responseBody111111  $responseData");
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

  void getReferfenaces() async {
    final res = await uploadFiles(files, uuid.toString());
    if (res != null) {
      var response = await insertDataDocreferances();
      if (response != null) {
        bool? res = await postdraftquestions();
        if (res != null) {
          supabase.schema(ApiConst.templatecshema).from("doc_generations").stream(primaryKey: ["id"]).eq('id', readId() ?? 0).listen((data) {
                if (data[0]['task_id'] != null) {
                  if (kDebugMode) {
                    print("amreshhhhrrrrr ${data[0]['task_id']}");
                  }
                  webSocketQuestionWebSoket(data[0]['task_id']);
                }
              });
        }
      }
    }
  }

  bool isDialogdraftQuestionsVisible = false;
  Map<String, dynamic> docWriterftQuestionWebSoket = {};
  void webSocketQuestionWebSoket(String taskid1) {
    final wsUrl = Uri.parse("ws://redis-manager-yxfpjr3pvq-el.a.run.app/ws/$taskid1");
    var channel = WebSocketChannel.connect(wsUrl);
    channel.stream.listen((message) async {
      final data = jsonDecode(message);
      docWriterftQuestionWebSoket = data;
      if (data["overall_status"] == true) {
        fetchGetRefernceDocgeneration();
        try {
          await channel.sink.close();
          if (kDebugMode) {
            print("WebSocket closed successfully${channel.sink.close()}");
          }
        } catch (error) {
          if (kDebugMode) {
            print("Error closing WebSocket: $error");
          }
        }
      } else {
        if (!isDialogdraftQuestionsVisible) {
          isDialogdraftQuestionsVisible = true;
          showResponseWebSoketDialog(Get.context!, "Draft Questions!", docWriterftQuestionWebSoket);
        }
      }
      channel.sink.add('received!');
      if (kDebugMode) {
        print("Document Writer! $message");
      }
    });
  }

//?? Final Answer question 3rd steps   method here
  final Rx<String> selectedOptions = ''.obs;
  void onChange(value) {
    selectedOptions.value = value;
  }

  final RxList userResponseId = [].obs;

  final Rx<TextEditingController> answerController = TextEditingController().obs;

  Future<bool?> UpdateUserResponse() async {
    isLoading.value = true;
    try {
      await supabase
          .schema(ApiConst.templatecshema)
          .from("user_responses")
          .update({
            "answer": answerController.value.text,
          })
          .eq("generation_id", readId() ?? 0)
          .order("id", ascending: false)
          .select();
      isLoading.value = false;
      return true;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("Error: $e, StackTrace: $stackTrace");
      }
      isLoading.value = false;
      return false;
    }
  }

  /// Genererated Document list
  final RxList<DocGenerationModel> docGeneratedModel = <DocGenerationModel>[].obs;
  //final res = data.map((e) => DocWriterAnswerModel.fromJson(e)).toList();

  // UPDATE REPSONE AND ADDTIONAL INFORAMTION

  //important_information  column name
  final Rx<TextEditingController> additionalInformationController = TextEditingController().obs;

  Future<bool?> additionalInformation() async {
    isLoading.value = true;
    print("iddddddddddddddddddddddddddddddddddddd ${readId()}");
    try {
      await supabase
          .schema(ApiConst.templatecshema)
          .from("doc_generations")
          .update({
            "important_information": additionalInformationController.value.text,
          })
          .eq("id", readId() ?? 0)
          .select();
      isLoading.value = false;
      return true;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("Error: $e, StackTrace: $stackTrace");
      }
      isLoading.value = false;
      return false;
    }
  }

  Future<bool?> postdFinaldraftwrite() async {
    try {
      final response = await http.post(
        Uri.parse(ApiConst.finalDraftftQuestionUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'id': readId()}),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (kDebugMode) {
          print("responseBody111111  $responseData");
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

  bool isDialogfinalDraftVisible = false;
  Map<String, dynamic> finaldocWriterDraftWebsoketResult = {};
  void webSocketFinalDraftWebSoket(String finaldraftTaskId) {
    final wsUrl = Uri.parse("ws://redis-manager-yxfpjr3pvq-el.a.run.app/ws/$finaldraftTaskId");
    var channel = WebSocketChannel.connect(wsUrl);
    channel.stream.listen((message) async {
      final data = jsonDecode(message);
      finaldocWriterDraftWebsoketResult = data;
      if (data["overall_status"] == true) {
        Get.to(() => GeneratedDocument(
              profileId: readId() ?? 0,
            ));
        try {
          await channel.sink.close();
          if (kDebugMode) {
            print("WebSocket closed successfully${channel.sink.close()}");
          }
        } catch (error) {
          if (kDebugMode) {
            print("Error closing WebSocket: $error");
          }
        }
      } else {
        if (!isDialogfinalDraftVisible) {
          isDialogfinalDraftVisible = true;
          showResponseWebSoketDialog(Get.context!, "final Darft Writer!", finaldocWriterDraftWebsoketResult);
        }
      }
      channel.sink.add('received!');
      if (kDebugMode) {
        print("Document Writer! $message");
      }
    });
  }

  // void showWebSoketDialogFinalDraftWrite() {
  //   if (!isDialogfinalDraftVisible.value) {
  //     isDialogfinalDraftVisible.toggle();
  //     Get.dialog(
  //       barrierDismissible: false,
  //       AlertDialog(
  //         shape:
  //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //         contentPadding: EdgeInsets.zero,
  //         title: const Text(
  //           'final Darft Write! \nWe are processing',
  //           textAlign: TextAlign.center,
  //           style: TextStyle(
  //             color: Color(0xFFFF5C40),
  //             fontSize: 20,
  //             fontFamily: 'Open Sans',
  //             fontWeight: FontWeight.w600,
  //           ),
  //         ),
  //         content: Obx(
  //           () => Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               WebSoketDilog(
  //                 label: finaldocWriterDraftWebsoketModel.value?.updateMessage
  //                     ?.fetchingQuestionsAndAnswersDetails?.label,
  //                 description: finaldocWriterDraftWebsoketModel
  //                     .value
  //                     ?.updateMessage
  //                     ?.fetchingQuestionsAndAnswersDetails
  //                     ?.description,
  //                 status: finaldocWriterDraftWebsoketModel.value?.updateMessage
  //                     ?.fetchingQuestionsAndAnswersDetails?.status,
  //               ),
  //               WebSoketDilog(
  //                 label: finaldocWriterDraftWebsoketModel
  //                     .value?.updateMessage?.generatingFinalTemplate?.label,
  //                 description: finaldocWriterDraftWebsoketModel.value
  //                     ?.updateMessage?.generatingFinalTemplate?.description,
  //                 status: finaldocWriterDraftWebsoketModel
  //                     .value?.updateMessage?.generatingFinalTemplate?.status,
  //               ),
  //               WebSoketDilog(
  //                 label: finaldocWriterDraftWebsoketModel
  //                     .value?.updateMessage?.finalizing?.label,
  //                 description: finaldocWriterDraftWebsoketModel
  //                     .value?.updateMessage?.finalizing?.description,
  //                 status: finaldocWriterDraftWebsoketModel
  //                     .value?.updateMessage?.finalizing?.status,
  //               ),
  //               WebSoketDilog(
  //                 label: "Overall Status",
  //                 description:
  //                     finaldocWriterDraftWebsoketModel.value?.overallStatus ==
  //                             true
  //                         ? "Completed"
  //                         : "overall status is in progress",
  //                 status: finaldocWriterDraftWebsoketModel.value?.overallStatus,
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     );
  //   }
  // }

  // void closeFinalDraftDialog() {
  //   if (isDialogfinalDraftVisible.value) {
  //     Get.back();
  //     isDialogfinalDraftVisible.toggle();
  //   }
  // }

  /// this code only for serach filed*****************************
  final searchController = TextEditingController();

  final staticlegaldocumentsModel = <StaticLegalDocumentsModel>[].obs;
  RxList<SelectedListItem> foundUsers = <SelectedListItem>[].obs;
  final bottomSheetTextController = TextEditingController();

  void bottomSheetFilterList() {
    void initializeFoundUsers() {
      foundUsers
          .assignAll(staticlegaldocumentsModel.map((model) => SelectedListItem(name: model.docSubCategory!, value: model.id.toString())).toList());
    }

    void runFilter(String enteredKeyword) {
      RxList<SelectedListItem> results = <SelectedListItem>[].obs;
      if (enteredKeyword.isEmpty) {
        results
            .assignAll(staticlegaldocumentsModel.map((model) => SelectedListItem(name: model.docSubCategory!, value: model.id.toString())).toList());
      } else {
        results.value = staticlegaldocumentsModel
            .where((user) => user.docSubCategory!.toLowerCase().contains(enteredKeyword.toLowerCase()))
            .map((model) => SelectedListItem(name: model.docSubCategory!, value: model.id.toString()))
            .toList();
      }
      foundUsers.assignAll(results);
    }

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setState) {
          initializeFoundUsers();
          const myPrimarySwatch = MaterialColor(
            0xFFFF5C40,
            {
              50: Color(0xFFFFF5E5), // Lightest shade
              100: Color(0xFFFFEAD5),
              200: Color(0xFFFFE0C5),
              300: Color(0xFFFFD5B5),
              400: Color(0xFFFFCAAA),
              500: Color(0xFFFFC09A), // Primary color
              600: Color(0xFFFFB58A),
              700: Color(0xFFFFAA7A),
              800: Color(0xFFFFA06A),
              900: Color(0xFFFF955A), // Darkest shade
            },
          );

          return Obx(() {
            return Container(
              height: Get.height,
              width: double.maxFinite,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 17),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Document types',
                          style: TextStyle(
                            color: Color(0xFF2B2B2B),
                            fontSize: 18,
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: SvgPicture.asset(
                            width: 24,
                            height: 24,
                            SvgIcons.crossIcons,
                            color: AppColors.textcolor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Theme(
                      data: ThemeData(
                        primarySwatch: myPrimarySwatch,
                      ),
                      child: TextFormField(
                        controller: bottomSheetTextController,
                        onChanged: (value) {
                          runFilter(value);
                        },
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              bottomSheetTextController.clear();
                              runFilter(""); // Clear the filter when the text is cleared
                            },
                            icon: const FaIcon(FontAwesomeIcons.solidCircleXmark),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                          filled: true,
                          fillColor: const Color(0xFFF6F6F6),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintText: 'Type of agreement',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Expanded(
                      child: ListView.builder(
                        itemCount: foundUsers.length,
                        itemBuilder: (context, index) => ListTile(
                          title: WidgetButtonPress(
                            child: InkWell(
                              onTap: () {
                                legalDocumentId.value = int.parse(foundUsers[index].value ?? "0");
                                searchController.text = foundUsers[index].name;
                                if (legalDocumentId.value != 0) {
                                  Get.back();
                                }
                              },
                              child: Text(foundUsers[index].name),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }
}
