import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prajalok/app/data/serlization/leagalIssueModel.dart';
import 'package:prajalok/app/dateUtils.dart';
import 'package:prajalok/app/utils/api_const.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:prajalok/app/utils/widgetButton.dart';
import '../controllers/legal_issue_spotter_controller.dart';
import 'leagal_issue_spotter_result.dart';

void RecentContractAnalysisSheet(context) {
  final controller = Get.put(LegalIssueSpotterController());
  showGeneralDialog(
    context: context,
    barrierColor: Colors.black54,
    barrierDismissible: true,
    barrierLabel: 'Label',
    pageBuilder: (_, __, ___) {
      final leagalIssueRecentModel = <LeagalIssueModel>[].obs;
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
                          .from("issue_spotter")
                          .select()
                          .eq("profile_id", controller.uuid.toString())
                          .order("created_at", ascending: false),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator(
                            color: AppColors.textcolor,
                          ));
                        } else if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.data == null) {
                            return const Text(
                              'No activity',
                              style: TextStyle(
                                color: Color(0xFFFF5C40),
                                fontSize: 20,
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.w600,
                                height: 0.06,
                                letterSpacing: 0.20,
                              ),
                            );
                          }
                        }
                        if (!snapshot.hasData) {
                          return const Center(
                            child: Center(child: CircularProgressIndicator()),
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
                        // dev.log("json ${jsonEncode(res)}");
                        leagalIssueRecentModel.value = res.map((json) => LeagalIssueModel.fromJson(json)).toList();
                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: leagalIssueRecentModel.length,
                          itemBuilder: (context, i) {
                            final leagalIssueRecresult = leagalIssueRecentModel[i];
                            String getTimeAgo() {
                              return DateUtilssll.getTimeAgo(DateTime.parse(leagalIssueRecresult.createdAt.toString()));
                            }

                            return WidgetButtonPress(
                              child: InkWell(
                                onTap: () {
                                  controller.inputdocUrl.value = leagalIssueRecresult.docUrls.toString();
                                  controller.leagalIssue.value = leagalIssueRecresult.issues?[1].totalIssues ?? 0.toInt();
                                  controller.totalSection.value = leagalIssueRecresult.issues?[0].totalSections ?? 0.toInt();
                                  controller.queryId.value = leagalIssueRecresult.id ?? 0;
                                  //  controller.fetchAnlysisedData();
                                  Get.to(opaque: true, LegalIssueSpotterResult());
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
                                                leagalIssueRecresult.title ?? "",
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
                                                color: leagalIssueRecresult.status == "completed"
                                                    ? AppColors.greenHalf
                                                    : leagalIssueRecresult.status == "processing"
                                                        ? AppColors.stausYellowHalfColor
                                                        : leagalIssueRecresult.status == "error"
                                                            ? AppColors.stausYellowHalfColor
                                                            : null,
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              child: Text(
                                                leagalIssueRecresult.status == "completed"
                                                    ? "Successful"
                                                    : leagalIssueRecresult.status == "processing"
                                                        ? "analyzing"
                                                        : leagalIssueRecresult.status == "error"
                                                            ? "Failed"
                                                            : "",
                                                style: TextStyle(
                                                  color: leagalIssueRecresult.status == "completed"
                                                      ? AppColors.greenColor
                                                      : leagalIssueRecresult.status == "processing"
                                                          ? AppColors.textcolor
                                                          : leagalIssueRecresult.status == "error"
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
                                              children: <Widget>[],
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
