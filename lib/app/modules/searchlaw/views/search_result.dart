import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:prajalok/app/data/serlization/lawsearchmodel.dart';
import 'package:prajalok/app/modules/searchlaw/controllers/searchlaw_controller.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:prajalok/app/utils/customer_loading.dart';

class SearcResult extends StatelessWidget {
  SearcResult({super.key});
  final controller = Get.put(SearchlawController());

  TextStyle titleTextStyle = const TextStyle(
    color: Color(0xFF0404040),
    fontSize: 14,
    fontFamily: 'Open Sans',
    fontWeight: FontWeight.w600,
  );
  TextStyle subtitleTextStyle = const TextStyle(
    color: Color(0xFF808080),
    fontSize: 14,
    fontFamily: 'Open Sans',
    fontWeight: FontWeight.w400,
    height: 1.2,
  );
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
          'Search  Result',
          style: TextStyle(
            color: AppColors.blacktxtColor,
            fontWeight: FontWeight.w600,
            fontFamily: 'Open Sans',
            fontSize: 18,
          ),
        ),
        centerTitle: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0xFFDBEEE7),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Searched for ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF1D976C),
                          fontSize: 16,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        controller.searchController.value.text,
                        style: const TextStyle(
                          color: Color(0xFF2B2B2B),
                          fontSize: 14,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  )),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Obx(() {
                  if (controller.lawSearchModel.isEmpty) {
                    return const ReusableProcessingDialog();
                  }
                  List<Law> allLaw = [];
                  for (final result in controller.lawSearchModel) {
                    for (final result2 in result.response?.laws ?? []) {
                      allLaw.add(result2);
                    }
                  }
                  return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: allLaw.length,
                      itemBuilder: (context, i) {
                        final lawsearchRes = allLaw[i];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Container(
                            width: 358,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                            ),
                            child: Theme(
                              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                iconColor: AppColors.textcolor,
                                textColor: AppColors.textcolor,
                                title: Padding(
                                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                                  child: Text(
                                    lawsearchRes.lawName.toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                children: <Widget>[
                                  ListTile(
                                    titleTextStyle: titleTextStyle,
                                    subtitleTextStyle: subtitleTextStyle,
                                    title: const Padding(
                                      padding: EdgeInsets.only(bottom: 5.0),
                                      child: Text(
                                        'Summary',
                                      ),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 4, bottom: 4),
                                      child: Text(textScaleFactor: 1.1, textAlign: TextAlign.start, lawsearchRes.lawSummary.toString()),
                                    ),
                                  ),
                                  ListTile(
                                    titleTextStyle: titleTextStyle,
                                    subtitleTextStyle: subtitleTextStyle,
                                    title: const Padding(
                                      padding: EdgeInsets.only(
                                        bottom: 5.0,
                                      ),
                                      child: Text(
                                        'Key Points',
                                      ),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: SizedBox(
                                        width: 326,
                                        child: Text(
                                          textScaleFactor: 1.1,
                                          textAlign: TextAlign.start,
                                          "${lawsearchRes.lawKeyPoints}".replaceAll(RegExp(r'^\[|\]$'), ''),
                                        ),

                                        // Markdown(
                                        //   bulletBuilder: (index, style) {
                                        //     return const Text(
                                        //       "•",
                                        //       style: TextStyle(
                                        //         fontSize: 16,
                                        //         height: 1.55,
                                        //         color: AppColors.blacktxtColor,
                                        //       ),
                                        //     );
                                        //   },
                                        //   shrinkWrap: true,
                                        //   selectable: true,
                                        //   data: "${lawsearchRes.lawKeyPoints}".replaceAll(RegExp(r'^\[|\]$'), ''),
                                        // ),
                                      ),
                                    ),
                                  ),

                                  //?---------------------------- Realted Lawsetion module here ---------------------------------------
                                  lawsearchRes.relatedLaws!.isEmpty
                                      ? const SizedBox()
                                      : ListTile(
                                          titleTextStyle: titleTextStyle,
                                          title: const Text('Related Laws'),
                                          subtitle: Column(
                                              children: List.generate((lawsearchRes.relatedLaws ?? []).length, (i) {
                                            final relatedLaw = lawsearchRes.relatedLaws?[i];
                                            return Padding(
                                              padding: const EdgeInsets.only(bottom: 5.0, top: 4),
                                              child: SizedBox(
                                                width: 326,
                                                child: Text.rich(
                                                  textScaleFactor: 1.1,
                                                  textAlign: TextAlign.start,
                                                  TextSpan(
                                                    children: [
                                                      // const TextSpan(
                                                      //   text: '\u2022',
                                                      //   style: TextStyle(
                                                      //     fontSize: 16,
                                                      //     height: 1.55,
                                                      //   ),
                                                      // ),
                                                      TextSpan(
                                                        text: '${relatedLaw?.nameOfRelatedLaw}:  ',
                                                        style: const TextStyle(
                                                          color: Color(0xFF202020),
                                                          fontSize: 14,
                                                          fontFamily: 'Open Sans',
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: '${relatedLaw?.descriptionOfRelatedLaw}',
                                                        style: const TextStyle(
                                                          height: 1.0,
                                                          color: Color(0xFF808080),
                                                          fontSize: 14,
                                                          fontFamily: 'Open Sans',
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );

                                            // ListTile(
                                            //   titleTextStyle: titleTextStyle,
                                            //   subtitleTextStyle: subtitleTextStyle,
                                            //   title: Padding(
                                            //     padding: const EdgeInsets.only(bottom: 4),
                                            //     child: Text("${relatedLaw?.nameOfRelatedLaw}"),
                                            //   ),
                                            //   subtitle: Padding(
                                            //     padding: const EdgeInsets.only(left: 3),
                                            //     child: SizedBox(
                                            //       width: 326,
                                            //       child: Text("${relatedLaw?.descriptionOfRelatedLaw}"),
                                            //     ),
                                            //   ),
                                            // );
                                          }))),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
