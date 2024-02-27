import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:prajalok/app/utils/compnent/module_top_lebel.dart';
import 'package:prajalok/app/utils/compnent/upload_file.dart';
import 'package:prajalok/app/utils/customeSnackbar.dart';
import 'package:prajalok/app/utils/customer_loading.dart';
import 'package:prajalok/app/utils/icons_const.dart';
import 'package:prajalok/app/utils/widgetButton.dart';
import 'package:prajalok/app/utils/widget_const.dart';
import 'package:r_dotted_line_border/r_dotted_line_border.dart';
import '../controllers/legal_issue_spotter_controller.dart';
import 'leagl_issue _recent.dart';

class LegalIssueSpotterView extends GetView<LegalIssueSpotterController> {
  LegalIssueSpotterView({Key? key}) : super(key: key);
  final leagalIssueController = Get.put(LegalIssueSpotterController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onActionPressed: () {
          RecentContractAnalysisSheet(context);
          // Get.to(LegalIssueSpotterResult());
          //  RecentDocAnalysisSheet(context);
        },
        title: 'Legal issue spotter',
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
                  'Detect',
                  'ambiguities, discrepancies, or npotential risks in legal documents.',
                ),
                const SizedBox(height: 16),
                Obx(() {
                  return FileUploadSection(
                    maxFiles: 1,
                    onFilePickerTap: () {
                      leagalIssueController.docAnlysisfilepicker();
                    },
                    onCameraTap: () {
                      leagalIssueController.takeSnapshot();
                    },
                    onScannerTap: () {},
                    files: leagalIssueController.pickedFile.length,
                  );
                }),
                const UploadInstructions(
                  title: 'Upload instructions',
                  instructions: [
                    'Supports all major file formats',
                    'Preferred in English language',
                    'Maximum 2 file(s) can be uploaded',
                    'Please ensure the document contains fewer than 40 pages',
                  ],
                ),
                Obx(() {
                  if (leagalIssueController.pickedFile.isEmpty) {
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
                                      '1/${leagalIssueController.pickedFile.length}',
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
                                itemCount: leagalIssueController.pickedFile.length,
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
                                                      leagalIssueController.pickedFile[i] != null && leagalIssueController.pickedFile[i]!.isNotEmpty
                                                          ? SvgPicture.asset(
                                                              (leagalIssueController.pickedFile[i]!.split('.')?.last == 'pdf')
                                                                  ? SvgIcons.pdfIcons
                                                                  : SvgIcons.jpgIcons,
                                                              height: 20,
                                                              width: 20,
                                                              fit: BoxFit.fill,
                                                            )
                                                          : const SizedBox(),
                                                      SizedBox(
                                                        width: 200,
                                                        child: Text(
                                                          leagalIssueController.pickedFile[0] ?? "",
                                                          overflow: TextOverflow.ellipsis,
                                                          softWrap: false,
                                                          maxLines: 1,
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                              IconButton(
                                                  onPressed: () {
                                                    leagalIssueController.pickedFile.remove(controller.pickedFile[i]);
                                                    leagalIssueController.pickedFile.refresh();
                                                  },
                                                  icon: const Icon(
                                                    Icons.close,
                                                    color: AppColors.closeIconColor,
                                                    size: 20,
                                                  )),
                                            ],
                                          ),
                                        ),
                                        Obx(() {
                                          return Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left: 4),
                                                child: Row(
                                                  children: <Widget>[
                                                    Text(
                                                      controller.filecheklegalIsuueSpoterModel.value.isPageLimit == null
                                                          ? ''
                                                          : controller.filecheklegalIsuueSpoterModel.value.isPageLimit == false
                                                              ? 'Pages count exceeded'
                                                              : "",
                                                      style: TextStyle(
                                                        color: AppColors.invalidColor,
                                                        fontSize: 10,
                                                        fontFamily: 'Open Sans',
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      controller.filecheklegalIsuueSpoterModel.value.isEnglish == null
                                                          ? ''
                                                          : controller.filecheklegalIsuueSpoterModel.value.isEnglish == false
                                                              ? 'Incompatible language'
                                                              : "",
                                                      style: TextStyle(
                                                        color: AppColors.invalidColor,
                                                        fontSize: 10,
                                                        fontFamily: 'Open Sans',
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    controller.filecheklegalIsuueSpoterModel.value.isEnglish == null
                                                        ? const SizedBox()
                                                        : controller.filecheklegalIsuueSpoterModel.value.isEnglish == false
                                                            ? SizedBox(
                                                                height: 18,
                                                                child: OutlinedButton(
                                                                  style: OutlinedButton.styleFrom(
                                                                    side: const BorderSide(color: AppColors.blacktxtColor),
                                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                                  ),
                                                                  onPressed: () {},
                                                                  child: const Text(
                                                                    "Translate",
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                      color: Color(0xFF707070),
                                                                      fontSize: 10,
                                                                      fontFamily: 'Open Sans',
                                                                      fontWeight: FontWeight.w600,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            : const SizedBox(),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        })
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
          const Expanded(
            child: SizedBox(),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: WidgetButtonPress(
              child: ReusableGradientButton(
                  onPressed: () async {
                    controller.clear();
                    if (leagalIssueController.pickedFile.isNotEmpty) {
                      Get.dialog(
                        Obx(() {
                          return FileCheckingDialog(
                            length: controller.pickedFile.length,
                            filePath: controller.pickedFile[0],
                            isPageLimit: controller.filecheklegalIsuueSpoterModel.value.isPageLimit,
                            isEnglish: controller.filecheklegalIsuueSpoterModel.value.isEnglish,
                            isLegal: controller.filecheklegalIsuueSpoterModel.value.isLegal,
                            isReadable: controller.filecheklegalIsuueSpoterModel.value.isReadable,
                          );
                        }),
                      );
                      bool? checFileResult = await controller.checkFile();
                      if (checFileResult != null) {
                        if (controller.filecheklegalIsuueSpoterModel.value.isEnglish! &&
                            controller.filecheklegalIsuueSpoterModel.value.isPageLimit! &&
                            controller.filecheklegalIsuueSpoterModel.value.isReadable! &&
                            controller.filecheklegalIsuueSpoterModel.value.isLegal!) {
                          controller.pickedFile.refresh();

                          Get.back();
                          await controller.getCredit();
                        }
                      }
                    } else {
                      CustomSnackBar.snakbarInfo(title: "Warning", message: "Please Upload a File to analyze");
                    }
                  },
                  width: 250,
                  height: 48,
                  gradient: AppColors.linearGradient,
                  child: const Text(
                    "Start",
                    style: buttonTextStyle,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
