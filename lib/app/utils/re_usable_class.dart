import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:prajalok/app/data/serlization/newCheckFileModel.dart';
import 'package:prajalok/app/modules/document_chat/views/subscription_plans.dart';
import 'package:prajalok/app/utils/api_const.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:prajalok/app/utils/customer_loading.dart';
import 'package:prajalok/app/utils/icons_const.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../data/serlization/module.dart';

class ReUsableService {
  List<File> files = [];
  final RxString inputDocUrl = "".obs;
  final RxString outputDocUrl = "".obs;

  final RxInt queryId = 0.obs;

  // Future<void> takeSnapshot() async {
  //   try {
  //     final ImagePicker picker = ImagePicker();
  //     final XFile? img = await picker.pickImage(
  //       source: ImageSource.camera,
  //     );

  //     if (img != null) {
  //       Get.back();
  //       files.add(File(img.path));
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //   }
  // }

//  credit re-usable here
  Future<bool?> getCredit({
    required int moduleId,
    required uuid,
    required String folderPath,
    required String localFilePath,
  }) async {
    try {
      final res = await supabase.schema("billing").rpc("has_sufficient_credits", params: {
        'p_module_id': moduleId.toInt(),
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
              moduleId: moduleId.toInt(),
              uuid: uuid,
            );
            Get.dialog(const ReusableProcessingDialog());
            final res = await uploadFile(uuid: uuid, folderPath: folderPath, localFilePath: localFilePath);
            if (res != null) {
              print("publicUrl.valuepublicUrl.value ${inputDocUrl.value}");
              final response = await sendSupabse(inputDocUrl.value);
              if (response != null) {
                Get.back();
                supabase.schema(ApiConst.translateschema).from("translate").stream(primaryKey: ["id"]).eq('id', queryId).listen((data) {
                      if (data[0]['task_id'] != null) {
                        webSocketConnect(data[0]['task_id']);
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

  // file tranlate gloabal
  Future<bool?> uploadFile({
    required String uuid,
    required String folderPath,
    required String localFilePath,
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(ApiConst.gcsFileuploadUrl));
      request.fields.addAll({'bucket_name': "ld_user_bucket", 'gcs_folder_path': "$uuid/$folderPath", 'make_public': 'true'});
      request.files.add(await http.MultipartFile.fromPath('file_upload', localFilePath));
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        // Handle the public URL separately based on your use case
        var decodedResponse = jsonDecode(await response.stream.bytesToString());
        inputDocUrl.value = decodedResponse["public_url"];
        if (kDebugMode) {
          print("Public URL: $inputDocUrl");
        }
        return true;
      } else {
        if (kDebugMode) {
          print(response.reasonPhrase);
        }
        return false;
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error uploading file: $error');
      }
      return false;
    }
  }

  Future<bool?> sendSupabse(String inputDocUrl) async {
    try {
      final result = await supabase.schema(ApiConst.translateschema).from("translate").insert({
        "profile_id": supabase.auth.currentUser!.id,
        "input_doc_url": inputDocUrl.toString(),
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

  Future<dynamic> deductCredits({required int moduleId, uuid}) async {
    return supabase.schema("billing").rpc("deduct_user_credits", params: {
      "p_module_id": moduleId,
      "p_credits_to_deduct": 1,
      'p_profile_id': uuid,
    }).then((value) {
      return value;
    }).onError((error, stackTrace) {
      return {};
    });
  }

  fetchTranslatedData() async {
    try {
      final translatedresult = await supabase.schema(ApiConst.translateschema).from("translate").select().eq("id", queryId.value);
      if (kDebugMode) {
        print("translatedresulttranslatedresult $translatedresult");

        outputDocUrl.value = translatedresult[0]["output_doc_url"];
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  bool isDialogOpen = false;
  Map<String, dynamic> webSocketResponse = {};
  void webSocketConnect(taskid) {
    final wsUrl = Uri.parse("ws://redis-manager-yxfpjr3pvq-el.a.run.app/ws/$taskid");
    var channel = WebSocketChannel.connect(wsUrl);
    channel.stream.listen((message) {
      final data = jsonDecode(message);
      webSocketResponse = data;
      if (data["overall_status"] == true) {
        fetchTranslatedData();
      } else {
        if (!isDialogOpen) {
          isDialogOpen = true; // Set the flag to true
          showResponseWebSoketDialog(Get.context!, "Doc Translation", webSocketResponse);
          Future.delayed(const Duration(seconds: 5), () {
            isDialogOpen = false;
            Navigator.of(Get.context!).pop();
          });
        }
      }
      channel.sink.add('received!');
      if (kDebugMode) {
        print("webSocketMessage $message");
      }
    });
  }
}

void showResponseWebSoketDialog(BuildContext context, String? title, Map<String, dynamic>? response) {
  if (response == null || response["update_message"] == null) {
    const Text("web Socket Response is null");
    return;
  }
  if (response["overall_status"] == true) {
    Navigator.of(context).pop();
    return;
  }
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        titleTextStyle: const TextStyle(
          color: Color(0xFFFF5C40),
          fontSize: 20,
          fontFamily: 'Open Sans',
          fontWeight: FontWeight.w600,
        ),
        title: Text(
          '$title\nWe are processing',
          textAlign: TextAlign.center,
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List<Widget>.from(
              response["update_message"].entries.map((entry) {
                final Map<String, dynamic> message = entry.value;
                if (message == null || !message.containsKey("status") || !message.containsKey("label") || !message.containsKey("description")) {
                  return const SizedBox.shrink();
                }
                return ListTile(
                  titleTextStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Open Sans',
                    fontSize: 14,
                    color: Color(0xFF404040),
                  ),
                  subtitleTextStyle: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Open Sans',
                    fontSize: 14,
                    color: Color(0xFF404040),
                  ),
                  contentPadding: const EdgeInsets.all(0),
                  minLeadingWidth: 0,
                  leading: message["status"]
                      ? CircleAvatar(
                          radius: 12,
                          child: SvgPicture.asset(
                            SvgIcons.chekboxfilled,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const CircleAvatar(
                          radius: 10,
                          child: CircularProgressIndicator(
                            strokeWidth: 3.5,
                            color: AppColors.textcolor,
                            strokeAlign: BorderSide.strokeAlignInside,
                          ),
                        ),
                  title: Text(message["label"].toString()),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(message["description"].toString()),
                  ),
                );
              }),
            ),
          ),
        ),
      );
    },
  );
}

class FileCheckRow extends StatelessWidget {
  final int index;
  final List<FileCheckModel> fileCheckResults;
  final VoidCallback? onPressed;
  final int selectedIndex;
  final List<File> files;
  final String outputDocUrl;
  final int i;

  FileCheckRow({
    required this.index,
    required this.fileCheckResults,
    required this.onPressed,
    required this.selectedIndex,
    required this.files,
    required this.outputDocUrl,
    required this.i,
  });
  @override
  Widget build(BuildContext context) {
    FileCheckModel? getFileCheckResult(int index) {
      return (fileCheckResults.isNotEmpty && index < fileCheckResults.length) ? fileCheckResults[index] : null;
    }

    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Row(
        children: <Widget>[
          Obx(() {
            FileCheckModel? fileChekRes = getFileCheckResult(index);
            return fileCheckResults.isEmpty
                ? const SizedBox.shrink()
                : Text(
                    fileChekRes?.isPageLimit == null
                        ? ""
                        : fileChekRes?.isPageLimit == false
                            ? 'Pages count exceeded'
                            : "",
                    style: TextStyle(
                      color: AppColors.invalidColor,
                      fontSize: 10,
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.w400,
                    ),
                  );
          }),
          const SizedBox(width: 10),
          Obx(() {
            FileCheckModel? fileChekRes = getFileCheckResult(index);
            return fileCheckResults.isEmpty
                ? const SizedBox.shrink()
                : Text(
                    fileChekRes?.isEnglish == null
                        ? ""
                        : fileChekRes?.isEnglish == false
                            ? 'is not English language'
                            : fileChekRes?.isReadable == false
                                ? 'Not readable'
                                : fileChekRes?.isLegal == false
                                    ? 'Not legal'
                                    : fileChekRes?.isEnglish == false &&
                                            fileChekRes?.isReadable == false &&
                                            fileChekRes?.isLegal == false &&
                                            fileChekRes?.isPageLimit == false
                                        ? 'Incompatible language'
                                        : '',
                    style: TextStyle(
                      color: AppColors.invalidColor,
                      fontSize: 10,
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.w400,
                    ),
                  );
          }),
          const SizedBox(width: 10),
          Obx(() {
            FileCheckModel? fileChekRes;
            if (fileCheckResults.isNotEmpty && i < fileCheckResults.length) {
              fileChekRes = fileCheckResults[i];
            }
            if (fileCheckResults.isEmpty || fileChekRes == null) {
              return const SizedBox.shrink();
            }
            bool isEnglish = fileChekRes.isEnglish ?? false;
            if (!isEnglish && outputDocUrl.isNotEmpty) {
              Future.delayed(Duration.zero, () {
                File outputDocUrls = File(outputDocUrl);
                if (selectedIndex != -1) {
                  files.removeAt(selectedIndex);
                  files.insert(selectedIndex, outputDocUrls);
                }
              });
            }
            print("ddddddddddddd${fileChekRes.isPageLimit}");
            return fileChekRes.isEnglish == false &&
                    fileChekRes.isLegal == true &&
                    fileChekRes.isReadable == true &&
                    fileChekRes.isLegal == true &&
                    fileChekRes.isPageLimit == true
                ? SizedBox(
                    height: 20,
                    child: TextButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                        side: const BorderSide(color: AppColors.disableColor),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: onPressed,
                      child: const SizedBox(
                        height: 15,
                        child: Text(
                          "Translate",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF707070),
                            fontSize: 12,
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
