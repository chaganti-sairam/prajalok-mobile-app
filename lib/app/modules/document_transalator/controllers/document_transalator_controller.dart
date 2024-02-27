import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:prajalok/app/data/serlization/check_file.dart';
import 'package:prajalok/app/data/serlization/transaltefileuploadmodel.dart';
import 'package:prajalok/app/data/serlization/web_socket_response.dart';
import 'package:prajalok/app/utils/api_const.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:prajalok/app/utils/customeSnackbar.dart';
import 'package:prajalok/app/utils/customer_loading.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../data/serlization/translatedfile_model.dart';
import '../../document_chat/views/subscription_plans.dart';
import '../views/translated_file_view.dart';

class DocumentTransalatorController extends GetxController {
  final isLoading = false.obs;
  final RxList files = [].obs;
  final RxString loaclfilePath = "".obs;
  final RxString imagePath = "".obs;
  final Rx<FileUploadedRes> uploadedresponse = FileUploadedRes().obs;
  final uuid = supabase.auth.currentUser?.id;
  final RxInt queryId = 0.obs;
  final RxString publicUrl = "".obs;
  final RxBool isEnglish = false.obs;
  final RxBool isPageLismit = false.obs;
  final Rx<CheckFileModel> checkFileModel = CheckFileModel(isEnglish: false, isPageLimit: false).obs;
  var isDialogVisible = false.obs;
  final moduleId = 9.obs;

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
      checkFileModel.value = CheckFileModel.fromJson(decodedResponse);
      isEnglish.value = decodedResponse["is_english"];
      isPageLismit.value = decodedResponse["is_page_limit"];
      if (isEnglish.value == true) {
        CustomSnackBar.showCustomErrorToast(message: 'file is Allredy in English');
      } else {
        if (isPageLismit.value == false) {
          CustomSnackBar.showCustomErrorToast(message: 'file Less than 40 pages');
        }
      }

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
            Get.dialog(const ReusableProcessingDialog());
            final res = await uploadFile();
            if (res != null) {
              final response = await sendData();
              if (response != null) {
                Future.delayed(Duration.zero, () {
                  supabase.schema(ApiConst.translateschema).from("translate").stream(primaryKey: ["id"]).eq('id', queryId.value).listen((data) {
                        if (data[0]['task_id'] != null) {
                          webSocketConnect(data[0]['task_id']);
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
      return value;
    }).onError((error, stackTrace) {
      return {};
    });
  }

  void filepicker2() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'png'],
    );
    if (result != null) {
      Get.back();
      final filePath = result.files.single.path; // Assuming single file selection
      loaclfilePath.value = filePath.toString();
      files.add(filePath?.replaceAll("/data/user/0/com.example.prajalok/cache/file_picker/", ""));
    } else {
      return null;
    }
  }

  File? imgFile;
  void takeSnapshot() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? img = await picker.pickImage(
        source: ImageSource.camera, // alternatively, use ImageSource.gallery
      );
      if (img != null) {
        Get.back();
        imgFile = File(img.path);
        String dir = path.dirname(img.path);
        String newPath = path.join(dir, 'prajalokCam.jpg');
        loaclfilePath.value = newPath;
        imgFile?.renameSync(newPath);
        files.add(newPath.replaceAll("/data/user/0/com.example.prajalok/cache/", ""));
      } else {
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<bool?> uploadFile() async {
    var request = http.MultipartRequest('POST', Uri.parse(ApiConst.gcsFileuploadUrl));
    request.fields.addAll({'bucket_name': 'ld_user_bucket', 'gcs_folder_path': "$uuid/folderPath", 'make_public': 'true'});
    request.files.add(await http.MultipartFile.fromPath('file_upload', loaclfilePath.value.toString()));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var decodedResponse = jsonDecode(await response.stream.bytesToString());
      publicUrl.value = decodedResponse["public_url"];
      if (kDebugMode) {
        print("ggggggggg ${publicUrl.value}");
        print("ggggggggg $decodedResponse");
      }
      return true;
    } else {
      if (kDebugMode) {
        print(response.reasonPhrase);
      }
    }
    return false;
  }

  Future<bool?> sendData() async {
    try {
      final result = await supabase.schema(ApiConst.translateschema).from("translate").insert({
        "profile_id": supabase.auth.currentUser!.id,
        "input_doc_url": publicUrl.value.toString(),
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

  @override
  void onInit() {
    super.onInit();
  }

  Rx<WebsoketResponseModel?> websoketResponseModel = Rx<WebsoketResponseModel?>(null);

  void webSocketConnect(taskid) {
    final wsUrl = Uri.parse("ws://redis-manager-yxfpjr3pvq-el.a.run.app/ws/$taskid");
    var channel = WebSocketChannel.connect(wsUrl);
    channel.stream.listen((message) {
      final data = jsonDecode(message);
      websoketResponseModel.value = WebsoketResponseModel.fromJson(data);
      if (data["overall_status"] == true) {
        fetchTranslatedData();
        closeDialog();
        Get.to(() => TranslatedIleView());
      } else {
        websoketResponseModel.value = WebsoketResponseModel.fromJson(data);
        showStatusDialog();
      }
      channel.sink.add('received!');
      if (kDebugMode) {
        print("webSocketMessage $message");
      }
    });
  }

  void showStatusDialog() {
    if (!isDialogVisible.value) {
      isDialogVisible.toggle();
      Get.dialog(
        barrierDismissible: false,
        AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          contentPadding: EdgeInsets.zero,
          title: const Text(
            'Hang in there! \nWe are processing',
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
                  label: websoketResponseModel.value?.updateMessage?.documentFetching?.label,
                  description: websoketResponseModel.value?.updateMessage?.documentFetching?.description,
                  status: websoketResponseModel.value?.updateMessage?.documentFetching?.status,
                ),
                WebSoketDilog(
                  label: websoketResponseModel.value?.updateMessage?.languageDetection?.label,
                  description: websoketResponseModel.value?.updateMessage?.languageDetection?.description,
                  status: websoketResponseModel.value?.updateMessage?.languageDetection?.status,
                ),
                WebSoketDilog(
                  label: websoketResponseModel.value?.updateMessage?.pageTranslation?.label,
                  description: websoketResponseModel.value?.updateMessage?.pageTranslation?.description,
                  status: websoketResponseModel.value?.updateMessage?.pageTranslation?.status,
                ),
                WebSoketDilog(
                  label: websoketResponseModel.value?.updateMessage?.pdfCreation?.label,
                  description: websoketResponseModel.value?.updateMessage?.pdfCreation?.description,
                  status: websoketResponseModel.value?.updateMessage?.pdfCreation?.status,
                ),
                WebSoketDilog(
                  label: websoketResponseModel.value?.updateMessage?.shareableLinkGeneration?.label,
                  description: websoketResponseModel.value?.updateMessage?.shareableLinkGeneration?.description,
                  status: websoketResponseModel.value?.updateMessage?.shareableLinkGeneration?.status,
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  final docTransalatedControllertext = TextEditingController().obs;

  final translatedFileModel = <TranslatedFileModel>[].obs;

  fetchTranslatedData() async {
    try {
      final lawsearchRes = await supabase.schema(ApiConst.translateschema).from("translate").select().eq("id", queryId.value);
      final result = lawsearchRes;
      translatedFileModel.value = result.map((e) => TranslatedFileModel.fromJson(e)).toList(growable: false);
      if (kDebugMode) {
        print(lawsearchRes);
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

  //
  Map<String, String> languageMapping = {
    "en": "English",
    "hi": "Hindi",
    "te": "Telugu",
    "es": "Spanish",
    "fr": "French",
    "de": "German",
    "zh": "Chinese (Simplified)",
    "zh-TW": "Chinese (Traditional)",
    "ja": "Japanese",
    "ru": "Russian",
    "ar": "Arabic",
    "pt": "Portuguese",
    "it": "Italian",
    "ko": "Korean",
    "tr": "Turkish",
    "nl": "Dutch",
    "pl": "Polish",
    "sv": "Swedish",
    "da": "Danish",
    "fi": "Finnish",
    "no": "Norwegian",
    "cs": "Czech",
    "el": "Greek",
    "id": "Indonesian",
    "ms": "Malay",
    "th": "Thai",
    "vi": "Vietnamese",
    "mr": "Marathi",
    "gu": "Gujarati",
    "bn": "Bengali",
    "af": "Afrikaans",
    "sq": "Albanian",
    "am": "Amharic",
    "hy": "Armenian",
    "as": "Assamese",
    "ay": "Aymara",
    "az": "Azerbaijani",
    "bm": "Bambara",
    "eu": "Basque",
    "be": "Belarusian",
    "bho": "Bhojpuri",
    "bs": "Bosnian",
    "bg": "Bulgarian",
    "ca": "Catalan",
    "ceb": "Cebuano",
    "co": "Corsican",
    "hr": "Croatian",
    "dv": "Dhivehi",
    "doi": "Dogri",
    "eo": "Esperanto",
    "et": "Estonian",
    "ee": "Ewe",
    "fil": "Filipino (Tagalog)",
    "fy": "Frisian",
    "gl": "Galician",
    "ka": "Georgian",
    "gn": "Guarani",
    "ht": "Haitian Creole",
    "ha": "Hausa",
    "haw": "Hawaiian",
    "he": "Hebrew",
    "hmn": "Hmong",
    "hu": "Hungarian",
    "is": "Icelandic",
    "ig": "Igbo",
    "ilo": "Ilocano",
    "ga": "Irish",
    "jv": "Javanese",
    "kn": "Kannada",
    "kk": "Kazakh",
    "km": "Khmer",
    "rw": "Kinyarwanda",
    "gom": "Konkani",
    "kri": "Krio",
    "ku": "Kurdish",
    "ckb": "Kurdish (Sorani)",
    "ky": "Kyrgyz",
    "lo": "Lao",
    "la": "Latin",
    "lv": "Latvian",
    "ln": "Lingala",
    "lt": "Lithuanian",
    "lg": "Luganda",
    "lb": "Luxembourgish",
    "mk": "Macedonian",
    "mai": "Maithili",
    "mg": "Malagasy",
    "ml": "Malayalam",
    "mt": "Maltese",
    "mi": "Maori",
    "mni-Mtei": "Meiteilon (Manipuri)",
    "lus": "Mizo",
    "mn": "Mongolian",
    "my": "Myanmar (Burmese)",
    "ne": "Nepali",
    "ny": "Nyanja (Chichewa)",
    "or": "Odia (Oriya)",
    "om": "Oromo",
    "ps": "Pashto",
    "fa": "Persian",
    "gd": "Scots Gaelic",
    "nso": "Sepedi",
    "sr": "Serbian",
    "st": "Sesotho",
    "sn": "Shona",
    "sd": "Sindhi",
    "si": "Sinhala (Sinhalese)",
    "sk": "Slovak",
    "sl": "Slovenian",
    "so": "Somali",
    "su": "Sundanese",
    "sw": "Swahili",
    "tl": "Tagalog (Filipino)",
    "tg": "Tajik",
    "ta": "Tamil",
    "tt": "Tatar",
    "ti": "Tigrinya",
    "ts": "Tsonga",
    "tk": "Turkmen",
    "ak": "Twi (Akan)",
    "uk": "Ukrainian",
    "ur": "Urdu",
    "ug": "Uyghur",
    "uz": "Uzbek",
    "cy": "Welsh",
    "xh": "Xhosa",
    "yi": "Yiddish",
    "yo": "Yoruba",
    "zu": "Zulu"
  };

  final languageMapres = "".obs;
  languageMap(String text) {
    for (int i = 0; i < languageMapping.length; i++) {
      final data = languageMapping.entries.elementAt(i);

      if (data.key == text) {
        languageMapres.value = data.value;
        print(data.value);
      }
    }
  }
}
// final legalDocuments = <LegalDocument>[].obs;
// void fetchAnlysisedData() async {
//   try {
//     final analysisRes = await supabase.useSchema(ApiConst.analysisSchema).from("document_analysis").select().eq("id", queryId.value);
//     final res = analysisRes as List;
//     legalDocuments.value = res.map((json) => LegalDocument.fromJson(json)).toList();
//     if (kDebugMode) {
//       print(jsonEncode(analysisRes));
//     }
//   } catch (e) {
//     if (kDebugMode) {
//       print(e);
//     }
//   }
// }
