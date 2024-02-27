import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:prajalok/app/utils/compnent/given_info.dart';
import 'package:prajalok/app/utils/icons_const.dart';
import 'package:prajalok/app/utils/widget_const.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../../data/serlization/translatedfile_model.dart';
import '../../../utils/customer_loading.dart';
import '../controllers/document_transalator_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class TranslatedIleView extends StatelessWidget {
  TranslatedIleView({super.key});
  final controller = Get.put(DocumentTransalatorController());
  final Shader linearGradientText = const LinearGradient(
    colors: [Color(0xFFF12711), Color(0xFFF5AF19)],
    begin: Alignment.centerLeft,
    end: Alignment.bottomRight,
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 320.0, 80.0));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: const Text(
          'Translated document',
          style: TextStyle(
            color: AppColors.blacktxtColor,
            fontWeight: FontWeight.w600,
            fontFamily: 'Open Sans',
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            splashRadius: 20,
            onPressed: () {
              GivenInputInfoSheet(context, controller.translatedFileModel, true, /*isinputdocurl*/ true);
            },
            icon: SvgPicture.asset(
              SvgIcons.snakbarInfo,
              color: AppColors.grey44,
            ),
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: Obx(() {
            if (controller.translatedFileModel.isEmpty) {
              return const ReusableProcessingDialog();
            } else if (controller.translatedFileModel[0].status == "Processing") {
              return const Center(
                child: Text(
                  "No Data Found  ",
                  style: TextStyle(color: AppColors.blacktxtColor),
                ),
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 550,
                    width: Get.width,
                    child: SfPdfViewerTheme(
                      data: SfPdfViewerThemeData(
                        brightness: Brightness.light,
                        progressBarColor: AppColors.textcolor,
                        backgroundColor: Colors.white,
                      ),
                      child: SfPdfViewer.network(
                        canShowPaginationDialog: true,
                        canShowPageLoadingIndicator: true,
                        enableTextSelection: true,
                        enableDoubleTapZooming: true,
                        canShowScrollStatus: true,
                        canShowScrollHead: true,
                        pageSpacing: 4,
                        enableDocumentLinkAnnotation: true,
                        controller.translatedFileModel.first.outputDocUrl ?? "",
                      ),
                    ),
                  ),

                  // Container(
                  //     width: 358,
                  //     height: 105,
                  //     padding: const EdgeInsets.all(16),
                  //     decoration: BoxDecoration(
                  //       color: const Color(0xFFDBEEE7),
                  //       borderRadius: BorderRadius.circular(12),
                  //     ),
                  //     child: Column(
                  //       mainAxisAlignment: MainAxisAlignment.start,
                  //       crossAxisAlignment: CrossAxisAlignment.stretch,
                  //       children: [
                  //         const Padding(
                  //           padding: EdgeInsets.only(bottom: 5, left: 5, top: 0),
                  //           child: Text(
                  //             'Uploaded file',
                  //             style: TextStyle(
                  //               color: Color(0xFF1D976C),
                  //               fontSize: 16,
                  //               fontFamily: 'Open Sans',
                  //               fontWeight: FontWeight.w600,
                  //             ),
                  //           ),
                  //         ),
                  //         SizedBox(
                  //           width: 326,
                  //           height: 45,
                  //           child: Card(
                  //             elevation: 0,
                  //             shape: RoundedRectangleBorder(
                  //               borderRadius: BorderRadius.circular(6.0),
                  //             ),
                  //             child: Row(
                  //               children: [
                  //                 const SizedBox(width: 10),
                  //                 controller.translatedFileModel.isNotEmpty
                  //                     ? SvgPicture.asset(
                  //                         getFileIconPath(controller.translatedFileModel[0].inputDocUrl.toString()),
                  //                         height: 22,
                  //                         width: 22,
                  //                         fit: BoxFit.fill,
                  //                       )
                  //                     : const SizedBox(),
                  //                 const SizedBox(width: 10),
                  //                 SizedBox(
                  //                   width: 228,
                  //                   child: Text(
                  //                     controller.translatedFileModel[0].inputDocUrl ?? "",
                  //                     overflow: TextOverflow.ellipsis,
                  //                     softWrap: false,
                  //                     maxLines: 1,
                  //                   ),
                  //                 ),
                  //                 IconButton(
                  //                     splashRadius: 20,
                  //                     onPressed: () async {
                  //                       try {
                  //                         await launchUrl(Uri.parse(controller.translatedFileModel.first.inputDocUrl ?? ""));
                  //                       } catch (e) {
                  //                         throw Exception('Could not launch ');
                  //                       }
                  //                     },
                  //                     icon: SvgPicture.asset(SvgIcons.dataTalkview))
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     )),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 20),
                  //   child: Lottie.asset(
                  //     width: double.infinity,
                  //     height: 300,
                  //     fit: BoxFit.fill,
                  //     AnimatedJson.swipeIcons,
                  //   ),
                  // ),
                  // Container(
                  //   width: 358,
                  //   height: 140,
                  //   decoration: BoxDecoration(
                  //     gradient: AppColors.gradientOppcityColor,
                  //     borderRadius: BorderRadius.circular(12),
                  //   ),
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     children: <Widget>[
                  //       controller.translatedFileModel.isNotEmpty
                  //           ? SvgPicture.asset(
                  //               getFileIconPath(controller.translatedFileModel[0].inputDocUrl.toString()),
                  //               height: 64,
                  //               width: 64,
                  //               fit: BoxFit.fill,
                  //             )
                  //           : const SizedBox(),
                  //       const SizedBox(height: 10),
                  //       Text(
                  //         "${controller.translatedFileModel[0].inputDocUrl}".replaceAll(
                  //           "https://storage.googleapis.com/ld_user_bucket/2b449dff-9d51-4c9e-a053-2b2fc6357065/folderPath/",
                  //           "",
                  //         ),
                  //         style: const TextStyle(
                  //           color: Color(0xFF505050),
                  //           fontSize: 14,
                  //           fontFamily: 'open-sans',
                  //           fontWeight: FontWeight.w500,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  const Spacer(),
                  Center(
                    child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: ReusableGradientButton(
                          width: 150,
                          height: 38,
                          gradient: AppColors.linearGradient,
                          onPressed: () async {
                            try {
                              await launchUrl(Uri.parse(controller.translatedFileModel.first.outputDocUrl ?? ""));
                            } catch (e) {
                              throw Exception('Could not launch ');
                            }

                            //   controller.downloadFile(controller.translatedFileModel.first.outputDocUrl.toString(), "/storage/emulated/0/Download}");
                            //controller.download(controller.translatedFileModel.first.outputDocUrl.toString());
                          },
                          child: const Text("Download", style: buttonTextStyle),
                        )),
                  )
                ],
              );
            }
          }),
        ),
      ),
    );
  }
}
