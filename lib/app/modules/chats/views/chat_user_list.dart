import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:prajalok/app/utils/customer_loading.dart';
import 'package:prajalok/app/utils/icons_const.dart';
import '../controllers/chats_controller.dart';
import 'chats_view.dart';
import 'package:intl/intl.dart';

class ChatUserList extends StatelessWidget {
  ChatUserList({super.key});
  final controller = Get.put(ChatsController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: const Text(
          "Chats",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, fontFamily: "Open Sans"),
        ),
        actions: [
          IconButton(
            onPressed: () {
              controller.getUserConversations();
            },
            icon: const Icon(Icons.more_vert_outlined),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search by Name",
                hintStyle: TextStyle(color: Colors.grey.shade600),
                suffixIcon: Icon(
                  Icons.search,
                  color: Colors.grey.shade600,
                  size: 20,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.grey.shade100),
                ),
              ),
            ),
          ),
          Expanded(child: Obx(() {
            if (controller.chatUserListList.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.textcolor,
                ),
              );
            }
            return ListView.builder(
              itemCount: controller.chatUserListList.length,
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 16),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final chatUsers = controller.chatUserListList[index];
                print("profileeeeeeeee${chatUsers.otherUserDetails?.profileId}");
                return ConversationList(
                  lastName: chatUsers.otherUserDetails?.lastName ?? "",
                  name: chatUsers.otherUserDetails?.firstName.toString() ?? '',
                  conversationId: chatUsers.conversationId ?? 0,
                  recipientId: chatUsers.otherUserDetails?.profileId,
                  messageText: chatUsers.latestMessage!.contentData ?? " ",
                  imageUrl: chatUsers.otherUserDetails?.avatarUrl ?? ImagesColletions.emptyAvtarImages,
                  isMessageRead: chatUsers.unreadCount == 0 ? true : false,
                  unreadMessageCount: chatUsers.unreadCount ?? 0,
                  time: chatUsers.latestMessage?.createdAt ?? DateTime.now(),
                  // isMessageRead: (index == 0 || index == 3) ? true : false,
                );
              },
            );
          })),
        ],
      ),
    );
  }
}

class ConversationList extends StatelessWidget {
  final String name;
  final String lastName;
  final String messageText;
  final String imageUrl;
  final DateTime time;
  final bool isMessageRead;
  final int unreadMessageCount;
  final int conversationId;
  final dynamic recipientId;

  ConversationList(
      {Key? key,
      required this.name,
      required this.lastName,
      required this.messageText,
      required this.imageUrl,
      required this.time,
      required this.isMessageRead,
      required this.conversationId,
      required this.unreadMessageCount,
      required this.recipientId})
      : super(key: key);
  final controller = Get.put(ChatsController());

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        controller.conversationId.value = conversationId;
        controller.recipientId.value = recipientId;
        Get.to(() => Conversation(
              lastName: lastName,
              conversationId: conversationId,
              imageUrl: imageUrl,
              name: name,
            ));
      },
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: imageUrl,
              imageBuilder: (context, imageProvider) => Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                  color: AppColors.searchLawAppBarColors,
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                  color: AppColors.searchLawAppBarColors,
                  image: DecorationImage(
                    image: AssetImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Container(
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "$name $lastName",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Open Sans",
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),

                    buildFilePreviewDuringChat(messageText)
                    // Text(
                    //   messageText,
                    //   style: TextStyle(
                    //     fontSize: 13,
                    //     color: Colors.grey.shade600,
                    //     fontFamily: "Open Sans",
                    //     fontWeight: isMessageRead ? FontWeight.bold : FontWeight.w400,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  DateFormat('dd/MM/yyyy').format(time),
                  style: TextStyle(fontSize: 12, fontWeight: isMessageRead ? FontWeight.w400 : FontWeight.bold),
                ),
                unreadMessageCount == 0
                    ? const SizedBox()
                    : Container(
                        margin: const EdgeInsets.only(top: 5, bottom: 5),
                        height: 20,
                        width: 30,
                        decoration: BoxDecoration(color: AppColors.textcolor, borderRadius: BorderRadius.circular(50)),
                        child: Center(
                          child: Text(
                            '+$unreadMessageCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildFilePreviewDuringChat(String file) {
  final lowerCasePath = file.toLowerCase();
  if (lowerCasePath.endsWith('.pdf') ||
      lowerCasePath.endsWith('.docx') ||
      lowerCasePath.endsWith('.png') ||
      lowerCasePath.endsWith('.jpg') ||
      lowerCasePath.endsWith('.jpeg')) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        children: <Widget>[
          SvgPicture.asset(
            getFileIconPath(file),
            fit: BoxFit.cover,
            height: 15,
            width: 15,
          ),
          Expanded(
            child: Text(
              file.split('/').last,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  } else {
    return Text(file);
  }
}
