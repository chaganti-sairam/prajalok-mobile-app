import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:prajalok/app/utils/compnent/module_top_lebel.dart';
import 'package:prajalok/app/utils/compnent/upload_file.dart';
import 'package:prajalok/app/utils/icons_const.dart';
import 'package:prajalok/app/utils/widgetButton.dart';
import 'package:prajalok/app/utils/widget_const.dart';
import 'package:r_dotted_line_border/r_dotted_line_border.dart';
import '../controllers/document_transalator_controller.dart';
import 'recent_doc_transaltor.dart';

class DocumentTransalatorView extends GetView<DocumentTransalatorController> {
  DocumentTransalatorView({Key? key}) : super(key: key);
  final documentTranalatorC = Get.put(DocumentTransalatorController(), permanent: false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onActionPressed: () {
          RecentDocTranslatorSheet(context);
        },
        title: 'Document translator',
        actionIcon: SvgPicture.asset(SvgIcons.recentlyicons),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Column(
              children: <Widget>[
                buildTopBar(
                  SvgIcons.maintenance,
                  'Translate',
                  'documents of any language into English.',
                ),

                const SizedBox(height: 16),

                Obx(() {
                  return FileUploadSection(
                    maxFiles: 1,
                    onFilePickerTap: () {
                      documentTranalatorC.filepicker2();
                    },
                    onCameraTap: () {
                      documentTranalatorC.takeSnapshot();
                    },
                    onScannerTap: () {},
                    files: documentTranalatorC.files.length,
                  );
                }),

                // WidgetButtonPress(
                //   child: GestureDetector(
                //     onTap: () {
                //       if (documentTranalatorC.files.length == 1) {
                //         Get.snackbar(
                //             icon: SvgPicture.asset(SvgIcons.snakbarInfo),
                //             "Info",
                //             "The maximum limit has been reached you can modify your files by removing one");
                //       } else {
                //         Get.bottomSheet(CustomBottomSheet(
                //           onFilePickerTap: () {
                //             documentTranalatorC.filepicker2();
                //           },
                //           onCameraTap: () {
                //             documentTranalatorC.takeSnapshot();
                //           },
                //           onScannerTap: () {},
                //         ));
                //       }
                //     },
                //     child: Container(
                //       height: 123,
                //       width: Get.width,
                //       decoration: BoxDecoration(
                //         border: RDottedLineBorder.all(
                //           color: AppColors.textcolor,
                //           width: 1,
                //         ),
                //         borderRadius: BorderRadius.circular(12),
                //       ),
                //       child: const Column(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: <Widget>[
                //           Padding(
                //             padding: EdgeInsets.only(bottom: 5),
                //             child: Icon(
                //               Icons.add_circle_outline_outlined,
                //               size: 30,
                //               color: AppColors.textcolor,
                //             ),
                //           ),
                //           Text(
                //             "Upload Files (s)",
                //             style: TextStyle(fontSize: 14, color: AppColors.textcolor),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),

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
                  if (documentTranalatorC.files.isEmpty) {
                    return const SizedBox();
                  }
                  return Container(
                    width: Get.width,
                    height: 200,
                    decoration: const BoxDecoration(),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 0, top: 5, right: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(
                                child: Text(
                                  'Uploaded Files:',
                                  style: TextStyle(
                                    color: Color(0xFF404040),
                                    fontSize: 16,
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Container(
                                  height: 20,
                                  width: 30,
                                  decoration: BoxDecoration(color: AppColors.greenHalf, borderRadius: BorderRadius.circular(50)),
                                  child: Center(
                                    child: Text(
                                      '1/${documentTranalatorC.files.length}',
                                      style: TextStyle(
                                        color: AppColors.greenColor,
                                        fontSize: 12,
                                        fontFamily: 'Open Sans',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Obx(() {
                            return ListView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemCount: documentTranalatorC.files.length,
                                itemBuilder: (_, i) {
                                  return Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Card(
                                          elevation: 0.5,
                                          color: AppColors.hlfgrey,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Padding(
                                                  padding: const EdgeInsets.only(left: 8),
                                                  child: Row(
                                                    children: [
                                                      documentTranalatorC.files[i] != null && documentTranalatorC.files[i]!.isNotEmpty
                                                          ? SvgPicture.asset(
                                                              (documentTranalatorC.files[i]!.split('.')?.last == 'pdf')
                                                                  ? SvgIcons.pdfIcons
                                                                  : SvgIcons.jpgIcons,
                                                              height: 20,
                                                              width: 20,
                                                              fit: BoxFit.fill,
                                                            )
                                                          : const SizedBox(),
                                                      // const SizedBox(
                                                      //   width: 5,
                                                      // ),
                                                      SizedBox(
                                                        width: 200,
                                                        child: Text(
                                                          documentTranalatorC.files[0] ?? "",
                                                          overflow: TextOverflow.ellipsis,
                                                          softWrap: false,
                                                          maxLines: 1,
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                              IconButton(
                                                  onPressed: () {
                                                    documentTranalatorC.files.remove(documentTranalatorC.files[i]);
                                                    documentTranalatorC.files.refresh();
                                                  },
                                                  icon: const Icon(
                                                    Icons.close,
                                                    color: AppColors.closeIconColor,
                                                    size: 20,
                                                  )),
                                            ],
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(left: 8),
                                          child: Row(
                                            children: <Widget>[
                                              // Obx(() => Text(
                                              //       controller.checkFileModel.value.isEnglish ? 'Pages limit exceeded' : "",
                                              //       style: TextStyle(
                                              //         color: AppColors.invalidColor,
                                              //         fontSize: 10,
                                              //         fontFamily: 'Open Sans',
                                              //         fontWeight: FontWeight.w400,
                                              //       ),
                                              //     )),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              // Obx(() => Text(
                                              //       !controller.checkFileModel.value.isEnglish ? 'File is already in English' : "",
                                              //       style: TextStyle(
                                              //         color: AppColors.invalidColor,
                                              //         fontSize: 10,
                                              //         fontFamily: 'Open Sans',
                                              //         fontWeight: FontWeight.w400,
                                              //       ),
                                              //     )),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          }),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          const Expanded(child: SizedBox()),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: WidgetButtonPress(
                child: ReusableGradientButton(
              width: 250,
              height: 48,
              onPressed: () async {
                // documentTranalatorC.showStatusDialog();
                if (documentTranalatorC.files.isNotEmpty) {
                  Get.dialog(
                    AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      content: SizedBox(
                        height: 200,
                        child: Obx(() {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: AppColors.textcolor,
                                child: Text(
                                  "${documentTranalatorC.files.length}/1",
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Text("Analyzing File"),
                              ),
                              SizedBox(
                                height: 30,
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: const Color(0xFFFFEDEA),
                                    ),
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        controller.files[0] != null && controller.files[0]!.isNotEmpty
                                            ? SvgPicture.asset(
                                                (controller.files[0]!.split('.')?.last == 'pdf') ? SvgIcons.pdfIcons : SvgIcons.jpgIcons,
                                                height: 20,
                                                width: 20,
                                                fit: BoxFit.fill,
                                              )
                                            : const SizedBox(),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Flexible(
                                          child: Text(
                                            controller.files[0],
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ],
                                    )),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  controller.isLoading.value
                                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator())
                                      : SizedBox(
                                          height: 20,
                                          width: 20,
                                          child:
                                              //  decodedResponse[
                                              //             "is_page_limit"] ==
                                              controller.isPageLismit.value == false
                                                  ? SvgPicture.asset(SvgIcons.cllosedFilled)
                                                  : SvgPicture.asset(SvgIcons.chekboxfilled),
                                        ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text(
                                    "Less than 40 pages",
                                    style: TextStyle(
                                      color: Color(0xFF505050),
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Open Sans',
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  //  decodedResponse["is_english"] == null
                                  controller.isLoading.value
                                      ? const SizedBox(
                                          height: 20, width: 20, child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator()))
                                      : SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: controller.isEnglish.value == true
                                              // decodedResponse["is_english"] == true
                                              ? SvgPicture.asset(SvgIcons.cllosedFilled)
                                              : SvgPicture.asset(SvgIcons.chekboxfilled),
                                        ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text(
                                    "Language is in English",
                                    style: TextStyle(
                                      color: Color(0xFF505050),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Open Sans',
                                    ),
                                  )
                                ],
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  );
                  bool? res = await controller.checkFile();
                  if (res != null) {
                    if (!controller.checkFileModel.value.isEnglish && controller.checkFileModel.value.isPageLimit) {
                      Get.back();
                      final getcreditres = controller.getCredit();
                    }
                  }
                } else {
                  Get.snackbar(icon: const Icon(Icons.warning), "Warning", "Please Upload a file to translate");
                }
              },
              gradient: AppColors.linearGradient,
              child: const Text(
                "Translate",
                style: buttonTextStyle,
              ),
            )),
          ),
        ],
      ),
    );
  }
}

//? botttom sheet

 