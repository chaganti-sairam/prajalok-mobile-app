import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prajalok/app/utils/api_const.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:prajalok/app/utils/customer_loading.dart';
import 'package:prajalok/app/utils/icons_const.dart';
import 'package:prajalok/app/utils/re_usable_class.dart';
import 'package:prajalok/app/utils/widgetButton.dart';
import 'package:prajalok/app/utils/widget_const.dart';
import 'package:r_dotted_line_border/r_dotted_line_border.dart';
import 'package:readmore/readmore.dart';
import '../controllers/document_write_controller.dart';

class MyFirstStep extends StatelessWidget {
  MyFirstStep({super.key});
  final documentWriterController = Get.put(DocumentWriteController());
  ReUsableService fileUploadService = ReUsableService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    children: <Widget>[
                      WidgetButtonPress(
                        child: GestureDetector(
                          onTap: () {
                            documentWriterController.fileCheckResults.clear();
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
                                  documentWriterController.takeSnapshotDocWriter();
                                },
                                onScannerTap: () {},
                              ));
                            } else {
                              Get.snackbar("file limit ", "Maiximum 5 files ");
                            }
                          },
                          child: Container(
                            height: 117,
                            width: Get.width,
                            decoration: BoxDecoration(
                              border: RDottedLineBorder.all(
                                color: AppColors.textcolor,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Column(
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
                                  "Upload reference file(s)",
                                  style: TextStyle(fontSize: 14, color: AppColors.textcolor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      //Instrudction widget here
                      const UploadInstructions(
                        title: 'Upload instructions',
                        instructions: [
                          'Supports all major file formats',
                          'Preferred in English language',
                          'Maximum 2 file(s) can be uploaded',
                          'Please ensure the document contains fewer than 40 pages',
                        ],
                      ),

                      // Reference rsponse here
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
                                  Text(
                                    'Reference Files:',
                                    style: GoogleFonts.openSans(
                                      color: AppColors.blacktxtColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: AppColors.greenHalf,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${documentWriterController.files.length}/5',
                                        style: GoogleFonts.openSans(
                                          color: AppColors.greenColor,
                                          fontSize: 12,
                                          //  fontFamily: 'Open Sans',
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
                                            if (documentWriterController.fileCheckResults.isNotEmpty &&
                                                i < documentWriterController.fileCheckResults.length) {}
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
                      }),

                      // close uploaded files
                      Obx(() {
                        if (documentWriterController.docWriterDocGenerationModel.isEmpty) {
                          return const SizedBox();
                        } else {
                          Set<dynamic> uniqueItems = {};
                          for (var result in documentWriterController.docWriterDocGenerationModel) {
                            uniqueItems.addAll(result.recommendedDocUrls ?? []);
                          }
                          List<dynamic> uniqueData = uniqueItems.toList();
                          documentWriterController.referancedata.assignAll(uniqueData);
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
                                          '${documentWriterController.referancedata.length}/5',
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
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                ),
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: documentWriterController.referancedata.length,
                                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                                  itemBuilder: (context, index) {
                                    final ref = documentWriterController.referancedata[index];
                                    return Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: AppColors.hlfgrey,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Theme(
                                        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                        child: ExpansionTile(
                                          expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
                                          initiallyExpanded: false,
                                          maintainState: true,
                                          onExpansionChanged: (value) {
                                            documentWriterController.expansionchnage(value);
                                          },
                                          title: Text(
                                            "${ref.caseTitle}",
                                            style: const TextStyle(
                                              color: Color(0xFFFF5C40),
                                              fontSize: 13,
                                              fontFamily: 'Open Sans',
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          trailing: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Obx(
                                                () => documentWriterController.isExpanded.value
                                                    ? const Icon(
                                                        Icons.keyboard_arrow_up,
                                                        size: 20,
                                                        color: AppColors.textcolor,
                                                      )
                                                    : const Icon(
                                                        Icons.keyboard_arrow_down,
                                                        size: 20,
                                                        color: AppColors.blacktxtColor,
                                                      ),
                                              ),
                                              IconButton(
                                                splashRadius: 2,
                                                icon: const Icon(
                                                  Icons.close,
                                                  color: AppColors.blacktxtColor,
                                                  size: 20,
                                                ),
                                                onPressed: () {
                                                  documentWriterController.referancedata.removeAt(index);
                                                },
                                              ),
                                            ],
                                          ),
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(left: 20, bottom: 10, right: 20),
                                              child: ReadMoreText(
                                                '${ref.judgementSummary}'.replaceAll(RegExp(r'[^\w\s]+'), ""),
                                                trimLines: 4,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'Open Sans',
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xFF505050),
                                                  letterSpacing: 0.50,
                                                ),
                                                textAlign: TextAlign.justify,
                                                colorClickableText: Colors.pink,
                                                trimMode: TrimMode.Line,
                                                trimCollapsedText: 'Show more',
                                                trimExpandedText: 'Show less',
                                                moreStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textcolor),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        }
                      }),
                    ],
                  ),
                ),
              ),
            ),

            // ?? Widget Button start here --------

            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16),
              color: AppColors.hlfgrey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ReusableGradienOutlinedtButton(
                    width: 200,
                    height: 45,
                    color: AppColors.textcolor,
                    onPressed: () async {
                      Get.dialog(
                        const ReusableProcessingDialog(),
                      );
                      bool? res = await documentWriterController.postReferences();
                      if (res != null) {
                        supabase
                            .schema(ApiConst.templatecshema)
                            .from("doc_generations")
                            .stream(primaryKey: ["id"])
                            .eq('id', documentWriterController.readId() ?? 0)
                            .listen((data) {
                              if (data[0]['task_id'] != null) {
                                documentWriterController.webSocketgetRefernces(data[0]['task_id']);
                              }
                            });
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SvgPicture.asset(
                          SvgIcons.wandIcons,
                          color: AppColors.textcolor,
                          height: 16,
                          width: 16,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Get reference files",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.openSans(
                            fontSize: 16,
                            //  fontFamily: 'Open Sans',
                            fontWeight: FontWeight.w600,
                            color: AppColors.textcolor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // filecheck result
                  ReusableGradientButton(
                    width: 112,
                    height: 38,
                    onPressed: () async {
                      documentWriterController.fileCheckResults.clear();
                      documentWriterController.clearCheckFileDocWriter();
                      if (documentWriterController.files.isEmpty) {
                        Get.snackbar(
                          "Warning",
                          "Kindly provide text or upload files input to proceed",
                          icon: Icon(Icons.info, color: AppColors.invalidColor),
                          shouldIconPulse: true,
                        );
                      }
                      Get.dialog(
                        Obx(() {
                          return FileCheckingDialog(
                            length: documentWriterController.files.length,
                            filePath: documentWriterController.paths.value,
                            isPageLimit: documentWriterController.docriterfileCheckModel.value.isPageLimit,
                            isEnglish: documentWriterController.docriterfileCheckModel.value.isEnglish,
                            isLegal: documentWriterController.docriterfileCheckModel.value.isLegal,
                            isReadable: documentWriterController.docriterfileCheckModel.value.isReadable,
                          );
                        }),
                      );
                      bool? res = await documentWriterController.checkFile();
                      if (res != null) {
                        var allConditionsMet = documentWriterController.fileCheckResults
                            .every((res) => res.isEnglish == true && res.isLegal == true && res.isReadable == true && res.isPageLimit == true);
                        if (allConditionsMet) {
                          documentWriterController.getReferfenaces();
                        } else {
                          Get.back();
                        }
                        if (kDebugMode) {
                          print("allConditionsMet $allConditionsMet");
                        }
                      }
                    },
                    gradient: AppColors.linearGradient,
                    child: const Text(
                      "Start",
                      textAlign: TextAlign.center,
                      style: buttonTextStyle,
                    ),
                  ),

                  // ReusableGradientButton(
                  //   width: 112,
                  //   height: 38,
                  //   onPressed: () async {
                  //     if (documentWriterController.files.isEmpty) {
                  //       Get.snackbar("Info", "Please upload files",
                  //           icon: const Icon(Icons.info));
                  //     } else {
                  //       // Get.dialog(
                  //       //   Obx(
                  //       //     () => FileCheckingDialog(
                  //       //       filePath:
                  //       //           documentWriterController.paths.value,
                  //       //       isPageLimit: documentWriterController
                  //       //           .docriterfileCheckModel.value.isPageLimit,
                  //       //       isEnglish: documentWriterController
                  //       //           .docriterfileCheckModel.value.isEnglish,
                  //       //       isLegal: documentWriterController
                  //       //           .docriterfileCheckModel.value.isLegal,
                  //       //       isReadable: documentWriterController
                  //       //           .docriterfileCheckModel.value.isReadable,
                  //       //     ),
                  //       //   ),
                  //       // );
                  //       // await documentWriterController
                  //       //     .checkMultipleFilesRef();
                  //       // List<FileCheckModel> fileCheckResultsRef = [];
                  //       // //var result = await documentWriterController.checkSingleFilRef(file);
                  //       // if (documentWriterController.decodedResponse1 !=
                  //       //     null) {
                  //       //   var fileCheckResult = FileCheckModel(
                  //       //     isEnglish: documentWriterController
                  //       //         .fileCheckModelRef.value.isEnglish,
                  //       //     isPageLimit: documentWriterController
                  //       //         .fileCheckModelRef.value.isPageLimit,
                  //       //     isLegal: documentWriterController
                  //       //         .fileCheckModelRef.value.isLegal,
                  //       //     isReadable: documentWriterController
                  //       //         .fileCheckModelRef.value.isReadable,
                  //       //   );
                  //       //   fileCheckResultsRef.add(fileCheckResult);
                  //       //   if (documentWriterController.decodedResponse1 !=
                  //       //       null) {
                  //       //     Get.snackbar(
                  //       //         "File Check Failed", "File check failed");
                  //       //   }
                  //       // }
                  //       // var allConditionsMet = fileCheckResultsRef.every(
                  //       //   (result) =>
                  //       //       result.isEnglish == true &&
                  //       //       result.isPageLimit == true &&
                  //       //       result.isLegal == true &&
                  //       //       result.isReadable == true,
                  //       // );
                  //       // if (allConditionsMet) {
                  //       //   documentWriterController.getReferfenaces();
                  //       //   // Proceed with further processing if all conditions are true
                  //       // } else {
                  //       //   // Handle the case where any condition is false
                  //       //   documentWriterController.isLoading.value = false;
                  //       //   Get.snackbar("File Check Failed",
                  //       //       "One or more conditions are false. Please check your files.");
                  //       // }
                  //     }
                  //   },
                  //   gradient: AppColors.linearGradient,
                  //   child: const Text(
                  //     textAlign: TextAlign.center,
                  //     "Proceed",
                  //     style: buttonTextStyle,
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
