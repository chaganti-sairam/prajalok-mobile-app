import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prajalok/app/modules/legalIssueSpotter/views/leagal_issue_spotter_result.dart';
import 'package:prajalok/app/utils/color_const.dart';
import '../../../data/serlization/leagalIssueModel.dart';
import '../controllers/legal_issue_spotter_controller.dart';
import 'package:prajalok/app/utils/widget_const.dart';

class HighRisk extends StatelessWidget {
  HighRisk({Key? key}) : super(key: key);
  final legalIssueController = Get.put(LegalIssueSpotterController());
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Obx(() {
        if (legalIssueController.leagalIssueModel.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.textcolor,
            ),
          );
        }
        List<LegalIssue> lowSeverityIssues = [];
        for (int i = 0; i < legalIssueController.leagalIssueModel.length; i++) {
          final legalIssueRes = legalIssueController.leagalIssueModel[i];
          for (int j = 0; j < legalIssueRes.issues!.length; j++) {
            final legalIssueRes2 = legalIssueRes.issues?[j];
            lowSeverityIssues.addAll(legalIssueRes2?.legalIssues?.where((issue) => issue.severity == "high").toList() ?? []);
          }
        }

        if (lowSeverityIssues.isEmpty) {
          return const Center(
              child: IsLoadingWidget(
            message: "Zero drama",
            submessage: "in your document !",
          ));
        }

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: lowSeverityIssues.length,
          itemBuilder: (_, index3) {
            final leagalIssueRes3 = lowSeverityIssues[index3];
            return Container(
              color: Colors.white,
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Original text  ',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.invalidColor,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Open Sans',
                                ),
                              ),
                              TextSpan(
                                text: 'Section ${leagalIssueRes3.section}',
                                style: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.disableColor,
                                  fontFamily: 'Open Sans',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: Get.width * 0.2,
                          height: 24,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.stausYellowHalfColor,
                          ),
                          child: Text(
                            "${leagalIssueRes3.reason.toString()}",
                            style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.blacktxtColor,
                              fontFamily: 'Open Sans',
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: leagalIssueRes3.issueLine?.length ?? 0,
                        itemBuilder: (_, ii) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                //  color: AppColors.lightShadegrey,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.all(4),
                              child: Row(
                                children: [
                                  const Text(
                                    "\u2022 ",
                                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${leagalIssueRes3.issueLine?[ii]}",
                                      textAlign: TextAlign.justify,
                                      style: createCustomTextStyle(
                                        color: AppColors.blacktxtColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    //Text("${leagalIssueRes3?.issueLine}"),

                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: AppColors.greenHalf,
                      ),
                      child: Text(
                        "${leagalIssueRes3.possibleInterpretation}",
                        textAlign: TextAlign.justify,
                        style: createCustomTextStyle(
                          color: AppColors.blacktxtColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Theme(
                      data: ThemeData(
                        dividerColor: Colors.transparent,
                        expansionTileTheme: const ExpansionTileThemeData(),
                      ),
                      child: ExpansionTile(
                        collapsedTextColor: Colors.blue,
                        textColor: AppColors.textcolor,
                        iconColor: AppColors.textcolor,
                        title: const Text('Suggested alternative'),
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              "${leagalIssueRes3.recommendChanges}",
                              textAlign: TextAlign.justify,
                              style: createCustomTextStyle(
                                color: AppColors.blacktxtColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}


// class HighRisk extends StatelessWidget {
//   HighRisk({super.key});
//   final leagalIssueController = Get.put(LegalIssueSpotterController());
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       child: Obx(() {
//         if (leagalIssueController.leagalIssueModel.isEmpty) {
//           return const Center(
//               child: CircularProgressIndicator(
//             color: AppColors.textcolor,
//           ));
//         }
//         return ListView.builder(
//           physics: const BouncingScrollPhysics(),
//           shrinkWrap: true,
//           itemCount: leagalIssueController.leagalIssueModel.length,
//           itemBuilder: (_, index1) {
//             final leagalIssueRes = leagalIssueController.leagalIssueModel[index1];

//             return ListView.builder(
//               physics: const BouncingScrollPhysics(),
//               shrinkWrap: true,
//               itemCount: leagalIssueRes.issues?.length ?? 0,
//               itemBuilder: (_, index2) {
//                 final leagalIssueRes2 = leagalIssueRes.issues?[index2];
//                 List<LegalIssue> legalIssues1 = leagalIssueRes2?.legalIssues?.where((issue) => issue.severity == "high").toList() ?? [];
//                 if (legalIssues1.isEmpty) {
//                   return const IsLoadingWidget(
//                     message: "No discrepancies",
//                     submessage: "in sight! document is flawless",
//                   );
//                 }
//                 return ListView.builder(
//                   physics: const BouncingScrollPhysics(),
//                   shrinkWrap: true,
//                   itemCount: legalIssues1.length,
//                   itemBuilder: (_, index3) {
//                     final leagalIssueRes3 = legalIssues1[index3];
//                     return Container(
//                       color: Colors.white,
//                       margin: const EdgeInsets.only(top: 10, bottom: 10),
//                       child: Container(
//                         padding: const EdgeInsets.all(16),
//                         child: Column(
//                           children: <Widget>[
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: <Widget>[
//                                 Text.rich(
//                                   TextSpan(
//                                     children: [
//                                       TextSpan(
//                                         text: 'Original text  ',
//                                         style: TextStyle(
//                                           fontSize: 12,
//                                           color: AppColors.invalidColor,
//                                           fontWeight: FontWeight.w600,
//                                           fontFamily: 'Open Sans',
//                                         ),
//                                       ),
//                                       TextSpan(
//                                         text: 'Section ${leagalIssueRes3?.section}',
//                                         style: const TextStyle(
//                                           overflow: TextOverflow.ellipsis,
//                                           fontSize: 12,
//                                           fontWeight: FontWeight.w600,
//                                           color: AppColors.disableColor,
//                                           fontFamily: 'Open Sans',
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Container(
//                                   width: Get.width * 0.2,
//                                   height: 24,
//                                   alignment: Alignment.center,
//                                   padding: const EdgeInsets.all(4),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(12),
//                                     color: AppColors.stausYellowHalfColor,
//                                   ),
//                                   child: Text(
//                                     "${leagalIssueRes3?.reason.toString()}",
//                                     style: const TextStyle(
//                                       overflow: TextOverflow.ellipsis,
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.w600,
//                                       color: AppColors.blacktxtColor,
//                                       fontFamily: 'Open Sans',
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(top: 10, bottom: 10),
//                               child: Text("${leagalIssueRes3?.issueLine}"),
//                             ),
//                             Container(
//                               margin: const EdgeInsets.only(top: 10, bottom: 10),
//                               padding: const EdgeInsets.all(4),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(12.0),
//                                 color: AppColors.greenHalf,
//                               ),
//                               child: Text("${leagalIssueRes3?.possibleInterpretation}"),
//                             ),
//                             Theme(
//                               data: ThemeData(
//                                 dividerColor: Colors.transparent,
//                                 expansionTileTheme: const ExpansionTileThemeData(),
//                               ),
//                               child: ExpansionTile(
//                                 collapsedTextColor: Colors.blue,
//                                 textColor: AppColors.textcolor,
//                                 iconColor: AppColors.textcolor,
//                                 title: const Text('Suggested alternative'),
//                                 children: <Widget>[
//                                   Container(
//                                     padding: const EdgeInsets.all(16),
//                                     child: Text("${leagalIssueRes3?.recommendChanges}"),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             );
//           },
//         );
//       }),
//     );
//   }
// }
