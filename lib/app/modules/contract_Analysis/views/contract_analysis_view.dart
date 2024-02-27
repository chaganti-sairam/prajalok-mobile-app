import 'package:flutter/foundation.dart';
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
import '../controllers/contract_analysis_controller.dart';
import 'contract_analysis_recent.dart';

class ContractAnalysisView extends GetView<ContractAnalysisController> {
  ContractAnalysisView({Key? key}) : super(key: key);
  final contarctAnalysisC = Get.put(ContractAnalysisController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Contract analysis",
        onActionPressed: () {
          RecentContractAnalysisSheet(context);

          //Get.to(RecentContractAnalysisSheet());
        },
        actionIcon: SvgPicture.asset(SvgIcons.recentlyicons),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: <Widget>[
                buildTopBar(
                  SvgIcons.contractAnalysislogo,
                  'Uncover',
                  'rich insights analysis of\nagreements/contracts',
                ),
                const SizedBox(height: 16),
                Obx(() {
                  return FileUploadSection(
                    maxFiles: 1,
                    onFilePickerTap: () {
                      controller.docAnlysisfilepicker();
                    },
                    onCameraTap: () {
                      controller.takeSnapshot();
                    },
                    onScannerTap: () {},
                    files: controller.pickedFile.length,
                  );
                }),
                const UploadInstructions(
                  title: 'Upload instructions',
                  instructions: [
                    'Supports all major file formats',
                    'Preferred in English language',
                    'Maximum 1 file(s) can be uploaded',
                    'Ensure the document contains fewer than 40 pages',
                  ],
                ),
                Obx(() {
                  if (controller.pickedFile.isEmpty) {
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
                                  '${controller.pickedFile.length}/1',
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
                      SizedBox(
                        child: Obx(
                          () => ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: controller.pickedFile.length,
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
                                                  SvgPicture.asset(
                                                    getFileIconPath(controller.pickedFile[i]),
                                                    height: 20,
                                                    width: 20,
                                                    fit: BoxFit.fill,
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  SizedBox(
                                                    width: 200,
                                                    child: Text(
                                                      controller.pickedFile[i].replaceAll("/data/user/0/com.example.prajalok/cache/file_picker/", ""),
                                                      overflow: TextOverflow.ellipsis,
                                                      softWrap: false,
                                                    ),
                                                  ),
                                                ],
                                              )),
                                          IconButton(
                                            onPressed: () {
                                              controller.pickedFile.remove(controller.pickedFile[i]);
                                              controller.pickedFile.refresh();
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
                                      return Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 4),
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  controller.contarctAnlysisFileChekingModel.value.isPageLimit == null
                                                      ? ''
                                                      : controller.contarctAnlysisFileChekingModel.value.isPageLimit == false
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
                                                  controller.contarctAnlysisFileChekingModel.value.isEnglish == null
                                                      ? ''
                                                      : controller.contarctAnlysisFileChekingModel.value.isEnglish == false
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
                                                controller.contarctAnlysisFileChekingModel.value.isEnglish == null
                                                    ? const SizedBox()
                                                    : controller.contarctAnlysisFileChekingModel.value.isEnglish == false
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
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                })
              ],
            ),
          ),
          const Expanded(child: SizedBox()),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: WidgetButtonPress(
              child: ReusableGradientButton(
                  onPressed: () async {
                    controller.clear();
                    if (controller.pickedFile.isNotEmpty) {
                      Get.dialog(
                        Obx(() {
                          return FileCheckingDialog(
                            length: controller.pickedFile.length,
                            filePath: controller.pickedFile[0],
                            isPageLimit: controller.contarctAnlysisFileChekingModel.value.isPageLimit,
                            isEnglish: controller.contarctAnlysisFileChekingModel.value.isEnglish,
                            isLegal: controller.contarctAnlysisFileChekingModel.value.isLegal,
                            isReadable: controller.contarctAnlysisFileChekingModel.value.isReadable,
                          );
                        }),
                      );
                      bool? checFileResult = await controller.checkFile();
                      if (checFileResult != null) {
                        if (controller.contarctAnlysisFileChekingModel.value.isEnglish! &&
                            controller.contarctAnlysisFileChekingModel.value.isPageLimit! &&
                            controller.contarctAnlysisFileChekingModel.value.isReadable! &&
                            controller.contarctAnlysisFileChekingModel.value.isLegal!) {
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
                    "Start Analysis",
                    style: buttonTextStyle,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
