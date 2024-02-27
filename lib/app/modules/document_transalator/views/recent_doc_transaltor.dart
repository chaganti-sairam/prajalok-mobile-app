import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prajalok/app/data/serlization/translatedfile_model.dart';
import 'package:prajalok/app/dateUtils.dart';
import 'package:prajalok/app/utils/api_const.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:prajalok/app/utils/widgetButton.dart';
import '../controllers/document_transalator_controller.dart';
import 'translated_file_view.dart';

void RecentDocTranslatorSheet(context) {
  final controller = Get.put(DocumentTransalatorController());
  final translatedFileModel = <TranslatedFileModel>[].obs;
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
                      'Recent translations',
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
                            .schema(ApiConst.translateschema)
                            .from("translate")
                            .select()
                            .eq("profile_id", controller.uuid.toString())
                            .order("created_at", ascending: false),
                        builder: (context, snapshoht) {
                          if (!snapshoht.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
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
                          if (snapshoht.data == null) {
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
                          if (kDebugMode) {
                            print("777777777777777 ${snapshoht.data}");
                          }
                          final res = snapshoht.data as List;
                          translatedFileModel.value = res.map((json) => TranslatedFileModel.fromJson(json)).toList();

                          return ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: translatedFileModel.length,
                              itemBuilder: (context, i) {
                                final translatedFileModelRes = translatedFileModel[i];
                                controller.languageMap(translatedFileModelRes.language.toString());
                                String getTimeAgo() {
                                  return DateUtilssll.getTimeAgo(translatedFileModelRes.createdAt ?? DateTime.now());
                                }

                                return WidgetButtonPress(
                                  child: InkWell(
                                    onTap: () {
                                      controller.docTransalatedControllertext.value.text = translatedFileModelRes.inputDocUrl.toString();
                                      controller.queryId.value = translatedFileModelRes.id ?? 0;
                                      controller.fetchTranslatedData();
                                      Future.delayed(Duration.zero, () {
                                        Get.to(TranslatedIleView());
                                      });
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
                                                    translatedFileModelRes.title ?? "".removeAllWhitespace,
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
                                                    color: translatedFileModelRes.status == "completed"
                                                        ? AppColors.greenHalf
                                                        : translatedFileModelRes.status == "Processing"
                                                            ? AppColors.stausYellowHalfColor
                                                            : translatedFileModelRes.status == "error"
                                                                ? AppColors.stausYellowHalfColor
                                                                : null,
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                  child: Text(
                                                    translatedFileModelRes.status == "completed"
                                                        ? "Completed"
                                                        : translatedFileModelRes.status == "Processing"
                                                            ? "Translating"
                                                            : translatedFileModelRes.status == null
                                                                ? "Failed"
                                                                : "",
                                                    style: TextStyle(
                                                      color: translatedFileModelRes.status == "completed"
                                                          ? AppColors.greenColor
                                                          : translatedFileModelRes.status == "Processing"
                                                              ? AppColors.textcolor
                                                              : translatedFileModelRes.status == null
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
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                  decoration:
                                                      BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.chatSendTextCollor),
                                                  child: AutoSizeText(
                                                    "${controller.languageMapres}",
                                                    style: const TextStyle(
                                                      color: AppColors.textcolor,
                                                      fontSize: 12,
                                                      fontFamily: 'Open Sans',
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
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
