import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prajalok/app/data/serlization/newCheckFileModel.dart';
import 'package:prajalok/app/modules/document_chat/views/recent_doc_Chat.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:prajalok/app/utils/compnent/module_top_lebel.dart';
import 'package:prajalok/app/utils/compnent/upload_file.dart';
import 'package:prajalok/app/utils/customer_loading.dart';
import 'package:prajalok/app/utils/icons_const.dart';
import 'package:prajalok/app/utils/re_usable_class.dart';
import 'package:prajalok/app/utils/widgetButton.dart';
import 'package:prajalok/app/utils/widget_const.dart';
import 'package:r_dotted_line_border/r_dotted_line_border.dart';
import '../controllers/document_chat_controller.dart';
import 'package:dotted_border/dotted_border.dart';

// ignore: must_be_immutable
class DocumentChatView extends GetView<DocumentChatController> {
  DocumentChatView({Key? key}) : super(key: key);
  final docChatController = Get.put((DocumentChatController()));
  ReUsableService fileUploadService = ReUsableService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            // Get.to(() => DocReferanceChat());
            // Get.to(DocReferanceChat());
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: const Text(
          'Document chat',
          style: TextStyle(
            color: AppColors.blacktxtColor,
            fontWeight: FontWeight.w600,
            fontFamily: 'Open Sans',
            fontSize: 18,
          ),
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.all(8),
              child: IconButton(
                onPressed: () {
                  RecentDocChatSheet(context);
                },
                icon: const Icon(
                  Icons.schedule_outlined,
                  color: AppColors.blacktxtColor,
                  size: 24,
                ),
              ))
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    buildTopBar(
                      SvgIcons.docChat,
                      'Ask questions,',
                      'seek insights, and get responses related to your case.',
                    ),
                    Obx(() => Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              width: 1,
                              color: controller.myFocusNode.value.hasFocus ? AppColors.textcolor : const Color(0xFFCFCFCF),
                            ),
                          ),
                          child: Column(
                            children: <Widget>[
                              Obx(() => TextFormField(
                                    onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
                                    focusNode: controller.myFocusNode.value,
                                    controller: docChatController.contextController.value,
                                    keyboardType: TextInputType.multiline,
                                    onChanged: (_) => docChatController.contextController.refresh(),
                                    maxLength: 80,
                                    maxLines: 2,
                                    decoration: InputDecoration(
                                      hintText: "Describe about the case and provide background to begin chat.",
                                      hintStyle: GoogleFonts.openSans(
                                        //fontFamily: 'Open Sans',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.hintColor,
                                      ),
                                      border: InputBorder.none,
                                      counter: SizedBox.shrink(),
                                      contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                                    ),
                                    onTap: () => controller.requestFocus(context),
                                  )),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Obx(() => Text(
                                        '${docChatController.contextController.value.text.length}/80',
                                        textAlign: TextAlign.right,
                                        style: const TextStyle(
                                          color: Color(0xFF8F8F8F),
                                          fontSize: 12,
                                          fontFamily: 'Open Sans',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )),
                                ),
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(height: 16),

                    // File uploading Section here
                    Obx(() {
                      return FileUploadSection(
                        maxFiles: 5,
                        onFilePickerTap: () {
                          docChatController.filepickerDocChat();
                        },
                        onCameraTap: () {},
                        onScannerTap: () {},
                        files: docChatController.files.length,
                      );
                    }),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      child: UploadInstructions(
                        title: 'Upload instructions',
                        instructions: [
                          'Supports all major file formats',
                          'Preferred in English language',
                          'Maximum 2 file(s) can be uploaded',
                          'Please ensure the document contains fewer than 40 pages',
                        ],
                      ),
                    ),
                    Obx(() {
                      if (docChatController.files.isEmpty) {
                        return const SizedBox();
                      }
                      return Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 12, top: 8, right: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Uploaded Files:',
                                  style: TextStyle(
                                    color: Color(0xFF404040),
                                    fontSize: 16,
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Container(
                                  height: 20,
                                  width: 30,
                                  decoration: BoxDecoration(color: AppColors.greenHalf, borderRadius: BorderRadius.circular(50)),
                                  child: Center(
                                    child: Text(
                                      '${docChatController.files.length}/5',
                                      style: TextStyle(
                                        color: AppColors.greenColor,
                                        fontSize: 12,
                                        fontFamily: 'Open Sans',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Obx(() {
                            return SizedBox(
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemCount: docChatController.files.length,
                                itemBuilder: (_, i) {
                                  return Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Card(
                                          elevation: 0.5,
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(color: Colors.white70, width: 1),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          color: AppColors.hlfgrey,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(left: 8),
                                                child: Row(
                                                  children: [
                                                    if (docChatController.files[i].path.isNotEmpty)
                                                      SvgPicture.asset(
                                                        getFileIconPath(docChatController.files[i].path),
                                                        height: 20,
                                                        width: 20,
                                                        fit: BoxFit.fill,
                                                      ),
                                                    const SizedBox(width: 5),
                                                    SizedBox(
                                                      width: 200,
                                                      child: Text(
                                                        docChatController.files[i].path
                                                            .replaceAll("/data/user/0/com.example.prajalok/cache/file_picker/", ""),
                                                        overflow: TextOverflow.ellipsis,
                                                        softWrap: false,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  docChatController.files.remove(docChatController.files[i]);
                                                  docChatController.files.refresh();
                                                },
                                                icon: const Icon(
                                                  Icons.close,
                                                  color: AppColors.closeIconColor,
                                                  size: 20,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Obx(() {
                                          FileCheckModel? fileChekRes;
                                          if (docChatController.fileCheckResults.isNotEmpty && i < docChatController.fileCheckResults.length) {
                                            fileChekRes = docChatController.fileCheckResults[i];
                                          }
                                          return FileCheckRow(
                                            fileCheckResults: docChatController.fileCheckResults,
                                            index: i,
                                            onPressed: () {
                                              docChatController.selectedIndex.value = i;
                                              fileUploadService.getCredit(
                                                moduleId: docChatController.docChatModuleId.value,
                                                uuid: docChatController.uuid.toString(),
                                                folderPath: 'docChat',
                                                localFilePath: docChatController.files[i].path,
                                              );
                                            },
                                            files: docChatController.files,
                                            outputDocUrl: fileUploadService.outputDocUrl.value,
                                            i: i,
                                            selectedIndex: docChatController.selectedIndex.value,
                                          );
                                        }),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          }),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),

          // ?? Widget Button start here --------
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: WidgetButtonPress(
              child: ReusableGradientButton(
                width: 250,
                height: 48,
                onPressed: () async {
                  controller.clear();
                  controller.fileCheckResults.clear();
                  if (docChatController.files.isNotEmpty) {
                    Get.dialog(
                      Obx(() {
                        return FileCheckingDialog(
                          length: controller.files.length,
                          filePath: controller.paths.value,
                          isPageLimit: controller.docChatfileCheckModel.value.isPageLimit,
                          isEnglish: docChatController.docChatfileCheckModel.value.isEnglish,
                          isLegal: docChatController.docChatfileCheckModel.value.isLegal,
                          isReadable: docChatController.docChatfileCheckModel.value.isReadable,
                        );
                      }),
                    );
                    bool? res = await controller.checkFile();
                    if (res != null) {
                      var allConditionsMet = controller.fileCheckResults
                          .every((res) => res.isEnglish == true && res.isLegal == true && res.isReadable == true && res.isPageLimit == true);
                      if (allConditionsMet) {
                        controller.getCredit();
                      } else {
                        Future.delayed(const Duration(seconds: 2), () {
                          Get.back();
                        });
                      }
                      print("allConditionsMet $allConditionsMet");
                    }
                  } else {
                    Get.snackbar(icon: const Icon(Icons.warning), "Warning", "Please Upload a file to doc Chat");
                  }
                },
                gradient: AppColors.linearGradient,
                child: const Text(
                  "Start",
                  style: buttonTextStyle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
