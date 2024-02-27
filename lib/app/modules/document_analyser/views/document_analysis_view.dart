import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:prajalok/app/modules/home/controllers/home_controller.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:prajalok/app/utils/compnent/module_top_lebel.dart';
import 'package:prajalok/app/utils/compnent/razorPay.dart';
import 'package:prajalok/app/utils/compnent/upload_file.dart';
import 'package:prajalok/app/utils/customeSnackbar.dart';
import 'package:prajalok/app/utils/customer_loading.dart';
import 'package:prajalok/app/utils/icons_const.dart';
import 'package:prajalok/app/utils/widgetButton.dart';
import 'package:prajalok/app/utils/widget_const.dart';
import '../../../utils/compnent/get_credit.dart';
import '../../../utils/re_usable_class.dart';
import '../controllers/document_analysis_controller.dart';
import 'recent_doc_analyser.dart';

class DocumentAnalysisView extends GetView<DocumentAnalysisController> {
  DocumentAnalysisView({Key? key}) : super(key: key);
  final documentAnalysisController = Get.put(DocumentAnalysisController());
  final homecontroller = Get.put(HomeController());
  ReUsableService reUsableService = ReUsableService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onActionPressed: () {
          RecentDocAnalysisSheet(context);
        },
        title: 'Document Analyser',
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
                  'Save your time with',
                  'comprehensive document summaries.',
                ),
                SizedBox(height: 16),
                Obx(() {
                  return FileUploadSection(
                    maxFiles: 1,
                    onFilePickerTap: () {
                      documentAnalysisController.docAnlysisfilepicker();
                    },
                    onCameraTap: () {
                      documentAnalysisController.takeSnapshot();
                    },
                    onScannerTap: () {},
                    files: documentAnalysisController.files.length,
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
                  if (documentAnalysisController.files.isEmpty) {
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
                                      '1/${documentAnalysisController.files.length}',
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
                                itemCount: documentAnalysisController.files.length,
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
                                                      documentAnalysisController.files[i] != null && documentAnalysisController.files[i]!.isNotEmpty
                                                          ? SvgPicture.asset(
                                                              (documentAnalysisController.files[i]!.split('.')?.last == 'pdf')
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
                                                          documentAnalysisController.files[0] ?? "",
                                                          overflow: TextOverflow.ellipsis,
                                                          softWrap: false,
                                                          maxLines: 1,
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                              IconButton(
                                                  onPressed: () {
                                                    documentAnalysisController.files.remove(documentAnalysisController.files[i]);
                                                    documentAnalysisController.files.refresh();
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
                                                      controller.fileCheckModel.value.isPageLimit == null
                                                          ? ''
                                                          : controller.fileCheckModel.value.isPageLimit == false
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
                                                      controller.fileCheckModel.value.isEnglish == null
                                                          ? ''
                                                          : controller.fileCheckModel.value.isEnglish == false
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
                                                    controller.fileCheckModel.value.isEnglish == null
                                                        ? const SizedBox()
                                                        : controller.fileCheckModel.value.isEnglish == false
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
                    if (documentAnalysisController.files.isNotEmpty) {
                      Get.dialog(
                        Obx(() {
                          return FileCheckingDialog(
                            length: controller.files.length,
                            filePath: controller.files[0],
                            isPageLimit: controller.fileCheckModel.value.isPageLimit,
                            isEnglish: controller.fileCheckModel.value.isEnglish,
                            isLegal: controller.fileCheckModel.value.isLegal,
                            isReadable: controller.fileCheckModel.value.isReadable,
                          );
                        }),
                      );
                      bool? checFileResult = await documentAnalysisController.checkFile();
                      if (checFileResult != null) {
                        if (controller.fileCheckModel.value.isEnglish! &&
                            controller.fileCheckModel.value.isPageLimit! &&
                            controller.fileCheckModel.value.isReadable! &&
                            controller.fileCheckModel.value.isLegal!) {
                          controller.files.refresh();
                          Get.back();
                          homecontroller.getModule(1);

                          Get.bottomSheet(Obx(
                            () => BuyCredit(
                              moduleName: 'Document Analysis',
                              price: homecontroller.price.value,
                              usePrice: homecontroller.price.value + 20,
                              onPressed: () {
                                homecontroller.initiatePayment(homecontroller.price.value, 1);
                              },
                            ),
                          ));

                          // Get.bottomSheet(
                          //   enterBottomSheetDuration: const Duration(milliseconds: 250),
                          //   ignoreSafeArea: true,
                          //   isScrollControlled: true,
                          //   const CustomerDetails(),
                          // );

                          //    await controller.getCredit();
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
