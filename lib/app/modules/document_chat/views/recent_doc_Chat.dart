import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prajalok/app/data/serlization/doc_talk_sessionModel.dart';
import 'package:prajalok/app/dateUtils.dart';
import 'package:prajalok/app/utils/api_const.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:prajalok/app/utils/widgetButton.dart';

import '../controllers/document_chat_controller.dart';
import 'docChat_chat.dart';

void RecentDocChatSheet(context) {
  final controller = Get.put(DocumentChatController());
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
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    automaticallyImplyLeading: false,
                    // IconButton(
                    //   onPressed: () {
                    //     Get.back();
                    //   },
                    //   icon: const Icon(
                    //     Icons.arrow_back,
                    //     color: Colors.black,
                    //   ),
                    // ),
                    title: const Text(
                      'Recent DocChat',
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
                            .schema(ApiConst.doctalkShema)
                            .from("sessions")
                            .stream(primaryKey: ["id"])
                            .eq("profile_id", controller.uuid.toString())
                            .order("created_at", ascending: false),
                        builder: (context, snapshoht) {
                          if (!snapshoht.hasData) {
                            if (snapshoht.connectionState == ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
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
                          if (kDebugMode) {
                            print("777777777777777 ${snapshoht.data}");
                          }
                          final res = snapshoht.data as List;
                          controller.docTalkSessionModel.value = res.map((json) => DocTalkSessionModel.fromJson(json)).toList();

                          return ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: controller.docTalkSessionModel.length,
                              itemBuilder: (context, i) {
                                final docTalkSessionModelRes = controller.docTalkSessionModel[i];
                                String getTimeAgo() {
                                  return DateUtilssll.getTimeAgo(docTalkSessionModelRes.createdAt ?? DateTime.now());
                                }

                                return WidgetButtonPress(
                                  child: InkWell(
                                    onTap: () {
                                      controller.sessionId.value = docTalkSessionModelRes.id ?? 0;
                                      Future.delayed(Duration.zero, () {
                                        Get.to(() => DocChat());
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(6),
                                      child: Container(
                                        width: 296,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: Colors.white,
                                        ),
                                        child: SizedBox(
                                          width: 264,
                                          child: ListTile(
                                            title: AutoSizeText(
                                              docTalkSessionModelRes.title ?? "".removeAllWhitespace,
                                              style: const TextStyle(
                                                color: Color(0xFF404040),
                                                fontSize: 16,
                                                fontFamily: 'Open Sans',
                                                fontWeight: FontWeight.w400,
                                              ),
                                              maxLines: 2,
                                            ),
                                            trailing: Column(
                                              children: [
                                                SizedBox(height: 6),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: docTalkSessionModelRes.status == "completed"
                                                        ? AppColors.greenHalf
                                                        : docTalkSessionModelRes.status == "processing"
                                                            ? AppColors.stausYellowHalfColor
                                                            : docTalkSessionModelRes.status == "error"
                                                                ? AppColors.stausYellowHalfColor
                                                                : null,
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                  child: Text(
                                                    docTalkSessionModelRes.status == "completed"
                                                        ? "Ready"
                                                        : docTalkSessionModelRes.status == "processing"
                                                            ? "Processing"
                                                            : docTalkSessionModelRes.status == "error"
                                                                ? "Failed"
                                                                : "",
                                                    style: TextStyle(
                                                      color: docTalkSessionModelRes.status == "completed"
                                                          ? AppColors.greenColor
                                                          : docTalkSessionModelRes.status == "processing"
                                                              ? AppColors.textcolor
                                                              : docTalkSessionModelRes.status == "error"
                                                                  ? AppColors.invalidColor
                                                                  : null,
                                                      fontSize: 12,
                                                      fontFamily: 'Open Sans',
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 5),
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
