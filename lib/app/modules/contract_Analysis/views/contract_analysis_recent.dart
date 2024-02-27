import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prajalok/app/data/serlization/contract_analysis_res_model.dart';
import 'package:prajalok/app/dateUtils.dart';
import 'package:prajalok/app/utils/api_const.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:prajalok/app/utils/widgetButton.dart';
import '../controllers/contract_analysis_controller.dart';
import 'contract_analysis_result.dart';

void RecentContractAnalysisSheet(context) {
  final controller = Get.put(ContractAnalysisController());
  showGeneralDialog(
    context: context,
    barrierColor: Colors.black54,
    barrierDismissible: true,
    barrierLabel: 'Label',
    pageBuilder: (_, __, ___) {
      final contractAnalysisResponseModelRecent = <ContractAnalysisResponseModel>[].obs;
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
                  //f966bea8-7538-4a2e-9912-2adf16418a9f
                  Expanded(
                    child: FutureBuilder(
                      future: supabase
                          .schema(ApiConst.analysisSchema)
                          .from("contract_analysis")
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

                        //  print("resultttttttttt ${res}");
                        contractAnalysisResponseModelRecent.value = res.map((json) => ContractAnalysisResponseModel.fromJson(json)).toList();
                        //  contractAnalysisResponseModel.value = analysisRes.map((json) => ContractAnalysisResponseModel.fromJson(json)).toList();

                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: contractAnalysisResponseModelRecent.length,
                          itemBuilder: (context, i) {
                            final canalysisRes = contractAnalysisResponseModelRecent[i];
                            String getTimeAgo() {
                              return DateUtilssll.getTimeAgo(DateTime.parse(canalysisRes.createdAt.toString()));
                            }

                            // final List<StaticLegalDocumentsModel> res =
                            //     controller.staticLegalDocumentsModel.where((element) => element.id == analysisRes.legalDocumentId).toList();

                            return WidgetButtonPress(
                              child: InkWell(
                                onTap: () {
                                  //  controller.docAnylysisControllertext.value.text = analysisRes.docUrl.toString();

                                  controller.queryId.value = canalysisRes.id ?? 0;
                                  //  controller.fetchAnlysisedData();
                                  Get.to(opaque: true, ContractAnalysisResult());
                                  controller.fetchContractAnalysisData();
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
                                                canalysisRes.title ?? "",
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
                                                color: canalysisRes.status == "completed"
                                                    ? AppColors.greenHalf
                                                    : canalysisRes.status == "processing"
                                                        ? AppColors.stausYellowHalfColor
                                                        : canalysisRes.status == "error"
                                                            ? AppColors.stausYellowHalfColor
                                                            : null,
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              child: Text(
                                                canalysisRes.status == "completed"
                                                    ? "Successful"
                                                    : canalysisRes.status == "processing"
                                                        ? "analyzing"
                                                        : canalysisRes.status == "error"
                                                            ? "Failed"
                                                            : "",
                                                style: TextStyle(
                                                  color: canalysisRes.status == "completed"
                                                      ? AppColors.greenColor
                                                      : canalysisRes.status == "processing"
                                                          ? AppColors.textcolor
                                                          : canalysisRes.status == "error"
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
                                            const Row(
                                              children: <Widget>[
                                                // SvgPicture.asset(
                                                //   SvgIcons.simpledocumentSvg,
                                                //   fit: BoxFit.fill,
                                                // ),
                                                // const SizedBox(width: 5),
                                                // AutoSizeText(

                                                //   "dddddddddd",
                                                //   //"${res.first.docType}".replaceAll("_", " "),
                                                //   style: const TextStyle(
                                                //     color: AppColors.blacktxtColor,
                                                //     fontSize: 12,
                                                //     fontFamily: 'Open Sans',
                                                //     fontWeight: FontWeight.w400,
                                                //   ),
                                                // ),
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
