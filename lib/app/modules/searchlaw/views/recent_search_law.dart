import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prajalok/app/data/serlization/lawsearchmodel.dart';
import 'package:prajalok/app/dateUtils.dart';
import 'package:prajalok/app/modules/searchlaw/controllers/searchlaw_controller.dart';
import 'package:prajalok/app/utils/api_const.dart';
import 'package:prajalok/app/utils/widgetButton.dart';

import 'search_result.dart';

void RecentSearchideSheet(context) {
  final controller = Get.put(SearchlawController());
  showGeneralDialog(
    context: context,
    barrierColor: Colors.black54,
    barrierDismissible: true,
    barrierLabel: 'Label',
    pageBuilder: (_, __, ___) {
      final lawSearchModel = <LawSearchModel>[].obs;
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
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    title: const Text(
                      'Recent searches',
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
                            .schema(ApiConst.staticshema)
                            .from("law_search")
                            .select()
                            .eq("profile_id", controller.uuid.toString())
                            .order("created_at", ascending: false),
                        builder: (context, snapshoht) {
                          if (snapshoht.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (!snapshoht.hasData) {
                            return const Center(
                                child: Text(
                              'No activity',
                              style: TextStyle(
                                color: Color(0xFFFF5C40),
                                fontSize: 20,
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.w600,
                              ),
                            ));
                          } else if (snapshoht.hasError) {
                            return const Center(
                                child: Text(
                              'error',
                              style: TextStyle(
                                color: Color(0xFFFF5C40),
                                fontSize: 20,
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.w600,
                              ),
                            ));
                          }

                          if (snapshoht.data == null) {
                            return const Center(
                                child: Text(
                              'No activity',
                              style: TextStyle(
                                color: Color(0xFFFF5C40),
                                fontSize: 20,
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.w600,
                              ),
                            ));
                          }

                          final res = snapshoht.data as List;
                          lawSearchModel.value = res.map((e) => LawSearchModel.fromJson(e)).toList(growable: false);

                          return ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: lawSearchModel.length,
                              itemBuilder: (context, i) {
                                final lawsearchRes = lawSearchModel[i];
                                String getTimeAgo() {
                                  return DateUtilssll.getTimeAgo(lawsearchRes.createdAt ?? DateTime.now());
                                }

                                return WidgetButtonPress(
                                  child: InkWell(
                                    onTap: () {
                                      controller.searchController.value.text = lawsearchRes.title.toString();
                                      controller.queryId.value = lawsearchRes.id ?? 0.toInt();
                                      controller.fetchData();
                                      Future.delayed(Duration.zero, () {
                                        Get.to(() => SearcResult());
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: Center(
                                        child: ListTile(
                                          title: AutoSizeText(
                                            lawsearchRes.title ?? '',
                                            style: const TextStyle(
                                              color: Color(0xFF404040),
                                              fontSize: 16,
                                              fontFamily: 'Open Sans',
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 0.16,
                                            ),
                                            maxLines: 2,
                                          ),

                                          subtitle: Align(
                                            alignment: Alignment.bottomRight,
                                            child: Text(getTimeAgo()),
                                          ),

                                          //  Row(
                                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          //   children: [
                                          //     AutoSizeText(
                                          //       "${difference.inDays} days, ${difference.inHours.remainder(24)} hours",
                                          //       textAlign: TextAlign.left,
                                          //       style: const TextStyle(
                                          //         color: Color(0xFF9F9F9F),
                                          //         fontSize: 12,
                                          //         fontFamily: 'Open Sans',
                                          //         fontWeight: FontWeight.w400,
                                          //         letterSpacing: 0.12,
                                          //       ),
                                          //     ),
                                          //     Container(
                                          //       decoration: BoxDecoration(
                                          //         color: lawsearchRes.title != null
                                          //             ? AppColors.greenHalf
                                          //             : lawsearchRes.title == null
                                          //                 ? AppColors.stausYellowHalfColor
                                          //                 : null,
                                          //         borderRadius: BorderRadius.circular(12),
                                          //       ),
                                          //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          //       child: Text(
                                          //         lawsearchRes.title != null
                                          //             ? "Successful"
                                          //             : lawsearchRes.title == null
                                          //                 ? "Failed"
                                          //                 : "",
                                          //         style: TextStyle(
                                          //           color: lawsearchRes.title != null
                                          //               ? AppColors.greenColor
                                          //               : lawsearchRes.title == null
                                          //                   ? AppColors.invalidColor
                                          //                   : null,
                                          //           fontSize: 12,
                                          //           fontFamily: 'Open Sans',
                                          //           fontWeight: FontWeight.w600,
                                          //         ),
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),
                                        ),
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
        ),
      );
    },
  );
}
