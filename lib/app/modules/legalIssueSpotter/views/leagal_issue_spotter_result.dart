import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:prajalok/app/data/serlization/leagalIssueModel.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:prajalok/app/utils/compnent/given_info.dart';
import 'package:prajalok/app/utils/icons_const.dart';
import 'package:prajalok/app/utils/widget_const.dart';
import '../controllers/legal_issue_spotter_controller.dart';
import 'high_risk_page.dart';
import 'lowRiskPage.dart';
import 'medium_risk_page.dart';

class LegalIssueSpotterResult extends StatelessWidget {
  LegalIssueSpotterResult({super.key});
  final List<Widget> listWidget = [
    AllRiskPage(),
    HighRisk(),
    MediumRiskPage(),
    LowRisk(),
  ];
  final leagalIssueController = Get.put(LegalIssueSpotterController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: const Text("Identified discrepancies"),
        actions: [
          IconButton(
            splashRadius: 20,
            onPressed: () {
              GivenInputInfoSheet(context, leagalIssueController.leagalIssueModel, false, /*isinputdocurl*/ false);
            },
            icon: SvgPicture.asset(
              SvgIcons.snakbarInfo,
              color: AppColors.grey44,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
                height: 80,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.lightShadegrey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      width: double.infinity,
                      padding: const EdgeInsets.all(4),
                      alignment: Alignment.center,
                      child: Obx(() {
                        return ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: leagalIssueController.listOfTitles.length,
                          separatorBuilder: (context, index) {
                            return const SizedBox.shrink();
                          },
                          itemBuilder: (_, i) {
                            return InkWell(
                              onTap: () {
                                leagalIssueController.changeSateFunc(leagalIssueController.currentIndex.value + i);
                                leagalIssueController.pageController.animateToPage(
                                  i,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.ease,
                                );
                              },
                              child: Obx(() {
                                return Container(
                                  width: 80,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: leagalIssueController.currentIndex.value == i ? AppColors.textcolor : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Obx(() {
                                        return Text(
                                          leagalIssueController.listOfTitles[i],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: leagalIssueController.currentIndex.value == i ? Colors.white : AppColors.closeIconColor,
                                            fontSize: 14,
                                            fontFamily: "opne Sans",
                                            fontWeight: FontWeight.w600,
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                );
                              }),
                            );
                          },
                        );
                      }),
                    ),
                  ],
                )),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: PageView.builder(
                reverse: false,
                controller: leagalIssueController.pageController,
                onPageChanged: (index) {
                  leagalIssueController.changeSateFunc(index);
                },
                itemCount: listWidget.length,
                itemBuilder: (context, index) {
                  return listWidget[index];
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// medium risk
// class MediumRiskPage extends StatelessWidget {
//   MediumRiskPage({super.key});
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
//                 return ListView.builder(
//                   physics: const BouncingScrollPhysics(),
//                   shrinkWrap: true,
//                   itemCount: leagalIssueRes2?.legalIssues?.length ?? 0,
//                   itemBuilder: (_, index3) {
//                     final leagalIssueRes3 = leagalIssueRes2?.legalIssues?[index3];
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

//  for all page
class AllRiskPage extends StatelessWidget {
  AllRiskPage({super.key});
  final leagalIssueController = Get.put(LegalIssueSpotterController());
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Obx(() {
        if (leagalIssueController.leagalIssueModel.isEmpty) {
          return const Center(
              child: CircularProgressIndicator(
            color: AppColors.textcolor,
          ));
        }
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: leagalIssueController.leagalIssueModel.length,
          itemBuilder: (_, index1) {
            final leagalIssueRes = leagalIssueController.leagalIssueModel[index1];
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: leagalIssueRes.issues?.length ?? 0,
              itemBuilder: (_, index2) {
                final leagalIssueRes2 = leagalIssueRes.issues?[index2];
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: leagalIssueRes2?.legalIssues?.length ?? 0,
                  itemBuilder: (_, index3) {
                    final leagalIssueRes3 = leagalIssueRes2?.legalIssues?[index3];
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
                                        text: 'Section ${leagalIssueRes3?.section}',
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
                                    "${leagalIssueRes3?.reason.toString()}",
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
                                itemCount: leagalIssueRes3?.issueLine?.length ?? 0,
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
                                              "${leagalIssueRes3?.issueLine?[ii]}",
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
                                "${leagalIssueRes3?.possibleInterpretation}",
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
                                      "${leagalIssueRes3?.recommendChanges}",
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
              },
            );
          },
        );
      }),
    );
  }
}

class IsLoadingWidget extends StatelessWidget {
  const IsLoadingWidget({
    Key? key,
    required this.message,
    required this.submessage,
    this.loadingColor = AppColors.textcolor,
    this.textColor = AppColors.blacktxtColor,
    this.fontSize = 14,
    this.titleFontWeight = FontWeight.w600,
  }) : super(key: key);

  final String message;
  final String submessage;
  final Color loadingColor;
  final Color textColor;
  final double fontSize;
  final FontWeight titleFontWeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(
            // width: 200,
            // height: 200,
            width: double.infinity,
            height: Get.height * 0.3,
            fit: BoxFit.fill,
            AnimatedJson.documentjson,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: 200,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '$message ',
                    style: TextStyle(
                      fontSize: 20,
                      color: loadingColor,
                      fontWeight: titleFontWeight,
                      fontFamily: 'Open Sans',
                    ),
                  ),
                  TextSpan(
                    text: submessage,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: titleFontWeight,
                      color: textColor,
                      fontFamily: 'Open Sans',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
