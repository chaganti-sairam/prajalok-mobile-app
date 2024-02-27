import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:prajalok/app/utils/compnent/cache_image.dart';
import 'package:prajalok/app/utils/icons_const.dart';
import 'package:prajalok/app/utils/widget_const.dart';
import '../controllers/profile_controller.dart';

class UpdateProfile extends StatelessWidget {
  UpdateProfile({Key? key}) : super(key: key);
  final controller = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      body: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(left: 24, right: 24),
        child: Obx(() {
          if (controller.profileModel.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            for (int i = 0; i < controller.profileModel.length; i++) {
              final result = controller.profileModel[i];
              controller.avatarlUrl.value = result.avatarUrl.toString();
              controller.firstNameController.text = result.firstName ?? "eg: Prajalok";
              controller.lastNameController.text = result.lastName ?? "eg: Prajalok";
              controller.emailController.text = result.emailId ?? "eg: 7sKXH@example.com";
              controller.locationController.text = result.location?[0].toString() ?? "eg: India";
            }
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 120,
                width: 120,
                child: Stack(
                  children: [
                    controller.pickedloacalfile.isEmpty
                        ? CachedImage(
                            imageUrl: controller.avatarlUrl.value,
                            size: 100,
                          )
                        : Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100 * 0.34),
                              color: AppColors.searchLawAppBarColors,
                              image: DecorationImage(
                                image: Image.file(File.fromUri(Uri.parse(controller.pickedloacalfile.value))).image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                    Positioned(
                      left: 70,
                      bottom: 10,
                      child: IconButton(
                        splashRadius: 25,
                        onPressed: () {
                          Get.bottomSheet(CustomBottomSheet(
                            onFilePickerTap: () {
                              controller.onPickFiles();
                            },
                            onCameraTap: () {
                              controller.takeSnapshot();
                            },
                            onScannerTap: () {},
                          ));
                        },
                        icon: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            boxShadow: [BoxShadow(color: AppColors.textcolor, spreadRadius: 2, blurRadius: 5)],
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset(SvgIcons.camera),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              TextField(
                controller: controller.firstNameController,
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.textcolor),
                  ),
                  labelText: 'First name',
                  labelStyle: TextStyle(
                    color: AppColors.closeIconColor,
                  ),
                ),
              ),
              TextField(
                controller: controller.lastNameController,
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.textcolor),
                  ),
                  labelText: 'Last name',
                  labelStyle: TextStyle(
                    color: AppColors.closeIconColor,
                  ),
                ),
              ),
              TextField(
                controller: controller.emailController,
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.textcolor),
                  ),
                  labelText: 'Email ID',
                  labelStyle: TextStyle(
                    color: AppColors.closeIconColor,
                  ),
                ),
              ),
              TextField(
                controller: controller.locationController,
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.textcolor),
                  ),
                  labelText: 'Location',
                  labelStyle: TextStyle(
                    color: AppColors.closeIconColor,
                  ),
                ),
              ),
              const Spacer(
                flex: 1,
              ),
              ReusableGradientButton(
                width: 250,
                height: 48,
                gradient: AppColors.linearGradient,
                onPressed: () async {
                  controller.updateProfile();
                },
                child: const Text(
                  "Save changes",
                  style: buttonTextStyle,
                ),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          );
        }),
      ),
    );
  }
}
