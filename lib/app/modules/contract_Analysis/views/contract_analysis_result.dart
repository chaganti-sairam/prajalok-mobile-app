import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:prajalok/app/data/serlization/contract_analysis_res_model.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:prajalok/app/utils/compnent/given_info.dart';
import 'package:prajalok/app/utils/customer_loading.dart';
import 'package:prajalok/app/utils/icons_const.dart';
import 'package:readmore/readmore.dart';
import '../controllers/contract_analysis_controller.dart';
import 'possition_responsibility.dart';

class ContractAnalysisResult extends StatelessWidget {
  ContractAnalysisResult({super.key});
  final contratAnalysisC = Get.put(ContractAnalysisController());
  final List<Widget> listWidget = [
    ContractAnalysisResultPage(),
    ClauseBy(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Contract analysis result"),
        actions: [
          IconButton(
            splashRadius: 20,
            onPressed: () {
              GivenInputInfoSheet(context, contratAnalysisC.contractAnalysisResponseModel, true, /*isinputdocurl*/ false);
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
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              color: Colors.white,
              height: 50,
              width: double.infinity,
              child: Obx(() {
                return ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: contratAnalysisC.listOfTitles.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox();
                  },
                  itemBuilder: (_, i) {
                    return SizedBox(
                      height: 34,
                      child: InkWell(
                        onTap: () {
                          contratAnalysisC.changeSateFunc(contratAnalysisC.currentIndex.value + i);
                          contratAnalysisC.pageController.animateToPage(
                            i,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
                        },
                        child: Obx(() => Container(
                              height: 30,
                              decoration: BoxDecoration(
                                color: contratAnalysisC.currentIndex.value == i ? AppColors.textcolor : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  const SizedBox(width: 8),
                                  Obx(
                                    () => Text(
                                      contratAnalysisC.listOfTitles[i],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: contratAnalysisC.currentIndex.value == i ? Colors.white : AppColors.disableColor,
                                        fontSize: 12,
                                        fontFamily: "opne Sans",
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ),
                    );
                  },
                );
              }),
            ),
            Expanded(
              child: PageView.builder(
                reverse: false,
                controller: contratAnalysisC.pageController,
                onPageChanged: (index) {
                  contratAnalysisC.changeSateFunc(index);
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

class ContractAnalysisResultPage extends StatelessWidget {
  ContractAnalysisResultPage({super.key});
  final contratAnalysisC = Get.put(ContractAnalysisController());
  final List<Color> barColors = [
    Color(0xFFEF1E26).withOpacity(0.80),
    Color(0xFF1D976C).withOpacity(0.80),
    Color(0xFFA00BE7).withOpacity(0.80),
    Color(0xFF0BE7D9).withOpacity(0.80),
  ];
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Obx(() {
          if (contratAnalysisC.contractAnalysisResponseModel.isEmpty) {
            return const ReusableProcessingDialog();
          }
          ContractAnalysisResponseModel? re;
          for (re in contratAnalysisC.contractAnalysisResponseModel) {
            // if (kDebugMode) {
            //   print("dddddddddddd ${re}");
            // }
          }
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: contratAnalysisC.contractAnalysisResponseModel.length,
            itemBuilder: (_, i) {
              final res = contratAnalysisC.contractAnalysisResponseModel[i];

              return Column(
                children: <Widget>[
                  Column(
                    children: List.generate(res.contractAnalysis?.length ?? 0, (i) {
                      final contractAnalysis1 = re?.contractAnalysis?[i];
                      return Column(
                        children: <Widget>[
                          const SizedBox(height: 10),
                          Theme(
                            data: ThemeData(
                              dividerColor: Colors.transparent,
                              expansionTileTheme: const ExpansionTileThemeData(
                                backgroundColor: Colors.white,
                              ),
                            ),
                            child: ExpansionTile(
                              textColor: AppColors.textcolor,
                              iconColor: AppColors.textcolor,
                              title: const Text(
                                "Executive summary",
                                style: TextStyle(
                                  color: Color(0xFF404040),
                                  fontSize: 14,
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                                  child: MarkdownBody(
                                    fitContent: true,
                                    data: "${contractAnalysis1?.clauseInfo?.executiveSummary}",
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Container(
                          //   width: double.infinity,
                          //   color: Colors.white,
                          //   child: Padding(
                          //     padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
                          //     child: Column(
                          //       mainAxisAlignment: MainAxisAlignment.start,
                          //       crossAxisAlignment: CrossAxisAlignment.stretch,
                          //       children: <Widget>[

                          //         const SizedBox(
                          //           child: Text(
                          //             "Executive summary",
                          //             style: TextStyle(
                          //               color: Color(0xFF404040),
                          //               fontSize: 14,
                          //               fontFamily: 'Open Sans',
                          //               fontWeight: FontWeight.w600,
                          //             ),
                          //           ),
                          //         ),
                          //         const SizedBox(height: 10),
                          //         ReadMoreText(
                          //           "${contractAnalysis1?.clauseInfo?.executiveSummary}",
                          //           trimMode: TrimMode.Line,
                          //           trimLines: 5,
                          //           trimCollapsedText: 'Show more',
                          //           trimExpandedText: 'Show less',
                          //           lessStyle: const TextStyle(
                          //             color: AppColors.textcolor,
                          //             fontSize: 14,
                          //             fontFamily: 'Open Sans',
                          //             fontWeight: FontWeight.w600,
                          //           ),
                          //           moreStyle: const TextStyle(
                          //             color: AppColors.textcolor,
                          //             fontSize: 14,
                          //             fontFamily: 'Open Sans',
                          //             fontWeight: FontWeight.w600,
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          //     Fairness of the document
                          const SizedBox(height: 20),
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
                                        'Fairness of the document',
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
                                            color: AppColors.greenHalf,
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              SvgPicture.asset(
                                                SvgIcons.docsScgIconsIcon,
                                                height: 56,
                                                width: 56,
                                              ),
                                              Text(
                                                "${contractAnalysis1?.clauseInfo?.fairnessAssessment?.fairnessPercentage}",
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
                                      "${contractAnalysis1?.clauseInfo?.fairnessAssessment?.overallAnalysis}",
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                      child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Risk analysis',
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CircularPercentIndicator(
                                        animation: true,
                                        animationDuration: 1200,
                                        reverse: true,
                                        restartAnimation: true,
                                        animateFromLastPercent: true,
                                        radius: 35.0,
                                        lineWidth: 10.0,
                                        percent: (contractAnalysis1?.clauseInfo?.riskFairness?.party1Score ?? 0.0) / 100.0,
                                        center: Text("${contractAnalysis1?.clauseInfo?.riskFairness?.party1Score}"),
                                        progressColor: AppColors.invalidColor,
                                        footer: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                            width: 150,
                                            child: Text(
                                              "${contractAnalysis1?.clauseInfo?.riskFairness?.party1Name}",
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.visible,
                                            ),
                                          ),
                                        ),
                                      ),
                                      CircularPercentIndicator(
                                        animation: true,
                                        animationDuration: 1200,
                                        reverse: true,
                                        restartAnimation: true,
                                        animateFromLastPercent: true,
                                        radius: 35.0,
                                        lineWidth: 10.0,
                                        percent: (contractAnalysis1?.clauseInfo?.riskFairness?.party2Score ?? 0.0) / 100.0,
                                        center: Text("${contractAnalysis1?.clauseInfo?.riskFairness?.party2Score}"),
                                        progressColor: AppColors.greenColor,
                                        footer: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                              width: 150,
                                              child: Text(
                                                "${contractAnalysis1?.clauseInfo?.riskFairness?.party2Name}",
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.visible,
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    child: ReadMoreText(
                                      "${contractAnalysis1?.clauseInfo?.riskFairness?.riskAnalysis}",
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
                          SizedBox(height: 20),
                          //  Liblity
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
                                          'Legibility',
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
                                              child: Text("${contractAnalysis1?.clauseInfo?.legibilityScore?.fkGrade?.floor()}"),
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
                                            child: Text("${contractAnalysis1?.clauseInfo?.legibilityScore?.smogIndex?.floor()}"),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
// Risk Assement
                          SizedBox(height: 20),
                          Container(
                            height: 300,
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
                                          'Risk assessment',
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
                                  Container(
                                    height: 210,
                                    width: double.infinity,
                                    child: CustomPaint(
                                      painter: BarChartPainter(
                                          contractAnalysis1?.clauseInfo?.riskType?.risks
                                                  ?.map((e) => e.percentage?.toDouble() ?? 0.0) // Convert int? to double, handle null case
                                                  .toList(growable: false) ??
                                              [],
                                          barColors,
                                          contractAnalysis1?.clauseInfo?.riskType?.risks?.map((e) => e.riskName ?? "").toList(growable: false) ?? []),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                  //     Fairness of the document
                  const SizedBox(height: 20),
                ],
              );
            },
          );
        }),
      ),
    );
  }
}

class ClauseBy extends StatelessWidget {
  ClauseBy({super.key});
  final contratAnalysisC = Get.put(ContractAnalysisController());
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Obx(() {
          if (contratAnalysisC.contractAnalysisResponseModel.isEmpty) {
            return const ReusableProcessingDialog();
          }
          return ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: contratAnalysisC.contractAnalysisResponseModel.length,
              itemBuilder: (_, i) {
                final res = contratAnalysisC.contractAnalysisResponseModel[i];
                ContractAnalysis? re;
                //  ClauseAnalysisElement? result;
                for (re in res.contractAnalysis ?? []) {
                  print(re);
                }

                return SizedBox(
                    child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: re?.clauseAnalysis?.length,
                        itemBuilder: (_, i) {
                          final result = re?.clauseAnalysis?[i];
                          print("ressssssssultttttttt ${result?.clauseAnalysis?.clauseNumber}");
                          return SizedBox(
                            height: 80,
                            child: InkWell(
                              onTap: () {
                                Get.to(
                                  () => PosstionResponsibility(clauseid: result?.clauseAnalysis?.clauseNumber ?? 0),
                                );
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                elevation: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      Row(children: [
                                        Text(
                                          "Clause ${result?.clauseAnalysis?.clauseNumber}",
                                          style: const TextStyle(
                                            color: Color(0xFF707070),
                                            fontSize: 12,
                                            fontFamily: 'Open Sans',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        SvgPicture.asset(
                                          SvgIcons.snakbarInfo,
                                          color: AppColors.greenColor,
                                          height: 20,
                                          width: 20,
                                        ),
                                      ]),
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                        SizedBox(
                                          width: 270,
                                          child: AutoSizeText(
                                            "${result?.clauseAnalysis?.clauseName}",
                                            maxLines: 2,
                                            style: const TextStyle(
                                              color: Color(0xFF505050),
                                              fontSize: 14,
                                              fontFamily: 'Open Sans',
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        const Icon(
                                          Icons.arrow_forward,
                                          size: 25,
                                          color: AppColors.disableColor,
                                        ),
                                      ])
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }));
              });
        }),
      ),
    );
  }
}

// class CustomBarChart extends StatelessWidget {
//   final List<double> data = [3, 4, 2, 4];
//   final List<String> labels = ['Financial\nrisk', 'Legal\nrisk', 'Operational\nrisk', 'Obligation\nrisk'];
//   final List<Color> barColors = [
//     const Color(0xFFEF1E26),
//     const Color(0xFF1D976C),
//     const Color(0xFFA00BE7),
//     const Color(0xFF0BE7D9),
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return

//     Container(
//       height: 136,
//       width: double.infinity,
//       child: CustomPaint(
//         painter: BarChartPainter(data, barColors, labels),
//       ),
//     );
//   }
// }

class BarChartPainter extends CustomPainter {
  final List<double> data;
  final List<Color> barColors;
  final List<String> labels;
  BarChartPainter(this.data, this.barColors, this.labels);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeCap = StrokeCap.butt
      ..strokeWidth = 0.0
      ..style = PaintingStyle.fill;
    Paint textPaint = Paint()..color = Colors.black;
    // ..fontSize = 14.0;
    double barWidth = size.width / (data.length * 2);
    for (int i = 0; i < data.length; i++) {
      paint.color = barColors[i];
      double barHeight = data[i] * 2.5;
      double x = i * barWidth * 2 + barWidth;
      double y = size.height - barHeight;
      print("hhhhhhhhhhhhh ${data[i]}");
      // Draw rounded rectangle
      RRect rect = RRect.fromLTRBR(
        x - barWidth / 4,
        y,
        x + barWidth / 4,
        size.height,
        const Radius.circular(10.0),
      );
      canvas.drawRRect(rect, paint);
      // Draw bar
      canvas.drawLine(Offset(x, size.height), Offset(x, y), paint);
      // Add label
      TextSpan span = TextSpan(
        text: labels[i].replaceAll(' ', '\n'),
        style: const TextStyle(
          fontFamily: 'Open Sans',
          fontWeight: FontWeight.w400,
          color: Colors.black,
          fontSize: 14.0,
        ),
      );

      TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      double textX = x - tp.width / 2;
      double textY = size.height + 4.0;
      tp.paint(canvas, Offset(textX, textY));
      // Add percentage
      TextSpan percentSpan = TextSpan(
        text: '${(data[i] / data.reduce((a, b) => a + b) * 100).toStringAsFixed(2)}%',
        style: TextStyle(
          color: barColors[i],
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
          fontFamily: 'Open Sans',
        ),
      );
      TextPainter percentTp = TextPainter(
        text: percentSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

      percentTp.layout();
      double percentX = x - percentTp.width / 2;
      double percentY = y - 20.0;
      percentTp.paint(canvas, Offset(percentX, percentY));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
