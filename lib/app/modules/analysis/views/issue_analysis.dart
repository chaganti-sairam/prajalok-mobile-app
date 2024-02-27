import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prajalok/app/data/serlization/client_queryModel.dart';
import 'package:prajalok/app/modules/analysis/controllers/analysis_controller.dart';
import 'package:prajalok/app/utils/customer_loading.dart';
import 'package:prajalok/app/utils/icons_const.dart';
import 'package:prajalok/app/utils/widget_const.dart';
import '../../../utils/color_const.dart';
import 'requirment_view.dart';

class IssuAnalysis extends StatelessWidget {
  IssuAnalysis({super.key});
  final issuAnalysisC = Get.put(AnalysisController());

  TextStyle titleTextStyle = GoogleFonts.openSans(
    color: AppColors.blacktxtColor2,
    fontSize: 14,
    //fontFamily: 'Open Sans',
    fontWeight: FontWeight.bold,
  );

  TextStyle subtitleTextStyle = GoogleFonts.openSans(
    color: AppColors.grey44,
    fontSize: 14,
    //   fontFamily: 'Open Sans',
    fontWeight: FontWeight.w400,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Analysis',
        onActionPressed: () {
          issuAnalysisC.fetchData();
        },
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: SizedBox(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Obx(() {
                    if (issuAnalysisC.clientQueryModel.isEmpty) {
                      return const Center(
                        child: ReusableProcessingDialog(),
                      );
                    }
                    Answer? res;
                    ClientQueryModel? re;
                    for (re in issuAnalysisC.clientQueryModel) {
                      for (res in re.answer ?? []) {
                        if (kDebugMode) {
                          print("Amreshshsh ${res?.title ?? ''}");
                        }
                      }
                    }

                    return Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(width: 1, color: const Color(0xFFEFEFEF)),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x0A000000),
                                blurRadius: 16,
                                offset: Offset(0, 1),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                res?.title ?? '',
                                style: colorbuttonTextStyle,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                res?.refinedQuery ?? '',
                                style: const TextStyle(
                                  color: Color(0xFF707070),
                                  fontSize: 14,
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        //??
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.greenHalf,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(width: 1, color: AppColors.greenColor),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x0A000000),
                                blurRadius: 16,
                                offset: Offset(0, 1),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 200,
                                child: Text(
                                  'Do you find the provided results useful ?',
                                  style: TextStyle(
                                    color: Color(0xFF707070),
                                    fontSize: 14,
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    SvgIcons.thumsupIcons,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  SvgPicture.asset(
                                    SvgIcons.crossIcons,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        Container(
                          // width: 358,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(width: 1, color: const Color(0xFFEFEFEF)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  ),
                                  gradient: AppColors.linearGradient,
                                ),
                                child: Text(
                                  'Immediate action',
                                  style: GoogleFonts.openSans(
                                    fontSize: 14,
                                    color: Colors.white,
                                    //   fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Column(
                                  children: List.generate(res?.immediateActions?.length ?? 0, (i) {
                                final immidateAction = res?.immediateActions?[i];
                                return Padding(
                                  padding: const EdgeInsets.only(left: 0, top: 5, bottom: 5),
                                  child: SizedBox(
                                    // width: 300,
                                    child: ListTile(
                                      titleTextStyle: titleTextStyle,
                                      subtitleTextStyle: subtitleTextStyle,
                                      title: Text(
                                        "${immidateAction?.actionTitles}",
                                      ),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          "${immidateAction?.actionDescription}",
                                          textAlign: TextAlign.justify,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }))
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          //width: 358,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(width: 1, color: const Color(0xFFEFEFEF)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  ),
                                  gradient: AppColors.linearGradient,
                                ),
                                child: Text(
                                  'Documentary Evidence',
                                  style: GoogleFonts.openSans(
                                    fontSize: 14,
                                    color: Colors.white,
                                    // fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Column(
                                  children: List.generate(res?.evidences?.length ?? 0, (i) {
                                final evidencess = res?.evidences?[i];
                                return Padding(
                                  padding: const EdgeInsets.only(left: 0, top: 5, bottom: 5),
                                  child: SizedBox(
                                    // width: 300,
                                    child: ListTile(
                                      titleTextStyle: titleTextStyle,
                                      subtitleTextStyle: subtitleTextStyle,
                                      title: Text(
                                        "${evidencess?.documentName}",
                                      ),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          "${evidencess?.documentNotice}",
                                          textAlign: TextAlign.justify,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }))
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          //width: 358,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(width: 1, color: Color(0xFFEFEFEF)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  ),
                                  gradient: AppColors.linearGradient,
                                ),
                                child: Text(
                                  'Law References',
                                  style: GoogleFonts.openSans(
                                    fontSize: 14,
                                    color: Colors.white,
                                    // fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Column(
                                children: List.generate(res?.lawReferences?.length ?? 0, (i) {
                                  final lawReferences = res?.lawReferences?[i];
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 0, top: 5, bottom: 5),
                                    child: SizedBox(
                                      //  width: 300,
                                      child: ListTile(
                                        titleTextStyle: titleTextStyle,
                                        subtitleTextStyle: subtitleTextStyle,
                                        title: Text(
                                          "${lawReferences?.lawTitle}",
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.only(top: 4),
                                          child: Text(
                                            "${lawReferences?.lawDescription}",
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          //  width: 358,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(width: 1, color: const Color(0xFFEFEFEF)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  ),
                                  gradient: AppColors.linearGradient,
                                ),
                                child: Text(
                                  'Next Step',
                                  style: GoogleFonts.openSans(
                                    fontSize: 14,
                                    color: Colors.white,
                                    //  fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Column(
                                children: List.generate(res?.nextSteps?.length ?? 0, (i) {
                                  final nextSteps = res?.nextSteps?[i];
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 0, top: 5, bottom: 5),
                                    child: SizedBox(
                                      // width: 300,
                                      child: ListTile(
                                        titleTextStyle: titleTextStyle,
                                        subtitleTextStyle: subtitleTextStyle,
                                        title: Text(
                                          "${nextSteps?.stepTitle}",
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.only(top: 4),
                                          child: Text(
                                            "${nextSteps?.stepDescription}",
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        Container(
                          //  width: 358,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(width: 1, color: AppColors.textcolor),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    margin: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: AppColors.gradientOppcityColor,
                                    ),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        SvgIcons.userSetings,
                                        fit: BoxFit.cover,
                                        height: 20,
                                        width: 20,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    " Tips",
                                    style: GoogleFonts.openSans(
                                      color: Color(0xFF404040),
                                      fontSize: 14,
                                      // fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: List.generate(res?.lawReferences?.length ?? 0, (i) {
                                  final lawReferences = res?.lawReferences?[i];
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 5, top: 0, bottom: 5),
                                    child: SizedBox(
                                      //  width: 300,
                                      child: ListTile(
                                        titleTextStyle: titleTextStyle,
                                        subtitleTextStyle: subtitleTextStyle,
                                        title: Text(
                                          "${lawReferences?.lawTitle}",
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.only(top: 5, bottom: 5),
                                          child: Text(
                                            "${lawReferences?.lawDescription}",
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),

                                        // Markdown(
                                        //   styleSheet: MarkdownStyleSheet(
                                        //     pPadding: EdgeInsets.zero,
                                        //     listBulletPadding: EdgeInsets.zero,
                                        //     listBullet: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                                        //   ),
                                        //   bulletBuilder: (index, style) {
                                        //     return const Text(
                                        //       "•",
                                        //       style: TextStyle(fontWeight: FontWeight.bold),
                                        //     );
                                        //   },
                                        //   physics: const BouncingScrollPhysics(),
                                        //   shrinkWrap: true,
                                        //   selectable: true,
                                        //   data: "* ${lawReferences?.lawDescription}",
                                        // ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),

                        //?? other information

                        const SizedBox(
                          height: 20,
                        ),

                        Container(
                          //    width: 358,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(width: 1, color: AppColors.textcolor),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    margin: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: AppColors.gradientOppcityColor,
                                    ),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        SvgIcons.userSetings,
                                        fit: BoxFit.cover,
                                        height: 20,
                                        width: 20,
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    " Other Inforamation",
                                    style: TextStyle(
                                      color: Color(0xFF404040),
                                      fontSize: 14,
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: List.generate(res?.otherImportantInformation?.length ?? 0, (i) {
                                  final lawReferences = res?.otherImportantInformation?[i];
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 5, top: 0, bottom: 0),
                                    child: SizedBox(
                                      //  width: 300,
                                      child: ListTile(
                                        titleTextStyle: titleTextStyle,
                                        subtitleTextStyle: subtitleTextStyle,
                                        title: const Text(
                                          "Other Important Information",
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.only(top: 5, bottom: 5),
                                          child: Text(
                                            "${lawReferences?.informationDescription}",
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),

                                        // Markdown(
                                        //   styleSheet: MarkdownStyleSheet(
                                        //     textAlign: WrapAlignment.start,
                                        //     pPadding: EdgeInsets.zero,
                                        //     listBulletPadding: EdgeInsets.zero,
                                        //   ),
                                        //   bulletBuilder: (index, style) {
                                        //     return const Text(
                                        //       "•",
                                        //       style: TextStyle(fontWeight: FontWeight.bold),
                                        //     );
                                        //   },
                                        //   shrinkWrap: true,
                                        //   selectable: true,
                                        //   data: "* ${lawReferences?.informationDescription}",
                                        // ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
              //   width: 390,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade400,
                    offset: const Offset(0.0, 1.0),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Ready for Resolution?",
                          style: GoogleFonts.openSans(
                            color: AppColors.blacktxtColor,
                            fontSize: 16,
                            // fontFamily: 'Open Sans',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          height: 24,
                          width: 110,
                          decoration:
                              BoxDecoration(border: Border.all(width: 2, color: AppColors.textcolor), borderRadius: BorderRadius.circular(12)),
                          child: Center(
                            child: Text(
                              'How it works ?',
                              style: GoogleFonts.openSans(
                                color: AppColors.textcolor,
                                fontSize: 12,
                                // fontFamily: 'Open Sans',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: SizedBox(
                        child: Text(
                          'Our network of seasoned lawyers is eager to assist. Take the next step!',
                          style: GoogleFonts.openSans(
                            color: AppColors.blacktxtColor,
                            fontSize: 12,
                            //fontFamily: 'Open Sans',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (int i = 0; i < issuAnalysisC.RandomImages.length; i++)
                                Align(
                                  widthFactor: 0.5,
                                  child: CircleAvatar(
                                    radius: 17,
                                    backgroundImage: NetworkImage(issuAnalysisC.RandomImages[i]),
                                  ),
                                )
                            ],
                          ),
                        ),
                        SizedBox(
                          child: Text(
                            '24+Lawyers',
                            style: GoogleFonts.openSans(
                              color: const Color(0xFF1D976C),
                              fontSize: 14,
                              //fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        ReusableGradientButton(
                            height: 33,
                            gradient: AppColors.linearGradient,
                            onPressed: () {
                              Get.to(const RequirmentView());
                            },
                            child: const Text(
                              "Submit requirement",
                              style: buttonTextStyle,
                            ))
                      ],
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
