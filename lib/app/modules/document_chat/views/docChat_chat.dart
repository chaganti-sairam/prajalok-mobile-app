import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:prajalok/app/data/serlization/message_model.dart';
import 'package:prajalok/app/utils/api_const.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:prajalok/app/utils/icons_const.dart';
import 'package:prajalok/app/utils/widgetButton.dart';
import 'package:prajalok/app/utils/widget_const.dart';
import 'package:intl/intl.dart';

import '../controllers/document_chat_controller.dart';

class DocChat extends StatelessWidget {
  DocChat({super.key});
  final controller = Get.put(DocumentChatController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Chat",
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder(
                  stream: supabase
                      .schema(ApiConst.doctalkShema)
                      .from("messages")
                      .stream(primaryKey: ["id"])
                      .eq("session_id", controller.sessionId.value)
                      .order("id", ascending: false),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return const Text('Not connected to the stream yet');
                      case ConnectionState.waiting:
                        return const Center(child: CircularProgressIndicator(color: AppColors.textcolor));
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final res = snapshot.data as List<dynamic>;
                        controller.messageresponseModel.value = res.map((e) => MessageModel.fromJson(e)).toList();
                        return Obx(() {
                          if (controller.messageresponseModel.isEmpty) {
                            return const Center(
                              child: Text('Start your conversation now :)'),
                            );
                          } else {
                            return ListView.builder(
                                reverse: true,
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemCount: controller.messageresponseModel.length,
                                itemBuilder: (context, index) {
                                  final message = controller.messageresponseModel[index];
                                  return _ChatBubble(
                                    message: message,
                                  );
                                });
                          }
                        });
                    }
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MessageBar(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Set of widget that contains TextField and Button to submit message
class MessageBar extends StatelessWidget {
  MessageBar({super.key});
  final controller = Get.put(DocumentChatController());
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Padding(
            // padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            padding: const EdgeInsets.all(0.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    maxLines: null,
                    autofocus: true,
                    controller: controller.msgtxtController.value,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFEFEFEF),
                      hintText: 'Type your message here...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(8),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                WidgetButtonPress(
                  child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.textcolor),
                      child: IconButton(
                          onPressed: () {
                            controller.submitMessage();
                          },
                          icon: SvgPicture.asset(SvgIcons.sendIcons))),
                ),
              ],
            )),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({
    Key? key,
    required this.message,
  }) : super(key: key);
  final MessageModel message;
  @override
  Widget build(BuildContext context) {
    List<Widget> chatContents = [
      Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (message.chatUserType == "assistant")
                const CircleAvatar(
                  radius: 10,
                  backgroundImage: AssetImage(
                    ImagesColletions.colorLogo,
                  ),
                ),
            ],
          ),
          const SizedBox(
            width: 12,
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 12,
            ),
            decoration: BoxDecoration(
              color: message.chatUserType != "assistant" ? AppColors.chatSendTextCollor : const Color(0xFFEFEFEF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                message.chatUserType != "assistant"
                    ? Container(
                        width: 200,
                        alignment: Alignment.centerRight,
                        child: Text(
                          message.content.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )
                    : SizedBox(
                        width: 320,
                        child: message.content!.isNotEmpty
                            ? Markdown(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                styleSheet: MarkdownStyleSheet(
                                  textAlign: WrapAlignment.spaceAround,
                                  h1: const TextStyle(
                                    color: AppColors.textcolor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Open Sans',
                                  ),
                                  h2: const TextStyle(
                                    color: AppColors.chatRecivedTextCollor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Open Sans',
                                  ),
                                  h3: const TextStyle(
                                    color: AppColors.chatRecivedTextCollor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Open Sans',
                                  ),
                                ),
                                selectable: true,
                                data: message.content.toString(),
                              )
                            : const CircularProgressIndicator(color: AppColors.textcolor),
                      ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              textAlign: TextAlign.justify,
              DateFormat("hh:mm a").format(message.sentAt ?? DateTime.now()),
            ),
          ),
        ],
      ),
    ];

    const SizedBox(width: 60);
    if (message.chatUserType != null) {
      chatContents = chatContents.reversed.toList();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Expanded(
        child: Row(
          mainAxisAlignment: message.chatUserType != "assistant" ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: chatContents,
        ),
      ),
    );
  }
}
