import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:prajalok/app/data/serlization/contract_analysis_res_model.dart';
import 'package:prajalok/app/modules/contract_Analysis/controllers/contract_analysis_controller.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:prajalok/app/utils/customer_loading.dart';
import 'package:prajalok/app/utils/icons_const.dart';
import 'package:readmore/readmore.dart';

// ignore: must_be_immutable
class PosstionResponsibility extends StatelessWidget {
  int clauseid = 0;
  PosstionResponsibility({super.key, required this.clauseid});
  final contratAnalysisC = Get.put(ContractAnalysisController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Position and Responsibilities"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Obx(() {
            if (contratAnalysisC.contractAnalysisResponseModel.isEmpty) {
              return const ReusableProcessingDialog();
            }
            ClauseAnalysisElement? clauseresult;
            for (ContractAnalysisResponseModel re in contratAnalysisC.contractAnalysisResponseModel) {
              for (ContractAnalysis result1 in re.contractAnalysis ?? []) {
                if (result1.clauseAnalysis?.any((clause) => clause.clauseAnalysis?.clauseNumber == clauseid) == true) {
                  for (clauseresult in result1.clauseAnalysis ?? []) {
                    print("");
                  }
                }
              }
            }

            return Column(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Clause fairness',
                              style: TextStyle(
                                color: Color(0xFF404040),
                                fontSize: 14,
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SvgPicture.asset(
                              SvgIcons.snakbarInfo,
                              fit: BoxFit.cover,
                              color: Colors.grey,
                              height: 20,
                              width: 20,
                            ),
                          ],
                        )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                width: 116,
                                height: 116,
                                margin: const EdgeInsets.only(top: 10, bottom: 10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColors.stausYellowHalfColor,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SvgPicture.asset(
                                      SvgIcons.docyellowIconsIcon,
                                      height: 56,
                                      width: 56,
                                    ),
                                    Text(
                                      "${clauseresult?.clauseAnalysis?.fairness?.fairnessScore}",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: AppColors.blacktxtColor,
                                        fontSize: 18,
                                        fontFamily: 'Open Sans',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const Text(
                                      'Fairness score',
                                      style: TextStyle(
                                        color: Color(0xFF606060),
                                        fontSize: 10,
                                        fontFamily: 'Open Sans',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )
                                  ],
                                )),
                          ],
                        ),
                        SizedBox(
                          child: ReadMoreText(
                            "${clauseresult?.clauseAnalysis?.fairness?.clauseFairness}",
                            trimMode: TrimMode.Line,
                            trimLines: 5,
                            trimCollapsedText: 'Read more',
                            trimExpandedText: 'Read less',
                            lessStyle: const TextStyle(
                              color: AppColors.textcolor,
                              fontSize: 14,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w600,
                            ),
                            moreStyle: const TextStyle(
                              color: AppColors.textcolor,
                              fontSize: 14,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Clause risk scores',
                              style: TextStyle(
                                color: Color(0xFF404040),
                                fontSize: 14,
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SvgPicture.asset(
                              SvgIcons.snakbarInfo,
                              fit: BoxFit.cover,
                              color: Colors.grey,
                              height: 20,
                              width: 20,
                            ),
                          ],
                        )),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircularPercentIndicator(
                              animation: true,
                              animationDuration: 500,
                              radius: 35.0,
                              lineWidth: 10.0,
                              percent: (clauseresult?.clauseAnalysis?.risk?.first.party1Score ?? 0.0) / 100.0,
                              center: Text("${clauseresult?.clauseAnalysis?.risk?.first.party1Score}"),
                              progressColor: AppColors.invalidColor,
                              footer: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: 150,
                                  child: Text(
                                    "${clauseresult?.clauseAnalysis?.risk?.first.party1Name}",
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              ),
                            ),
                            CircularPercentIndicator(
                              animation: true,
                              animationDuration: 500,
                              radius: 35.0,
                              lineWidth: 10.0,
                              percent: (clauseresult?.clauseAnalysis?.risk?.first.party2Score ?? 0.0) / 100.0,
                              center: Text("${clauseresult?.clauseAnalysis?.risk?.first.party2Score}"),
                              progressColor: AppColors.greenColor,
                              footer: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                    width: 150,
                                    child: Text(
                                      "${clauseresult?.clauseAnalysis?.risk?.first.party2Name}",
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.visible,
                                    )),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          child: ReadMoreText(
                            "${clauseresult?.clauseAnalysis?.risk?.first.riskAnalysis}",
                            trimMode: TrimMode.Line,
                            trimLines: 4,
                            trimCollapsedText: 'Show more',
                            trimExpandedText: 'Show less',
                            lessStyle: const TextStyle(
                              color: AppColors.textcolor,
                              fontSize: 14,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w600,
                            ),
                            moreStyle: const TextStyle(
                              color: AppColors.textcolor,
                              fontSize: 14,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                //  Clause Legibility
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Clause Legibility',
                                style: TextStyle(
                                  color: AppColors.blacktxtColor,
                                  fontSize: 14,
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SvgPicture.asset(
                                SvgIcons.snakbarInfo,
                                fit: BoxFit.cover,
                                color: Colors.grey,
                                height: 20,
                                width: 20,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Color(0xFFFFF3EB)),
                              child: SvgPicture.asset(height: 20, width: 20, SvgIcons.voiceActivateSvgIcons),
                            ),
                            Expanded(
                              child: ListTile(
                                  title: const Text("Readability score"),
                                  subtitle: const Text("Max: 30   Min: -30"),
                                  trailing: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: AppColors.disableColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    width: 77.5,
                                    height: 33,
                                    child: Text("${clauseresult?.clauseAnalysis?.legibility?.fkGrade}"),
                                  )),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Color(0xFFFFF3EB)),
                              child: SvgPicture.asset(height: 20, width: 20, SvgIcons.userSimulationSvgIcons),
                            ),
                            Expanded(
                              child: ListTile(
                                title: const Text("Interpretation score"),
                                subtitle: const Text("Max: 30   Min: -30"),
                                trailing: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: AppColors.disableColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  width: 77.5,
                                  height: 33,
                                  child: Text("${clauseresult?.clauseAnalysis?.legibility?.smogIndex}"),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
// purpose of application

                const SizedBox(
                  height: 20,
                ),

                //
                Theme(
                  data: ThemeData(
                    dividerColor: Colors.transparent,
                    expansionTileTheme: const ExpansionTileThemeData(
                      backgroundColor: Colors.white,
                    ),
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    child: ExpansionTile(
                      textColor: AppColors.textcolor,
                      iconColor: AppColors.textcolor,
                      leading: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.greenHalf,
                        ),
                      ),
                      title: const Text('Purpose & implications'),
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Text("${clauseresult?.clauseAnalysis?.purposeAndImplications}"),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
//Strengths
                Theme(
                  data: ThemeData(
                    dividerColor: Colors.transparent,
                    expansionTileTheme: const ExpansionTileThemeData(
                      backgroundColor: Colors.white,
                    ),
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    child: ExpansionTile(
                      textColor: AppColors.textcolor,
                      iconColor: AppColors.textcolor,
                      leading: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.greenHalf,
                        ),
                      ),
                      title: const Text('Strengths'),
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Text("${clauseresult?.clauseAnalysis?.strengths}"),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                //Weakness
                Theme(
                  data: ThemeData(
                    dividerColor: Colors.transparent,
                    expansionTileTheme: const ExpansionTileThemeData(
                      backgroundColor: Colors.white,
                    ),
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    child: ExpansionTile(
                      textColor: AppColors.textcolor,
                      iconColor: AppColors.textcolor,
                      leading: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.greenHalf,
                        ),
                      ),
                      title: const Text('Weakness'),
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Text("${clauseresult?.clauseAnalysis?.weaknesses}"),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                //Negotiation Points
                Theme(
                  data: ThemeData(
                    dividerColor: Colors.transparent,
                    expansionTileTheme: const ExpansionTileThemeData(
                      backgroundColor: Colors.white,
                    ),
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    child: ExpansionTile(
                      textColor: AppColors.textcolor,
                      iconColor: AppColors.textcolor,
                      leading: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.greenHalf,
                        ),
                      ),
                      title: const Text('Negotiation Points'),
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Text("${clauseresult?.clauseAnalysis?.negotiationPoints}"),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                //Actionable Recommendations
                Theme(
                  data: ThemeData(
                    dividerColor: Colors.transparent,
                    expansionTileTheme: const ExpansionTileThemeData(
                      backgroundColor: Colors.white,
                    ),
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    child: ExpansionTile(
                      textColor: AppColors.textcolor,
                      iconColor: AppColors.textcolor,
                      leading: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.greenHalf,
                        ),
                      ),
                      title: const Text('Actionable Recommendations'),
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Text("${clauseresult?.clauseAnalysis?.actionRecommendations}"),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                //Alternative laws
                Theme(
                  data: ThemeData(
                    dividerColor: Colors.transparent,
                    expansionTileTheme: const ExpansionTileThemeData(
                      backgroundColor: Colors.white,
                    ),
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    child: ExpansionTile(
                      textColor: AppColors.textcolor,
                      iconColor: AppColors.textcolor,
                      leading: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.greenHalf,
                        ),
                      ),
                      title: const Text('Alternative laws'),
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Text("${clauseresult?.clauseAnalysis?.alternativeLaws}"),
                        ),
                      ],
                    ),
                  ),
                ),
                //Bench mark
                const SizedBox(
                  height: 20,
                ),

                Theme(
                  data: ThemeData(
                    dividerColor: Colors.transparent,
                    expansionTileTheme: const ExpansionTileThemeData(
                      backgroundColor: Colors.white,
                    ),
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    child: ExpansionTile(
                      textColor: AppColors.textcolor,
                      iconColor: AppColors.textcolor,
                      leading: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.greenHalf,
                        ),
                      ),
                      title: const Text('Bench mark'),
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Text("${clauseresult?.clauseAnalysis?.benchmark}"),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                //  Glossary of terms
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Glossary of terms',
                                style: TextStyle(
                                  color: AppColors.blacktxtColor,
                                  fontSize: 14,
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SvgPicture.asset(
                                SvgIcons.snakbarInfo,
                                fit: BoxFit.cover,
                                color: Colors.grey,
                                height: 20,
                                width: 20,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Theme(
                          data: ThemeData(
                            dividerColor: Colors.transparent,
                            expansionTileTheme: const ExpansionTileThemeData(),
                          ),
                          child: AnimatedContainer(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                            duration: const Duration(milliseconds: 300),
                            child: ExpansionTile(
                              textColor: AppColors.textcolor,
                              iconColor: AppColors.textcolor,
                              leading: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: AppColors.greenHalf,
                                ),
                              ),
                              title: const Text('Bench mark'),
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  child: Text("${clauseresult?.clauseAnalysis?.benchmark}"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),
              ],
            );

            //});
          }),
        ),
      ),
    );
  }
}
