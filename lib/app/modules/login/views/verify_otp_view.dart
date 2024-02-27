import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prajalok/app/modules/login/controllers/login_controller.dart';
import 'package:prajalok/app/modules/profile/views/profile_view.dart';
import 'package:prajalok/app/routes/app_pages.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:prajalok/app/utils/customeSnackbar.dart';
import 'package:prajalok/app/utils/icons_const.dart';
import 'package:prajalok/app/utils/widget_const.dart';

import 'login_view.dart';

class VerifyOtpView extends GetView<LoginController> {
  VerifyOtpView({Key? key}) : super(key: key);
  final verifyC = Get.put(LoginController());
  @override
  LoginController controller = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 342,
                child: Text(
                  'Verify entered \nmobile number',
                  style: GoogleFonts.openSans(
                    color: AppColors.blacktxtColor,
                    fontSize: 24,
                    // fontFamily: 'Open Sans',
                    fontWeight: FontWeight.w600,
                    // height: 0,
                    // letterSpacing: 0.24,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: 342,
                child: Text(
                  'Mobile verification is required for signup/sign-in because of security reasons.',
                  style: GoogleFonts.openSans(
                    color: Color(0xFF606060),
                    fontSize: 14,
                    //  fontFamily: 'Open Sans',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Obx(
                () => TextFormField(
                  obscuringCharacter: "*",
                  controller: verifyC.verifyOtpController.value,
                  keyboardType: TextInputType.phone,
                  obscureText: verifyC.isHide.value,
                  maxLength: 6,
                  onChanged: (value) {
                    verifyC.verifyOtpController.refresh();
                  },
                  decoration: InputDecoration(
                    suffixIcon: Obx(() {
                      return IconButton(
                        onPressed: () {
                          verifyC.passwordVisibility();
                        },
                        icon: SvgPicture.asset(verifyC.isHide.value ? SvgIcons.eyehide : SvgIcons.eyevisible),
                      );
                    }),
                    labelText: "OTP",
                    hintText: "OTP/ Verification code",
                    counterText: '',
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFFF5C40)),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    child: Row(
                      children: [
                        const Text(
                          'Valid for :',
                          style: TextStyle(
                            color: Color(0xFF707070),
                            fontSize: 14,
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Obx(() => Text(
                              "0${verifyC.secondsRemaining.value}:00 minute",
                              style: const TextStyle(
                                color: Color(0xFF2B2B2B),
                                fontSize: 14,
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.w600,
                              ),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(
                          () => TextButton(
                            onPressed: controller.isButtonDisabled.value
                                ? null
                                : () {
                                    controller.startTimer();
                                    controller.disableButtonForDuration();
                                    controller.reSend();
                                  },
                            child: Text(
                              'Resend code',
                              style: TextStyle(
                                color: controller.isButtonDisabled.value ? AppColors.disableColor : AppColors.textcolor,
                                fontSize: 14,
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: 300,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: controller.authException.value == "AuthException" ? AppColors.invalidColor.withOpacity(0.4) : const Color(0xFFEAF7F2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(child: Obx(() {
                      return Text(
                        controller.authException.value == "AuthException"
                            ? "Entered code is invalid"
                            : controller.isResponse.value
                                ? 'New code has been sent'
                                : 'Code has sent to entered \nmobile number',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: controller.authException.value == "AuthException"
                              ? AppColors.invalidColor
                              : controller.isResponse.value
                                  ? AppColors.greenColor
                                  : AppColors.greenColor,
                          fontSize: 14,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.16,
                        ),
                      );
                    })),
                  ],
                ),
              ),
              const Expanded(child: SizedBox()),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Obx(
                  () => ReusableGradientButton(
                    width: 250,
                    height: 48,
                    gradient: verifyC.verifyOtpController.value.text.length == 6 ? AppColors.linearGradient : AppColors.disablelinearGradient,
                    onPressed: verifyC.verifyOtpController.value.text.length == 6
                        ? () async {
                            if (!verifyC.isLoading.isTrue) {
                              final otpResponse = await controller.verifyWithOtp();
                              if (kDebugMode) {
                                print("otpResponseotpResponse$otpResponse");
                              }

                              if (otpResponse == true) {
                                int? id = await verifyC.getProfiles(controller.uuid.value.toString());

                                if (id == null) {
                                  Get.offAll(buildWelcomePage());
                                } else if (id == 2) {
                                  Get.toNamed(Routes.HOME);
                                } else {
                                  CustomSnackBar.showCustomErrorToast(message: 'Already Registered! Please Contact Admin');
                                  await verifyC.logout();
                                  await verifyC.resetTimer();
                                  Get.to(() => exestingAccontPage());
                                }

                                await verifyC.autoLogout();
                              }
                            }
                          }
                        : null,
                    child: verifyC.isLoading.isFalse
                        ? const Text(
                            'Verify OTP',
                            textAlign: TextAlign.center,
                            style: buttonTextStyle,
                          )
                        : const CircularProgressIndicator(),
                  ),
                ),
              ),

              // Padding(
              //   padding: const EdgeInsets.only(bottom: 20),
              //   child: Obx(
              //     () => ReusableGradientButton(
              //       width: 250,
              //       height: 48,
              //       gradient: verifyC.verifyOtpController.value.text.length == 6 ? AppColors.linearGradient : AppColors.disablelinearGradient,
              //       onPressed: verifyC.verifyOtpController.value.text.length == 6
              //           ? () async {
              //               if (!verifyC.isLoading.isTrue) {
              //                 final otpResponse = await controller.verifyWithOtp();
              //                 if (kDebugMode) {
              //                   print("otpResponseotpResponse$otpResponse");
              //                 }
              //                 if (otpResponse == true) {
              //                   int? id = await verifyC.getProfiles(controller.uuid.value.toString());

              //                   if (id == null) {
              //                     Get.offAll(buildWelcomePage());
              //                   } else if (id == 2) {
              //                     Get.toNamed(Routes.HOME);
              //                   } else {
              //                     CustomSnackBar.showCustomErrorToast(message: 'Already Registered! Please Contact Admin');
              //                     await verifyC.logout();
              //                     await verifyC.resetTimer();
              //                     Get.to(() => exestingAccontPage());
              //                     // Get.offAllNamed(exestingAccontPage());
              //                   }
              //                   await verifyC.autoLogout();
              //                 }
              //               }
              //             }
              //           : null,
              //       child: verifyC.isLoading.isFalse
              //           ? const Text(
              //               'Verify OTP',
              //               textAlign: TextAlign.center,
              //               style: buttonTextStyle,
              //             )
              //           : const CircularProgressIndicator(),
              //     ),
              //   ),
              // ),
            ],
          ),
        ));
  }
}

Widget buildWelcomePage() {
  return Scaffold(
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 100,
                height: 30.47,
                child: Image.asset(
                  ImagesColletions.logo,
                ),
              ),
              const Spacer(),
              const SizedBox(
                width: 266,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Successfully\n',
                              style: TextStyle(
                                color: AppColors.textcolor,
                                fontSize: 36,
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: 'signed-In',
                              style: TextStyle(
                                color: Color(0xFF404040),
                                fontSize: 36,
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
                    SizedBox(
                      width: 266,
                      child: Text(
                        'Welcome back to the Prajalok\ncommunity',
                        style: TextStyle(
                          color: Color(0xFF404040),
                          fontSize: 16,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(child: SizedBox()),
              ReusableGradientButton(
                width: 250,
                height: 48,
                gradient: AppColors.linearGradient,
                onPressed: () {
                  Get.to(() => ProfileView());
                },
                child: const Text(
                  "Continue",
                  style: buttonTextStyle,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget exestingAccontPage() {
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
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              const Spacer(),
              SizedBox(
                width: 266,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SvgPicture.asset(
                      ImagesColletions.manconfusedSvg,
                      fit: BoxFit.cover,
                    ),
                    // const SizedBox(height: 32),
                    const SizedBox(
                      width: 282,
                      child: Text(
                        '    Your phone number is already associated with our other products.',
                        style: TextStyle(
                          color: Color(0xFF404040),
                          fontSize: 16,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(child: SizedBox()),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.to(() => LoginView());
                    },
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        color: AppColors.textcolor,
                        fontSize: 16,
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Text(
                    "with other number",
                    style: TextStyle(
                      color: AppColors.blacktxtColor,
                      fontSize: 16,
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
              const Text(
                "Or",
                style: TextStyle(
                  color: AppColors.textcolor,
                  fontSize: 16,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.snackbar("Contact", " Not Available", backgroundColor: Colors.red, colorText: Colors.white);
                    },
                    child: const Text(
                      "Contact",
                      style: TextStyle(
                        color: AppColors.textcolor,
                        fontSize: 16,
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Text(
                    "for further information",
                    style: TextStyle(
                      color: AppColors.blacktxtColor,
                      fontSize: 16,
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
