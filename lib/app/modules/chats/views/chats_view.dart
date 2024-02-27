import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:prajalok/app/data/serlization/normal_chat/message.dart';
import 'package:prajalok/app/utils/api_const.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:prajalok/app/utils/compnent/custome_alert.dart';
import 'package:prajalok/app/utils/customer_loading.dart';
import 'package:prajalok/app/utils/file_downloader.dart';
import 'package:prajalok/app/utils/icons_const.dart';
import 'package:prajalok/app/utils/widgetButton.dart';
import 'package:prajalok/app/utils/widget_const.dart';
import '../controllers/chats_controller.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class ChatsView extends GetView<ChatsController> {
  const ChatsView({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0.5, backgroundColor: AppColors.hlfgrey, title: const Text('Chat')),
      body: const Text("we are progressing"),
    );
  }
}

class Conversation extends StatelessWidget {
  final String name;
  final String lastName;
  final String imageUrl;
  final int conversationId;
  Conversation({super.key, required this.imageUrl, required this.name, required this.conversationId, required this.lastName});
  final controller = Get.put(ChatsController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Obx(() {
          return AppBar(
            elevation: 0.5,
            leading: controller.isvisible.value == false
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      child: CachedNetworkImage(
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
                    ),
                  )
                : IconButton(
                    onPressed: () {
                      controller.isSelctedId.clear();
                      controller.isvisible.value = false;
                    },
                    icon: const Icon(Icons.arrow_back),
                    color: AppColors.textcolor,
                  ),
            title: Obx(
              () => controller.isvisible.value == false ? Text("$name $lastName") : Text("${controller.isSelctedId.length} selected"),
            ),
            actions: [
              Obx(() => controller.isvisible.value == false
                  ? const SizedBox()
                  : Row(
                      children: <Widget>[
                        IconButton(
                          splashRadius: 20,
                          onPressed: () {
                            // delete message dialog
                            Get.dialog(
                              CustomAlertDialog(
                                visible: false,
                                title: 'Are you sure ?',
                                message: "You want to delete selected message(s) from the chat.",
                                onNoPressed: () {
                                  Get.back(canPop: true, closeOverlays: false);
                                },
                                onYesPressed: () async {
                                  controller.deleteSlectedMessage().then((value) {
                                    Navigator.pop(context);
                                  }).onError((error, stackTrace) {
                                    print("erroror $stackTrace  $error");
                                  });
                                },
                              ),
                            );
                          },
                          icon: SvgPicture.asset(height: 24, width: 24, SvgIcons.trashSvgIcons),
                        ),
                        //share
                        IconButton(
                          splashRadius: 20,
                          onPressed: () async {
                            final result = await Share.share(
                              'https://prajalok.com/${controller.selcetdDataShare.value}',
                            );
                          },
                          icon: SvgPicture.asset(height: 30, width: 20, SvgIcons.forwardSvgIcons),
                        ),
                      ],
                    )),
              IconButton(
                splashRadius: 20,
                onPressed: () {
                  Get.dialog(
                    AlertDialog(
                      content: SizedBox(
                          height: 150,
                          child: Obx(
                            () => Column(
                              children: [
                                Container(
                                  width: 100,
                                  height: 50,
                                  color: controller.selectedColor.value,
                                  // child: Text(
                                  //   'Color',
                                  //   style: TextStyle(color: Colors.black),
                                  // ),
                                ),
                                const SizedBox(height: 20),
                                Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: controller.colorList
                                      .map((color) => GestureDetector(
                                            onTap: () {
                                              controller.selectedColor.value = color;
                                            },
                                            child: CircleAvatar(
                                              radius: 15,
                                              backgroundColor: color,
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ],
                            ),
                          )),
                    ),
                  );
                },
                icon: const Icon(Icons.more_vert_outlined),
              )
            ],
          );
        }),
      ),
      body: StreamBuilder(
        stream: supabase
            .schema("network")
            .from("messages")
            .stream(primaryKey: ['id'])
            .eq("conversation_id", conversationId)
            .order("id", ascending: false),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final messages = snapshot.data!;
            controller.messageModelsResult.value = messages.map((e) => MessageModels.fromJson(e)).toList();
            return Column(
              children: [
                Expanded(
                  child: controller.messageModelsResult.isEmpty
                      ? const Center(
                          child: Text('Start your conversation now :)'),
                        )
                      : ListView.builder(
                          reverse: true,
                          itemCount: controller.messageModelsResult.length,
                          itemBuilder: (context, index) {
                            final message1 = controller.messageModelsResult[index];
                            return InkWell(
                              onLongPress: () {
                                controller.selectable(message1.id ?? 0);
                                controller.selcetdDataShare.value = message1.contentData ?? "";
                              },
                              child: Obx(
                                () => Container(
                                  color: controller.selectedColor.value ?? AppColors.searchLawAppBarColors,
                                  child: ChatBubble(
                                    message: message1,
                                    lastDate: message1.createdAt ?? DateTime.now(),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
                MessageBar(),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

Widget buildFilePreviewDuringChat(String file, String size, String filename, bool isSender, context) {
  final controller = Get.put(ChatsController());
  FileDownloader downloader = FileDownloader();

  final lowerCasePath = file.toLowerCase();
  if (lowerCasePath.endsWith('.pdf') || lowerCasePath.endsWith('.docx')) {
    return Row(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(left: 0, right: 8, bottom: 0, top: 0),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            getFileIconPath(file),
            fit: BoxFit.cover,
            height: 32,
            width: 32,
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                filename,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: "Open Sans",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.blacktxtColor,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                "$size ",
                style: const TextStyle(
                  fontFamily: "Open Sans",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff8F8F8F),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  } else {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            showGeneralDialog(
              context: context,
              barrierColor: AppColors.searchLawAppBarColors,
              barrierDismissible: false,
              barrierLabel: 'Dialog',
              transitionDuration: const Duration(milliseconds: 400),
              pageBuilder: (context, __, ___) {
                return Column(
                  children: <Widget>[
                    AppBar(
                      title: Text(filename),
                    ),
                    Expanded(
                      child: PhotoView(
                        filterQuality: FilterQuality.high,
                        imageProvider: NetworkImage(
                          file,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          child: Container(
            alignment: Alignment.center,
            height: 200,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: NetworkImage(file),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    filename,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: "Open Sans",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.blacktxtColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    size,
                    style: const TextStyle(
                      fontFamily: "Open Sans",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff8F8F8F),
                    ),
                  ),
                ],
              ),
            ),
            isSender
                ? const SizedBox()
                : InkWell(
                    onTap: () async {
                      await downloader.downloadFile(url: file, filename: "prajalokchat${DateTime.now().millisecondsSinceEpoch}").then((value) {
                        controller.showCheckbox.value = true;
                      });
                      Future.delayed(const Duration(seconds: 1), () {
                        controller.showCheckbox.value = false;
                      });
                    },
                    child: Obx(() {
                      double progress = downloader.downloadProgress.value;
                      return progress > 0.0 && progress < 1.0
                          ? CircularProgressIndicator(value: progress * 100)
                          : controller.showCheckbox.value
                              ? const Row(
                                  children: [
                                    Icon(Icons.check_box, color: Colors.green),
                                    SizedBox(width: 8),
                                    Text('Downloaded'),
                                  ],
                                )
                              : Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: AppColors.searchLawAppBarColors,
                                  ),
                                  child: SvgPicture.asset(SvgIcons.downloadIcons),
                                );
                    }),
                  ),
          ],
        )
      ],
    );
  }
}

class ChatBubble extends StatelessWidget {
  ChatBubble({Key? key, required this.message, required this.lastDate}) : super(key: key);
  final MessageModels message;
  final DateTime lastDate;
  final controller = Get.put(ChatsController());
  @override
  Widget build(BuildContext context) {
    bool isSender = message.senderId == uuid;
    List<Widget> chatContents = [
      Flexible(
        child: Obx(
          () => Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 12,
            ),
            decoration: BoxDecoration(
              color: controller.isSelctedId.where((p0) => p0 == message.id).toList().isNotEmpty
                  ? AppColors.greenHalf
                  : isSender
                      ? AppColors.chatSendTextCollor
                      : const Color(0xFFEFEFEF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                message.contentType == "text"
                    ? Text(
                        message.contentData.toString(),
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400, fontFamily: 'Open Sans', color: AppColors.blacktxtColor, height: 1.5),
                      )
                    : buildFilePreviewDuringChat(
                        message.contentData.toString(), "${double.parse(message.fileSize.toString())} Kb", "${message.fileName}", isSender, context),
                const SizedBox(height: 5),
                Wrap(
                  alignment: isSender ? WrapAlignment.end : WrapAlignment.start,
                  children: [
                    Text(message.id.toString(),
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w400, fontFamily: 'Open Sans', color: AppColors.closeIconColor)),
                    Text(
                      DateFormat("hh:mm a").format(message.createdAt ?? DateTime.now()),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Open Sans',
                        color: AppColors.closeIconColor,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    ];
    if (isSender) {
      chatContents = chatContents.reversed.toList();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            margin: const EdgeInsets.only(bottom: 5, top: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              DateFormat("MMM dd, yyyy").format(lastDate),
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.bold,
                color: AppColors.closeIconColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Row(
            mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: isSender ? chatContents : chatContents.reversed.toList(),
          ),
        ],
      ),
    );
  }
}

// Message Bar
class MessageBar extends StatelessWidget {
  MessageBar({super.key});
  final controller = Get.put(ChatsController());
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Material(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      maxLines: null,
                      autofocus: false,
                      controller: controller.textMessageController.value,
                      onChanged: (value) {
                        controller.update();
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(8),
                        filled: true,
                        fillColor: const Color(0xFFEFEFEF),
                        suffixIcon: IconButton(
                          splashRadius: 20,
                          onPressed: () {
                            Get.bottomSheet(CustomBottomSheet(
                              onFilePickerTap: () {
                                controller.handleFileSelection();
                              },
                              onCameraTap: () {},
                              onScannerTap: () {
                                controller.handleImageSelection();
                              },
                            ));
                          },
                          icon: SvgPicture.asset(SvgIcons.attachmentScgIcons),
                        ),
                        hintText: 'Type your message here...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(color: Colors.transparent),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(color: Colors.transparent),
                        ),
                      ),
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
                            controller.submittxtMessage();
                          },
                          icon: SvgPicture.asset(SvgIcons.sendIcons))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HandlePreviewBottomSheet extends StatelessWidget {
  HandlePreviewBottomSheet({super.key});
  final controller = Get.put(ChatsController());
  Widget buildFilePreview(File file) {
    final lowerCasePath = file.path.toLowerCase();
    if (lowerCasePath.endsWith('.pdf') || lowerCasePath.endsWith('.docx')) {
      return Container(
        alignment: Alignment.center,
        child: SvgPicture.asset(
          getFileIconPath(file.path),
          fit: BoxFit.cover,
          height: 150,
          width: 150,
        ),
      );
    } else {
      // For other files, show an image preview
      return Container(
        alignment: Alignment.center,
        height: 200,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: Image.file(file).image,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }

  Widget buildFilePreview2(File file) {
    final lowerCasePath = file.path.toLowerCase();
    if (lowerCasePath.endsWith('.pdf') || lowerCasePath.endsWith('.docx')) {
      return Container(
        alignment: Alignment.center,
        child: SvgPicture.asset(
          getFileIconPath(file.path),
          fit: BoxFit.cover,
          height: 150,
          width: 150,
        ),
      );
    } else {
      // For other files, show an image preview
      return Container(
        alignment: Alignment.center,
        height: 200,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: Image.file(file).image,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              splashColor: Colors.red,
              onTap: () {
                Get.back();
              },
              child: SvgPicture.asset(
                SvgIcons.crossIcons,
                color: AppColors.textcolor,
                width: 24,
                height: 24,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Obx(() {
            if (controller.selectedFileList.value != null) {
              return Container(
                alignment: Alignment.topCenter,
                height: 200,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: buildFilePreview2(controller.selectedFileList.value!),
              );
            } else {
              return const Center(
                child: Text(
                  "For Preview,a file should be selected",
                  style: TextStyle(color: AppColors.textcolor),
                ),
              );
            }
          }),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Obx(() {
                if (controller.selectedFileList.value != null) {
                  return Flexible(
                    child: Text(
                      "${controller.selectedFileList.value?.path.split('/').last}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.blacktxtColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              }),
              Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.searchLawAppBarColors,
                ),
                child: IconButton(
                  onPressed: () {
                    if (controller.pickedFileList.isEmpty) {
                      Get.back();
                    } else {
                      controller.pickedFileList.remove(controller.selectedFileList.value);
                      controller.selectedFileList.value = null;
                    }
                  },
                  icon: SvgPicture.asset(
                    SvgIcons.trashSvgIcons,
                    color: AppColors.invalidColor,
                  ),
                ),
              ),
            ],
          ),
          Obx(() {
            if (controller.selectedFileList.value != null) {
              return Text(
                "${controller.fileSize(controller.selectedFileList.value)} Kb",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.blacktxtColor,
                ),
                overflow: TextOverflow.ellipsis,
              );
            } else {
              return const SizedBox();
            }
          }),

          Obx(() {
            if (controller.pickedFileList.isEmpty) {
              Get.back();
              return const SizedBox();
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Text(
                  "Selected files",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff2C2C2C),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Container(
                  alignment: Alignment.center,
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.textcolor,
                  ),
                  child: Text(
                    controller.pickedFileList.length.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: "Open Sans",
                    ),
                  ),
                ),
              ],
            );
          }),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Obx(
                () {
                  if (controller.pickedFileList.isEmpty) {
                    return const SizedBox();
                  } else {
                    return Row(
                      children: List.generate(controller.pickedFileList.length, (index) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          controller.selectedFileList.value = controller.pickedFileList[0];
                        });
                        return InkWell(
                          onTap: () {
                            controller.selectedFileList.value = controller.pickedFileList[index];
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height: 60,
                              width: 60,
                              // height: controller.isHovered.value ? 100 : 60,
                              // width: controller.isHovered.value ? 100 : 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: buildFilePreview2(controller.pickedFileList[index]),
                            ),
                          ),
                        );
                      }),
                    );
                  }
                },
              ),
            ),
          ),
          // const SizedBox(height: 10),
          Center(
            child: WidgetButtonPress(
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.textcolor),
                child: IconButton(
                  onPressed: () {
                    controller.uploadFiles(controller.pickedFileList).then((value) {
                      if (controller.responseList.length == controller.uploadedUrl.length) {
                        controller.pickedFileList.clear();
                        Navigator.canPop(context);
                      }
                    });
                  },
                  icon: SvgPicture.asset(height: 50, width: 50, SvgIcons.sendIcons),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
