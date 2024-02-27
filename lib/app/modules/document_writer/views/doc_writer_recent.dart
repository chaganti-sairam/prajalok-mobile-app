import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prajalok/app/data/serlization/doc_generation_model.dart';
import 'package:prajalok/app/data/serlization/staticlegaldocumentsModel.dart';
import 'package:prajalok/app/dateUtils.dart';
import 'package:prajalok/app/utils/api_const.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:prajalok/app/utils/widgetButton.dart';
import '../controllers/document_write_controller.dart';
import 'generated_document.dart';

void RecentDocWriter(context) {
  final controller = Get.put(DocumentWriteController());
  final docGenerationModel = <DocGenerationModel>[].obs;
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
                      'Recent DocWriter',
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
                    child: StreamBuilder(
                        stream: supabase
                            .schema(ApiConst.documentwriter)
                            .from("doc_generations")
                            .stream(primaryKey: ["id"])
                            .eq("profile_id", controller.uuid.toString())
                            .order("created_at", ascending: false),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (!snapshot.hasData) {
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
                              ),
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
                          docGenerationModel.value = res.map((e) => DocGenerationModel.fromJson(e)).toList(growable: false);
                          if (docGenerationModel.isEmpty) {
                            return const CircularProgressIndicator();
                          }
                          return ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: docGenerationModel.length,
                              itemBuilder: (context, i) {
                                final docGenerationRes = docGenerationModel[i];
                                String getTimeAgo() {
                                  return DateUtilssll.getTimeAgo(docGenerationRes.createdAt ?? DateTime.now());
                                }

                                final List<StaticLegalDocumentsModel> res1 =
                                    controller.staticLegalDocumentsModel.where((element) => element.id == docGenerationRes.legalDocumentId).toList();
                                if (res.isEmpty) {
                                  return const CircularProgressIndicator();
                                }

                                return WidgetButtonPress(
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(
                                        () => GeneratedDocument(
                                          profileId: docGenerationRes.id ?? 0.toInt(),
                                        ),
                                      );
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
                                                    docGenerationRes.title ?? "".removeAllWhitespace,
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
                                                    color: docGenerationRes.status == "completed"
                                                        ? AppColors.greenHalf
                                                        : docGenerationRes.status == "processing"
                                                            ? AppColors.stausYellowHalfColor
                                                            : docGenerationRes.status == "draft_write"
                                                                ? AppColors.invalidColor
                                                                : null,
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                  child: Text(
                                                    textAlign: TextAlign.justify,
                                                    docGenerationRes.status == "completed"
                                                        ? "Successful"
                                                        : docGenerationRes.status == "processing"
                                                            ? "In Progress"
                                                            : docGenerationRes.status == "draft_write"
                                                                ? "Faild"
                                                                : "",
                                                    style: TextStyle(
                                                      color: docGenerationRes.status == "completed"
                                                          ? AppColors.greenColor
                                                          : docGenerationRes.status == "processing"
                                                              ? AppColors.textcolor
                                                              : docGenerationRes.status == "draft_write"
                                                                  ? Colors.white
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
                                              children: <Widget>[
                                                AutoSizeText(
                                                  res1.isEmpty ? "loading.." : res1.first.docSubCategory ?? "not found",
                                                  style: const TextStyle(
                                                    color: AppColors.textcolor,
                                                    fontSize: 12,
                                                    fontFamily: 'Open Sans',
                                                    fontWeight: FontWeight.w600,
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

                          // ListView.builder(
                          //     physics: const BouncingScrollPhysics(),
                          //     itemCount: docGenerationModel.length,
                          //     itemBuilder: (context, i) {
                          //       final docGenerationRes = docGenerationModel[i];
                          //       print("docGenerationResdocGenerationRes ${docGenerationRes.id}");
                          //       DateTime now = DateTime.now();
                          //       Duration difference = now.difference(docGenerationRes.createdAt ?? DateTime.now());
                          //       return WidgetButtonPress(
                          //         child: InkWell(
                          //           onTap: () {
                          //             Get.to(GeneratedDocument(
                          //               profileId: docGenerationRes.id ?? 0.toInt(),
                          //             ));
                          //           },
                          //           child: Padding(
                          //             padding: const EdgeInsets.all(4),
                          //             child: ColoredBox(
                          //               color: Colors.white,
                          //               child: Card(
                          //                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          //                 color: Colors.white,
                          //                 elevation: 0.5,
                          //                 child: ListTile(
                          //                     title: AutoSizeText(
                          //                       textAlign: TextAlign.justify,
                          //                       docGenerationRes.title ?? '',
                          //                       style: const TextStyle(
                          //                         color: Color(0xFF404040),
                          //                         fontSize: 16,
                          //                         fontFamily: 'Open Sans',
                          //                         fontWeight: FontWeight.w600,
                          //                         letterSpacing: 0.16,
                          //                       ),
                          //                       maxLines: 2,
                          //                     ),
                          //                     subtitle: Row(
                          //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //                       children: [
                          //                         AutoSizeText(
                          //                           "${difference.inDays} days, ${difference.inHours.remainder(24)} hours",
                          //                           textAlign: TextAlign.justify,
                          //                           style: const TextStyle(
                          //                             color: Color(0xFF9F9F9F),
                          //                             fontSize: 12,
                          //                             fontFamily: 'Open Sans',
                          //                             fontWeight: FontWeight.w400,
                          //                             letterSpacing: 0.12,
                          //                           ),
                          //                         ),
                          //                         Container(
                          //                           decoration: BoxDecoration(
                          //                             color: docGenerationRes.status == "completed"
                          //                                 ? AppColors.greenHalf
                          //                                 : docGenerationRes.status == "processing"
                          //                                     ? AppColors.stausYellowHalfColor
                          //                                     : docGenerationRes.status == "draft_write"
                          //                                         ? AppColors.invalidColor
                          //                                         : null,
                          //                             borderRadius: BorderRadius.circular(12),
                          //                           ),
                          //                           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          //                           child: Text(
                          //                             textAlign: TextAlign.justify,
                          //                             docGenerationRes.status == "completed"
                          //                                 ? "Successful"
                          //                                 : docGenerationRes.status == "processing"
                          //                                     ? "In Progress"
                          //                                     : docGenerationRes.status == "draft_write"
                          //                                         ? "Faild"
                          //                                         : "",
                          //                             style: TextStyle(
                          //                               color: docGenerationRes.status == "completed"
                          //                                   ? AppColors.greenColor
                          //                                   : docGenerationRes.status == "processing"
                          //                                       ? AppColors.textcolor
                          //                                       : docGenerationRes.status == "draft_write"
                          //                                           ? Colors.white
                          //                                           : null,
                          //                               fontSize: 12,
                          //                               fontFamily: 'Open Sans',
                          //                               fontWeight: FontWeight.w600,
                          //                             ),
                          //                           ),
                          //                         ),
                          //                       ],
                          //                     )),
                          //               ),
                          //             ),
                          //           ),
                          //         ),
                          //       );
                          //     });
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
