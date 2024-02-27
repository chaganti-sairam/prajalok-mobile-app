import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prajalok/app/data/model/onboarding_model.dart';
import 'package:prajalok/app/modules/login/views/login_view.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:prajalok/app/utils/icons_const.dart';
import 'package:prajalok/app/utils/widget_const.dart';
import '../../login/controllers/login_controller.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  OnboardingView({Key? key}) : super(key: key);
  final onboardingC = Get.put(OnboardingController());
  final loginC = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
                width: Get.width,
                height: Get.height,
                child: Image.asset(
                  ImagesColletions.backgroundImage,
                  fit: BoxFit.fill,
                )),
            Positioned.fill(
              child: Container(
                width: Get.width,
                height: Get.height,
                decoration: BoxDecoration(
                  backgroundBlendMode: BlendMode.lighten,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color.fromARGB(255, 160, 160, 160).withOpacity(0.5), Color(0x18181800)],
                    stops: [0, 0.5],
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 100,
                    height: 30.47,
                    child: Image.asset(
                      'assets/images/logo.png',
                    ),
                  ),
                  Expanded(
                    child: PageView.builder(
                      reverse: false,
                      physics: const BouncingScrollPhysics(),
                      controller: controller.pageController,
                      itemCount: contents.length,
                      onPageChanged: (int index) {
                        controller.onChanged(index);
                      },
                      itemBuilder: (_, i) {
                        return Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 150),
                                child: SizedBox(
                                  width: 266,
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: contents[i].title?.substring(0, contents[i].title?.indexOf('\n')),
                                          style: const TextStyle(
                                            color: AppColors.textcolor,
                                            fontSize: 36,
                                            fontFamily: 'Open Sans',
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.36,
                                          ),
                                        ),
                                        const TextSpan(
                                          text: '\n',
                                          style: TextStyle(
                                            color: Colors.green,
                                          ),
                                        ),
                                        TextSpan(
                                          text: contents[i].title?.substring(contents[i].title!.indexOf('\n') + 1),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 36,
                                            fontFamily: 'Open Sans',
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.36,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              SizedBox(
                                width: 266,
                                child: Text(
                                  contents[i].discription.toString(),
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        contents.length,
                        (index) => buildDot(index, context),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  ReusableGradientButton(
                    width: 250,
                    height: 48,
                    gradient: AppColors.linearGradient,
                    onPressed: () {
                      loginC.toggleLoginRegister(true);
                      Get.to(() => LoginView());
                      if (controller.currentIndex.value == contents.length - 1) {
                        Get.to(() => LoginView());
                      }
                      controller.pageController?.nextPage(
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.bounceIn,
                      );
                    },
                    child: Text(
                      controller.currentIndex.value == contents.length - 1 ? "Get Started" : "Get Started",
                      style: buttonTextStyle,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.14,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          loginC.toggleLoginRegister(false);
                          Get.to(() => LoginView());
                        },
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            color: Color(0xFFFF5C40),
                            fontSize: 14,
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.14,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 5,
      width: controller.currentIndex.value == index ? 5 : 5,
      margin: const EdgeInsets.only(right: 5),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(20), color: controller.currentIndex.value == index ? AppColors.textcolor : Colors.white),
    );
  }
}
