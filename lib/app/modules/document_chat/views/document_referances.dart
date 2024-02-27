import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:prajalok/app/utils/api_const.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:prajalok/app/utils/widget_const.dart';
import 'package:r_dotted_line_border/r_dotted_line_border.dart';
import '../controllers/document_chat_controller.dart';
import 'dart:developer' as dev;
import 'DocReferanceChatPage.dart';
import 'docChat_chat.dart';

class DocReferanceChat extends StatelessWidget {
  DocReferanceChat({super.key});
  final documentChatController = Get.put(DocumentChatController());
  final List<Widget> listWidget = [
    Role(),
    DocReferanceChatPage(),
    DocChat(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Document chat',
          style: TextStyle(color: Colors.black45),
        ),
        elevation: 0.4,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black54,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 80,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Obx(() {
                  return ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: documentChatController.listOfIcons.length,
                    separatorBuilder: (context, index) {
                      return Column(
                        children: [
                          Obx(() {
                            return Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              margin: const EdgeInsets.only(top: 20),
                              width: 50,
                              decoration: BoxDecoration(
                                border: RDottedLineBorder.symmetric(
                                  horizontal: BorderSide(
                                    width: 0,
                                    color: documentChatController
                                                .currentIndex.value <=
                                            index
                                        ? const Color(0xFF707070)
                                        : AppColors.textcolor,
                                  ),
                                  dottedSpace: 0,
                                ),
                              ),
                            );
                          }),
                        ],
                      );
                    },
                    itemBuilder: (_, i) {
                      return InkWell(
                        // onTap: () {
                        //   documentWriteController.moveToStepersPage();
                        // documentWriteController.changeSateFunc(documentWriteController.currentIndex.value + i);
                        // documentWriteController.pageController.animateToPage(
                        //   i,
                        //   duration: const Duration(milliseconds: 500),
                        //   curve: Curves.ease,
                        // );
                        //},
                        child: SizedBox(
                          child: Column(
                            children: <Widget>[
                              Obx(() {
                                return SvgPicture.asset(
                                  documentChatController.listOfIcons[i],
                                  fit: BoxFit.cover,
                                  color: documentChatController
                                              .currentIndex.value <
                                          i
                                      ? const Color(0xFF707070)
                                      : AppColors.textcolor,
                                  cacheColorFilter: true,
                                  height: 36,
                                  width: 36,
                                );
                              }),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                // width: 50,
                                child: Obx(
                                  () => Text(
                                    documentChatController.listOfTitles[i],
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: documentChatController
                                                  .currentIndex.value <
                                              i
                                          ? const Color(0xFF707070)
                                          : AppColors.textcolor,
                                      fontSize: 12,
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                })),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: PageView.builder(
              physics: const NeverScrollableScrollPhysics(),
              allowImplicitScrolling: false,
              padEnds: true,
              reverse: false,
              controller: documentChatController.pageController,
              onPageChanged: (index) {
                documentChatController.changeSateFunc(index);
              },
              itemCount: listWidget.length,
              itemBuilder: (context, index) {
                return listWidget[index];
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Role extends StatelessWidget {
  Role({super.key});
  final documentChatController = Get.put(DocumentChatController());
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Column(children: <Widget>[
                  const Center(
                    child: Text(
                      "Define your role",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const Center(
                    child: Text(
                      "Choose the appropriate role to chat",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textcolor),
                    ),
                  ),
                  SizedBox(
                    child: StreamBuilder(
                      stream: supabase
                          .schema(ApiConst.doctalkShema)
                          .from("sessions")
                          .stream(primaryKey: ["id"])
                          .eq("id", documentChatController.sessionId.value)
                          .order("id", ascending: false),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var data = snapshot.data!;
                          final availableRoles = data[0]['available_roles'];
                          List<Map<String, dynamic>> rolesList =
                              List<Map<String, dynamic>>.from(availableRoles);
                          return ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: rolesList.length,
                            itemBuilder: (context, index) {
                              var role = rolesList[index];
                              return Obx(() => RadioListTile(
                                  controlAffinity:
                                      ListTileControlAffinity.trailing,
                                  contentPadding: EdgeInsets.zero,
                                  value: role["role_name"] ?? "",
                                  activeColor: Colors.red,
                                  groupValue: documentChatController
                                      .selectedOptions.value,
                                  title: Text(
                                    textAlign: TextAlign.start,
                                    "${role["role_name"] ?? ""}",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontFamily: "Open Sans",
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.blacktxtColor),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      textAlign: TextAlign.start,
                                      "${role["role_description"] ?? ""}",
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: "Open Sans",
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.closeIconColor),
                                    ),
                                  ),
                                  onChanged: (newValue) {
                                    documentChatController.selectedOptions
                                        .value = newValue.toString();
                                    if (kDebugMode) {
                                      print(
                                          "Amreshkumar ${documentChatController.selectedOptions.value}");
                                    }
                                  }));
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.textcolor,
                              semanticsLabel: "Loading",
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ])),
          ),
        ),

        ///const Expanded(child: SizedBox()),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Obx(
            () => ReusableGradientButton(
              width: 250,
              height: 48,
              gradient: documentChatController.selectedOptions.value.isEmpty
                  ? AppColors.disablelinearGradient
                  : AppColors.linearGradient,
              onPressed: documentChatController.selectedOptions.value.isEmpty
                  ? null
                  : () async {
                      if (!documentChatController.isLoading.isTrue) {
                        bool? result = await documentChatController
                            .supabseInsertUserRole();
                        if (result == true) {
                          documentChatController.moveToStepersPage1();
                        }
                      }
                    },
              child: documentChatController.isLoading.isFalse
                  ? const Text(
                      "Continue",
                      textAlign: TextAlign.center,
                      style: buttonTextStyle,
                    )
                  : const CircularProgressIndicator(),
            ),
          ),
        )
      ],
    );
  }
}
