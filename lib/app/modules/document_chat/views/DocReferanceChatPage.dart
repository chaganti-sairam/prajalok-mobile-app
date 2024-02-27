import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:prajalok/app/utils/api_const.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:prajalok/app/utils/customer_loading.dart';
import 'package:prajalok/app/utils/icons_const.dart';
import 'package:prajalok/app/utils/re_usable_class.dart';
import 'package:prajalok/app/utils/widgetButton.dart';
import 'package:r_dotted_line_border/r_dotted_line_border.dart';
import '../../../data/serlization/newCheckFileModel.dart';
import '../../../utils/widget_const.dart';
import '../controllers/document_chat_controller.dart';

class DocReferanceChatPage extends StatelessWidget {
  DocReferanceChatPage({super.key});
  final docReferanceChat = Get.put(DocumentChatController());
  ReUsableService fileUploadService = ReUsableService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(left: 16.0, right: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    height: 255,
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 16),
                        WidgetButtonPress(
                          child: GestureDetector(
                            onTap: () {
                              if (docReferanceChat.files.length == 5) {
                                Get.snackbar(
                                    icon:
                                        SvgPicture.asset(SvgIcons.snakbarInfo),
                                    "Info",
                                    "The maximum limit has been reached you can modify your files by removing one");
                              } else {
                                Get.bottomSheet(CustomBottomSheet(
                                  onFilePickerTap: () {
                                    docReferanceChat.filepickerDocChat();
                                  },
                                  onCameraTap: () {
                                    docReferanceChat.takeSnapshot();
                                  },
                                  onScannerTap: () {},
                                ));
                              }
                            },
                            child: Container(
                              height: 123,
                              width: 350,
                              decoration: BoxDecoration(
                                border: RDottedLineBorder.all(
                                  color: AppColors.textcolor,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 5),
                                    child: Icon(
                                      Icons.add_circle_outline_outlined,
                                      size: 30,
                                      color: AppColors.textcolor,
                                    ),
                                  ),
                                  Text(
                                    "Upload reference files",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textcolor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const UploadInstructions(
                          title: 'Upload instructions',
                          instructions: [
                            'Supports all major file formats',
                            'Preferred in English language',
                            'Maximum 2 file(s) can be uploaded',
                            'Please ensure the document contains fewer than 40 pages',
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(() {
                    if (docReferanceChat.files.isNotEmpty) {
                      return Container(
                        width: 390,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 12, top: 8, right: 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(
                                    child: Text(
                                      'Uploaded reference Files:',
                                      style: TextStyle(
                                        color: Color(0xFF404040),
                                        fontSize: 16,
                                        fontFamily: 'Open Sans',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Container(
                                      height: 20,
                                      width: 30,
                                      decoration: BoxDecoration(
                                          color: AppColors.greenHalf,
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: Center(
                                        child: Text(
                                          '${docReferanceChat.files.length}/5',
                                          style: TextStyle(
                                            color: AppColors.greenColor,
                                            fontSize: 12,
                                            fontFamily: 'Open Sans',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            Obx(() {
                              return SizedBox(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: docReferanceChat.files.length,
                                  itemBuilder: (_, i) {
                                    return Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Card(
                                            elevation: 0.5,
                                            shape: RoundedRectangleBorder(
                                              side: const BorderSide(
                                                  color: Colors.white70,
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            color: AppColors.hlfgrey,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8),
                                                  child: Row(
                                                    children: [
                                                      if (docReferanceChat
                                                          .files[i]
                                                          .path
                                                          .isNotEmpty)
                                                        SvgPicture.asset(
                                                          getFileIconPath(
                                                              docReferanceChat
                                                                  .files[i]
                                                                  .path),
                                                          height: 20,
                                                          width: 20,
                                                          fit: BoxFit.fill,
                                                        ),
                                                      const SizedBox(width: 5),
                                                      SizedBox(
                                                        width: 200,
                                                        child: Text(
                                                          docReferanceChat
                                                              .files[i].path
                                                              .replaceAll(
                                                                  "/data/user/0/com.example.prajalok/cache/file_picker/",
                                                                  ""),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          softWrap: false,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    docReferanceChat.files
                                                        .remove(docReferanceChat
                                                            .files[i]);
                                                    docReferanceChat.files
                                                        .refresh();
                                                  },
                                                  icon: const Icon(
                                                    Icons.close,
                                                    color: AppColors
                                                        .closeIconColor,
                                                    size: 20,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Obx(() {
                                            print(
                                                "CCCCC${fileUploadService.outputDocUrl.value}");
                                            FileCheckModel? fileChekRes;
                                            if (docReferanceChat
                                                    .fileCheckResults
                                                    .isNotEmpty &&
                                                i <
                                                    docReferanceChat
                                                        .fileCheckResults
                                                        .length) {
                                              fileChekRes = docReferanceChat
                                                  .fileCheckResults[i];
                                            }
                                            return FileCheckRow(
                                              fileCheckResults: docReferanceChat
                                                  .fileCheckResults,
                                              index: i,
                                              onPressed: () {
                                                docReferanceChat
                                                    .selectedIndex.value = i;
                                                fileUploadService.getCredit(
                                                  moduleId: docReferanceChat
                                                      .docChatModuleId.value,
                                                  uuid: docReferanceChat.uuid
                                                      .toString(),
                                                  folderPath: 'docChat',
                                                  localFilePath:
                                                      docReferanceChat
                                                          .files[i].path,
                                                );
                                              },
                                              files: docReferanceChat.files,
                                              outputDocUrl: fileUploadService
                                                  .outputDocUrl.value,
                                              i: i,
                                              selectedIndex: docReferanceChat
                                                  .selectedIndex.value,
                                            );
                                          }),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );
                            }),
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  }),
                  const SizedBox(
                    height: 10,
                  ),
                  // referenace list here

                  ReferenaceList(),
                ],
              ),
            ),
          ),
          Container(
              height: 80,
              color: Colors.grey.shade100,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        ReusableGradientButton(
                            height: 38,
                            gradient: AppColors.linearGradient,
                            onPressed: () async {
                              Get.dialog(const ReusableProcessingDialog());
                              bool? res =
                                  await docReferanceChat.postReferences();
                              if (res != null) {
                                supabase
                                    .schema(ApiConst.doctalkShema)
                                    .from("sessions")
                                    .stream(primaryKey: ["id"])
                                    .eq('id', docReferanceChat.sessionId.value)
                                    //docReferanceChat.sessionId.value
                                    .listen((data) {
                                      if (data[0]['task_id'] != null) {
                                        Get.back();
                                        Future.delayed(Duration.zero, () {
                                          docReferanceChat.webSocketReferences(
                                              data[0]['task_id']);
                                        });
                                      }
                                    });
                              }
                            },
                            child: Row(
                              children: [
                                SvgPicture.asset(SvgIcons.wandIcons),
                                const Text(
                                  " Get reference files",
                                  style: buttonTextStyle,
                                )
                              ],
                            )),

// doc chatRedady Button Section

                        ReusableGradientButton(
                            height: 38,
                            gradient: AppColors.linearGradient,
                            onPressed: () async {
                              Get.dialog(const ReusableProcessingDialog());
                              bool? res =
                                  await docReferanceChat.postchatReady();
                              if (res != null) {
                                supabase
                                    .schema(ApiConst.doctalkShema)
                                    .from("sessions")
                                    .stream(primaryKey: ["id"])
                                    .eq('id', docReferanceChat.sessionId.value)
                                    .listen((data) {
                                      if (data[0]['task_id'] != null) {
                                        if (kDebugMode) {
                                          print(
                                              "amreshhhhrrrrr ${data[0]['task_id']}");
                                        }
                                        docReferanceChat.webSocketgetChatReady(
                                            data[0]['task_id']);
                                      }
                                    });
                              }
                            },
                            child: const Text(
                              "Proceed",
                              style: buttonTextStyle,
                            )),
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

class ReferenaceList extends StatelessWidget {
  ReferenaceList({super.key});
  final docReferanceChat = Get.put(DocumentChatController());
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (docReferanceChat.docTalkSessionModel.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return Container(
          margin: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Column(
            children: <Widget>[
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 0, left: 16, top: 10),
                  child: Text(
                    'Accessed Files:',
                    style: TextStyle(
                      color: Color(0xFF404040),
                      fontSize: 16,
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              // ListView.builder(
              //   shrinkWrap: true,
              //   physics: const BouncingScrollPhysics(),
              //   itemCount: docReferanceChat.docTalkSessionModel.length,
              //   itemBuilder: (context, index) {
              //     final result = docReferanceChat.docTalkSessionModel[index];

              //     return

              ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: docReferanceChat.listData.length,
                itemBuilder: (context, i) {
                  //   final ref = docReferanceChat.listData[i];
                  return Container(
                    margin: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 5,
                      bottom: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                      ),
                      child: ExpansionTile(
                        textColor: AppColors.textcolor,
                        iconColor: AppColors.textcolor,
                        collapsedTextColor: AppColors.blacktxtColor,
                        collapsedIconColor: AppColors.blacktxtColor,
                        onExpansionChanged: (value) {
                          docReferanceChat.expansionchnage(value);
                        },
                        title: Text(
                          "${docReferanceChat.listData[i].caseTitle}",
                          style: const TextStyle(
                            fontSize: 13,
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Obx(
                              () => docReferanceChat.isExpanded.value
                                  ? const Icon(
                                      Icons.keyboard_arrow_up,
                                      size: 20,
                                      color: AppColors.textcolor,
                                    )
                                  : const Icon(
                                      Icons.keyboard_arrow_down,
                                      size: 20,
                                      color: AppColors.blacktxtColor,
                                    ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: AppColors.blacktxtColor,
                                size: 20,
                              ),
                              onPressed: () {
                                docReferanceChat.listData.clear();
                                docReferanceChat.listData.removeAt(i);
                              },
                            ),
                          ],
                        ),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: MarkdownBody(
                              styleSheet: MarkdownStyleSheet(
                                  h1: const TextStyle(fontSize: 18),
                                  h2: const TextStyle(fontSize: 5)),
                              shrinkWrap: true,
                              selectable: true,
                              data:
                                  "${docReferanceChat.listData[i].judgementSummary}"
                                      .replaceAll(
                                "[], #",
                                "",
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                  //});
                },
              ),
            ],
          ),
        );
      }
    });
  }
}
