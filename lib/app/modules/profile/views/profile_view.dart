import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:prajalok/app/utils/icons_const.dart';
import 'package:prajalok/app/utils/widget_const.dart';
import '../controllers/profile_controller.dart';
import 'profilecomplted.dart';

class ProfileView extends GetView<ProfileController> {
  ProfileView({Key? key}) : super(key: key);
  final profileC = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        actions: [
          Image.asset(
            ImagesColletions.logo,
            width: 100,
            height: 30.47,
          ),
          const SizedBox(
            width: 20,
          )
        ],
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: Center(
          child: Column(children: <Widget>[
            Expanded(
              child: PageView.builder(
                physics: const NeverScrollableScrollPhysics(),
                controller: profileC.controller,
                itemCount: profileC.formSteps.value.getContents().length,
                onPageChanged: (int index) {
                  profileC.setState(index);
                },
                itemBuilder: (_, i) {
                  return Column(
                    children: [
                      profileC.formSteps.value.getContents()[i],
                      const SizedBox(
                        height: 50,
                      ),
                    ],
                  );
                },
              ),
            ),
            Obx(() => ReusableGradientButton(
                width: 250,
                height: 48,
                gradient: AppColors.linearGradient,
                onPressed: () async {
                  if (profileC.currentIndex.value == profileC.formSteps.value.getContents().length - 1) {
                    if (profileC.isLoading.isFalse) {
                      bool? result = await profileC.createProfile();
                      if (result != null && result == true) {
                        Get.offAll(ProfileComplted());
                      }
                    }
                  }
                  profileC.controller?.nextPage(
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.bounceIn,
                  );
                },
                child: profileC.isLoading.isFalse
                    ? Text(
                        profileC.currentIndex.value == profileC.formSteps.value.getContents().length - 1
                            ? "Continue"
                            : "Next (${profileC.currentIndex.value + 1}/3)",
                        style: buttonTextStyle,
                      )
                    : const CircularProgressIndicator())),
            const SizedBox(height: 20),
          ]),
        ),
      ),
    );
  }
}
