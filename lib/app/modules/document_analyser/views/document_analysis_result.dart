import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:prajalok/app/utils/compnent/cache_image.dart';
import 'package:prajalok/app/utils/compnent/given_info.dart';
import 'package:prajalok/app/utils/customer_loading.dart';
import 'package:prajalok/app/utils/icons_const.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/serlization/analysis_res_model.dart';
import '../controllers/document_analysis_controller.dart';

class DocAnalysisResult extends StatelessWidget {
  DocAnalysisResult({super.key});
  final controller = Get.put(DocumentAnalysisController());
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
          'Analysis result',
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
              GivenInputInfoSheet(context, controller.legalDocuments, true, /*isinputdocurl*/ false);
            },
            icon: SvgPicture.asset(
              SvgIcons.snakbarInfo,
              color: AppColors.grey44,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Obx(
          () {
            if (controller.legalDocuments.isEmpty) {
              const ReusableProcessingDialog();
            }
            LegalDocument? re;
            for (re in controller.legalDocuments) {
              if (kDebugMode) {
                print(re.docUrl);
              }
            }
            if (controller.legalDocuments.isEmpty) {
              const ReusableProcessingDialog();
            }
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    width: Get.width,
                    height: 100,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDBEEE7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          width: 326,
                          child: Text(
                            'Uploaded file',
                            style: TextStyle(
                              color: Color(0xFF1D976C),
                              fontSize: 16,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Container(
                              padding: const EdgeInsets.only(left: 8),
                              height: 40,
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        (re?.docUrl?.split('.').last == 'pdf') ? SvgIcons.pdfIcons : SvgIcons.jpgIcons,
                                        height: 20,
                                        width: 20,
                                        fit: BoxFit.cover,
                                      ),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: Text(
                                          re?.docUrl ?? "",
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Center(
                                    child: IconButton(
                                        onPressed: () async {
                                          try {
                                            await launchUrl(Uri.parse(re?.docUrl ?? ""));
                                          } catch (e) {
                                            throw Exception('Could not launch ');
                                          }
                                        },
                                        icon: SvgPicture.asset(SvgIcons.dataTalkview)),
                                  )
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 500,
                    child: ListView.separated(
                        //physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        separatorBuilder: (context, i) {
                          return const Padding(padding: EdgeInsets.all(8));
                        },
                        itemCount: re?.analysis?.entries.length ?? 0,
                        itemBuilder: (_, i) {
                          final res = re?.analysis?.entries.elementAt(i);
                          print("Amressssssssssss ${res}");

                          if (res?.value == null) {
                            return const CircularProgressIndicator();
                          }

                          {
                            return Container(
                              width: Get.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(width: 1, color: const Color(0xFFEFEFEF)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        bottomRight: Radius.circular(12),
                                      ),
                                      gradient: AppColors.linearGradient,
                                    ),
                                    child: Text(
                                      "${res?.key}".capitalizeFirst.toString().replaceAll('_', ' '),
                                      style: GoogleFonts.openSans(
                                        fontSize: 16,
                                        color: Colors.white,
                                        //  fontFamily: 'Open Sans',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.center,
                                    child: ListTile(
                                      titleTextStyle: GoogleFonts.openSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.blacktxtColor,
                                      ),
                                      title: res?.value["object_type"] == "grid"
                                          ? GridView.count(
                                              physics: const ScrollPhysics(),
                                              crossAxisCount: 3,
                                              crossAxisSpacing: 5,
                                              mainAxisSpacing: 0,
                                              shrinkWrap: true,
                                              children: List.generate(res?.value["value"].length, (index) {
                                                return Column(
                                                  children: <Widget>[
                                                    SizedBox(
                                                      child: buildstaticImageWidget(36.0),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    SizedBox(
                                                      width: 150,
                                                      child: Text(
                                                        "${res?.value["value"][index]}",
                                                        textAlign: TextAlign.center,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }),
                                            )
                                          : const SizedBox(),
                                      subtitle: res?.value["object_type"] == "list"
                                          ? ListView.builder(
                                              physics: const BouncingScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: res?.value["value"].length,
                                              itemBuilder: (context, int index) {
                                                return Markdown(
                                                  bulletBuilder: (index, style) {
                                                    return const Text(
                                                      "•",
                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                    );
                                                  },
                                                  padding: const EdgeInsets.only(left: 0, right: 0, top: 6, bottom: 6),
                                                  physics: const BouncingScrollPhysics(),
                                                  shrinkWrap: true,
                                                  selectable: true,
                                                  data: "* ${res?.value["value"][index]}",
                                                );
                                              },
                                            )
                                          : res?.value["object_type"] == "grid"
                                              ? const SizedBox()
                                              : Text(
                                                  res?.value["value"] ?? "no response",
                                                  textAlign: TextAlign.justify,
                                                  style: GoogleFonts.openSans(
                                                    color: AppColors.grey44,
                                                    fontSize: 14,
                                                    //  fontFamily: 'Open Sans',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        }),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
