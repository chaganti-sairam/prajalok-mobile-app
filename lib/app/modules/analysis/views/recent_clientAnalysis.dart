import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prajalok/app/dateUtils.dart';
import 'package:prajalok/app/utils/api_const.dart';
import 'package:prajalok/app/utils/widgetButton.dart';
import '../../../data/serlization/client_queryModel.dart';
import '../controllers/analysis_controller.dart';
import 'issue_analysis.dart';

//
// ignore: non_constant_identifier_names
void RecentClientAnlysisSheet(context) {
  final controller = Get.put(AnalysisController());
  final clientQueryModel = <ClientQueryModel>[].obs;

  showGeneralDialog(
    context: context,
    barrierColor: Colors.black54,
    barrierDismissible: true,
    barrierLabel: 'Label',
    pageBuilder: (_, __, ___) {
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
                      'Recent  Client Query',
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
                            .schema(ApiConst.clientShema)
                            .from("client_query")
                            .select()
                            .eq("profile_id", controller.uuid)
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
                                height: 0.06,
                                letterSpacing: 0.20,
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
                                height: 0.06,
                                letterSpacing: 0.20,
                              ),
                            ));
                          }

                          final res = snapshoht.data as List;
                          clientQueryModel.value = res.map((e) => ClientQueryModel.fromJson(e)).toList(growable: false);
                          return ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: clientQueryModel.length,
                              itemBuilder: (context, i) {
                                final clientQueryRes = clientQueryModel[i];
                                String getTimeAgo() {
                                  return DateUtilssll.getTimeAgo(clientQueryRes.createdAt ?? DateTime.now());
                                }

                                return WidgetButtonPress(
                                  child: InkWell(
                                    onTap: () {
                                      controller.userQueryController.value.text = clientQueryRes.query.toString();
                                      controller.queryId.value = clientQueryRes.id ?? 0.toInt();
                                      controller.fetchData();
                                      //  Future.delayed(Duration.zero, () {
                                      Get.to(IssuAnalysis());
                                      //  });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(6),
                                      child: Container(
                                        width: 296,
                                        //height: 58,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: Colors.white,
                                        ),
                                        child: SizedBox(
                                          width: 264,
                                          child: ListTile(
                                            title: AutoSizeText(
                                              clientQueryRes.query ?? '',
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

                                            //  AutoSizeText(
                                            //   "${difference.inDays} days, ${difference.inHours.remainder(24)} hours",
                                            //   textAlign: TextAlign.left,
                                            //   style: const TextStyle(
                                            //     color: Color(0xFF9F9F9F),
                                            //     fontSize: 12,
                                            //     fontFamily: 'Open Sans',
                                            //     fontWeight: FontWeight.w400,
                                            //     letterSpacing: 0.12,
                                            //   ),
                                            // )
                                          ),
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
