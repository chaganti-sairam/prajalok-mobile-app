import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:prajalok/app/data/serlization/analysis_res_model.dart';
import 'package:prajalok/app/dateUtils.dart';
import 'package:prajalok/app/modules/document_analyser/controllers/document_analysis_controller.dart';
import 'package:prajalok/app/utils/api_const.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:prajalok/app/utils/icons_const.dart';
import 'package:prajalok/app/utils/widgetButton.dart';
import '../../../data/serlization/staticlegaldocumentsModel.dart';
import 'document_analysis_result.dart';

void RecentDocAnalysisSheet(context) {
  final controller = Get.put(DocumentAnalysisController());
  showGeneralDialog(
    context: context,
    barrierColor: Colors.black54,
    barrierDismissible: true,
    barrierLabel: 'Label',
    pageBuilder: (_, __, ___) {
      final legalDocuments = <LegalDocument>[].obs;
      return Align(
        alignment: Alignment.centerRight,
        child: SafeArea(
          child: Material(
            child: SizedBox(
              width: 300,
              height: double.infinity,
              child: Column(
                children: [
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    automaticallyImplyLeading: false,
                    title: const Text(
                      'Recent  Analyzer',
                      style: TextStyle(
                        color: Color(0xFF606060),
                        fontSize: 16,
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    centerTitle: false,
                  ),
                  Expanded(
                    child: FutureBuilder(
                      future: supabase
                          .schema(ApiConst.analysisSchema)
                          .from("document_analysis")
                          .select()
                          .eq("profile_id", controller.uuid.toString())
                          .order("created_at", ascending: false),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: Text(
                              'No activity',
                              style: TextStyle(
                                color: Color(0xFFFF5C40),
                                fontSize: 20,
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.w600,
                                height: 0.06,
                                letterSpacing: 0.20,
                              ),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return const Center(
                            child: Text(
                              'error',
                              style: TextStyle(
                                color: Color(0xFFFF5C40),
                                fontSize: 20,
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.w600,
                                height: 0.06,
                                letterSpacing: 0.20,
                              ),
                            ),
                          );
                        }
                        final res = snapshot.data as List;
                        legalDocuments.value = res.map((json) => LegalDocument.fromJson(json)).toList();
                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: legalDocuments.length,
                          itemBuilder: (context, i) {
                            final analysisRes = legalDocuments[i];
                            String getTimeAgo() {
                              return DateUtilssll.getTimeAgo(DateTime.parse(analysisRes.createdAt ?? DateTime.now().toString()));
                            }

                            final List<StaticLegalDocumentsModel> res =
                                controller.staticLegalDocumentsModel.where((element) => element.id == analysisRes.legalDocumentId).toList();

                            return WidgetButtonPress(
                              child: InkWell(
                                onTap: () {
                                  controller.docAnylysisControllertext.value.text = analysisRes.docUrl.toString();
                                  controller.queryId.value = analysisRes.id ?? 0;
                                  controller.fetchAnlysisedData();
                                  Get.to(opaque: true, DocAnalysisResult());
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 24),
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        width: 264,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 180,
                                              child: AutoSizeText(
                                                analysisRes.title ?? "",
                                                style: const TextStyle(
                                                  color: Color(0xFF404040),
                                                  fontSize: 16,
                                                  fontFamily: 'Open Sans',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                maxLines: 2,
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: analysisRes.status == "analyzed"
                                                    ? AppColors.greenHalf
                                                    : analysisRes.status == "processing"
                                                        ? AppColors.stausYellowHalfColor
                                                        : analysisRes.status == "error"
                                                            ? AppColors.stausYellowHalfColor
                                                            : null,
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              child: Text(
                                                analysisRes.status == "analyzed"
                                                    ? "Successful"
                                                    : analysisRes.status == "processing"
                                                        ? "analyzing"
                                                        : analysisRes.status == "error"
                                                            ? "Failed"
                                                            : "",
                                                style: TextStyle(
                                                  color: analysisRes.status == "analyzed"
                                                      ? AppColors.greenColor
                                                      : analysisRes.status == "processing"
                                                          ? AppColors.textcolor
                                                          : analysisRes.status == "error"
                                                              ? AppColors.invalidColor
                                                              : null,
                                                  fontSize: 12,
                                                  fontFamily: 'Open Sans',
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      SizedBox(
                                        width: 264,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: <Widget>[
                                                SvgPicture.asset(
                                                  SvgIcons.simpledocumentSvg,
                                                  fit: BoxFit.fill,
                                                ),
                                                const SizedBox(width: 5),
                                                AutoSizeText(
                                                  "${res.isEmpty ? "loading..." : res.first.docType}".replaceAll("_", " "),
                                                  style: const TextStyle(
                                                    color: AppColors.blacktxtColor,
                                                    fontSize: 12,
                                                    fontFamily: 'Open Sans',
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            AutoSizeText(
                                              getTimeAgo(),
                                              style: const TextStyle(
                                                color: Color(0xFF9F9F9F),
                                                fontSize: 12,
                                                fontFamily: 'Open Sans',
                                                fontWeight: FontWeight.w400,
                                                letterSpacing: 0.12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
