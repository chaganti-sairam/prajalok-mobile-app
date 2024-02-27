import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:prajalok/app/data/serlization/newCheckFileModel.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:prajalok/app/utils/compnent/module_top_lebel.dart';
import 'package:prajalok/app/utils/customer_loading.dart';
import 'package:prajalok/app/utils/icons_const.dart';
import 'package:prajalok/app/utils/re_usable_class.dart';
import 'package:prajalok/app/utils/widgetButton.dart';
import 'package:prajalok/app/utils/widget_const.dart';
import 'package:r_dotted_line_border/r_dotted_line_border.dart';
import '../controllers/document_write_controller.dart';

class DocumentWriteView extends GetView<DocumentWriteController> {
  DocumentWriteView({Key? key}) : super(key: key);
  final documentWriterController = Get.put(DocumentWriteController());
  ReUsableService fileUploadService = ReUsableService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onActionPressed: () {
          documentWriterController.moveToStepersPage();
          // documentWriterController.moveToStepersPage1();
          // Get.to(DocWriterStepeps());
          // RecentDocWriter(context);
        },
        actionIcon: SvgPicture.asset(SvgIcons.recentlyicons),
        title: 'Document writer',
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: <Widget>[
                    buildTopBar(
                      SvgIcons.documentwriter,
                      'Draft any legal document',
                      'effortlessly through easy steps.',
                    ),
                    TextFormField(
                      onTapOutside: (event) {
                        if (kDebugMode) {
                          print('onTapOutside');
                        }
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: documentWriterController.isFocused.value ? AppColors.textcolor : AppColors.disableColor, width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: 'Type of agreement',
                        filled: false,
                        contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                      ),
                      controller: documentWriterController.searchController,
                      onTap: () {
                        documentWriterController.bottomSheetFilterList();
                      },
                    ),
                    const SizedBox(height: 16),
                    Obx(() {
                      return Container(
                        height: 117,
                        padding: const EdgeInsets.all(12),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              color: documentWriterController.isFocused.value ? AppColors.textcolor : AppColors.disableColor,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: TextFormField(
                          onTapOutside: (event) {
                            if (kDebugMode) {
                              print('onTapOutside');
                            }
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          focusNode: documentWriterController.focusNode,
                          controller: documentWriterController.docSummryContrller.value,
                          onChanged: (value) {
                            documentWriterController.docSummryContrller.refresh();
                          },
                          keyboardType: TextInputType.multiline,
                          maxLength: 2000,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText: "details and summary about the case to write legal document",
                            hintStyle: TextStyle(
                              color: Color(0xFFBFBFBF),
                              fontSize: 14,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w400,
                            ),
                            border: InputBorder.none,
                            // counter: SizedBox.shrink(),
                            contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                    WidgetButtonPress(
                      child: GestureDetector(
                          onTap: () {
                            controller.fileCheckResults.clear();
                            if (documentWriterController.files.length < 5) {
                              Get.bottomSheet(CustomBottomSheet(
                                onFilePickerTap: () {
                                  if (documentWriterController.files.length < 5) {
                                    documentWriterController.filepickerDocWriter();
                                  } else {
                                    Get.snackbar("Warning", "Maximum 5 file(s) can be uploaded");
                                  }
                                },
                                onCameraTap: () {
                                  controller.fileCheckResults.clear();
                                },
                                onScannerTap: () {},
                              ));
                            } else {
                              Get.snackbar("file limit ", "Maiximum 5 files ");
                            }
                          },
                          child: SizedBox(
                              height: 125,
                              width: Get.width,
                              child: DottedBorder(
                                strokeCap: StrokeCap.square,
                                radius: const Radius.circular(12),
                                dashPattern: const [10, 8],
                                borderType: BorderType.RRect,
                                color: AppColors.textcolor,
                                strokeWidth: 1.5,
                                child: const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 5),
                                        child: Icon(
                                          Icons.add_circle_outline_outlined,
                                          size: 30,
                                          color: AppColors.textcolor,
                                        ),
                                      ),
                                      Text(
                                        "Upload Files (s)",
                                        style: TextStyle(fontSize: 14, color: AppColors.textcolor),
                                      ),
                                    ],
                                  ),
                                ),
                              ))),
                    ),
                    const UploadInstructions(
                      title: 'Upload instructions',
                      instructions: [
                        'Supports all major file formats',
                        'Preferred in English language',
                        'Maximum 5 file(s) can be uploaded',
                        'Please ensure the document contains fewer than 40 pages',
                      ],
                    ),
                    Obx(() {
                      if (documentWriterController.files.isEmpty) {
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
                                      '${documentWriterController.files.length}/5',
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
                                itemCount: documentWriterController.files.length,
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
                                                    if (documentWriterController.files[i].path.isNotEmpty)
                                                      SvgPicture.asset(
                                                        getFileIconPath(documentWriterController.files[i].path),
                                                        height: 20,
                                                        width: 20,
                                                        fit: BoxFit.fill,
                                                      ),
                                                    const SizedBox(width: 5),
                                                    SizedBox(
                                                      width: 200,
                                                      child: Text(
                                                        documentWriterController.files[i].path
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
                                                  documentWriterController.files.remove(documentWriterController.files[i]);
                                                  documentWriterController.files.refresh();
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
                                          if (documentWriterController.fileCheckResults.isNotEmpty &&
                                              i < documentWriterController.fileCheckResults.length) {
                                            fileChekRes = documentWriterController.fileCheckResults[i];
                                          }
                                          return FileCheckRow(
                                            fileCheckResults: documentWriterController.fileCheckResults,
                                            index: i,
                                            onPressed: () {
                                              documentWriterController.selectedIndex.value = i;
                                              fileUploadService.getCredit(
                                                moduleId: documentWriterController.docWriterModuleID.value,
                                                uuid: documentWriterController.uuid.toString(),
                                                folderPath: 'docwriter',
                                                localFilePath: documentWriterController.files[i].path,
                                              );
                                            },
                                            files: documentWriterController.files,
                                            outputDocUrl: fileUploadService.outputDocUrl.value,
                                            i: i,
                                            selectedIndex: documentWriterController.selectedIndex.value,
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
                    })
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
                  controller.fileCheckResults.clear();
                  documentWriterController.clearCheckFileDocWriter();
                  if (documentWriterController.files.isEmpty && documentWriterController.docSummryContrller.value.text.isEmpty) {
                    Get.snackbar(
                      "Warning",
                      "Kindly provide text or upload files input to proceed",
                      icon: Icon(Icons.info, color: AppColors.invalidColor),
                      shouldIconPulse: true,
                    );
                  } else if (documentWriterController.files.isEmpty) {
                    Get.snackbar("Info", "Please provide at least 1000 characters text input to proceed or upload files",
                        icon: const Icon(Icons.info));
                  } else if (documentWriterController.docSummryContrller.value.text.length < 100) {
                    Get.snackbar("Info", "Please provide at least 100 characters text input to proceed", icon: const Icon(Icons.info));
                  } else {
                    Get.dialog(
                      Obx(() {
                        return FileCheckingDialog(
                          length: controller.files.length,
                          filePath: controller.paths.value,
                          isPageLimit: controller.docriterfileCheckModel.value.isPageLimit,
                          isEnglish: documentWriterController.docriterfileCheckModel.value.isEnglish,
                          isLegal: documentWriterController.docriterfileCheckModel.value.isLegal,
                          isReadable: documentWriterController.docriterfileCheckModel.value.isReadable,
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
                        Future.delayed(Duration.zero, () {
                          Get.back();
                        });
                      }
                      if (kDebugMode) {
                        print("allConditionsMet $allConditionsMet");
                      }
                    }
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
