import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:prajalok/app/utils/icons_const.dart';
import 'package:prajalok/app/utils/widget_const.dart';
import '../controllers/login_controller.dart';
import 'verify_otp_view.dart';

class LoginView extends GetView<LoginController> {
  LoginView({Key? key}) : super(key: key);
  @override
  LoginController controller = Get.put(LoginController());
  final loginC = Get.put(LoginController());

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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    return Text(
                      loginC.isloginRegister.isFalse ? "Welcome back! We're delighted to see you again." : 'Become a part \nof our community !',
                      style: GoogleFonts.openSans(
                        color: AppColors.blacktxtColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  }),
                  const SizedBox(height: 12),
                  Obx(() {
                    return Text(
                      loginC.isloginRegister.isFalse
                          ? 'Enter a registered phone number to\nverify your identity.'
                          : 'Create account to begin your journey with us.\nEnter a valid phone number to verify your identity.',
                      style: GoogleFonts.openSans(
                        color: const Color(0xFF606060),
                        fontSize: 14,
                        //  fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Obx(() {
              return TextFormField(
                focusNode: loginC.myFocusNode.value,
                keyboardType: TextInputType.phone,
                controller: loginC.phoneController.value,
                onChanged: (s) {
                  loginC.phoneController.refresh();
                },
                onTap: () {
                  loginC.requestFocus(context);
                },
                decoration: InputDecoration(
                  labelText: "Mobile number",
                  labelStyle: TextStyle(
                    color: loginC.myFocusNode.value.hasFocus ? AppColors.textcolor : Colors.grey,
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.textcolor),
                  ),
                ),
              );
            }),

            // Padding(
            //   padding: const EdgeInsets.only(left: 24, right: 24),
            //   child:
            //    PhoneFieldHint(
            //     controller: loginC.phoneController.value,
            //     decoration: const InputDecoration(
            //       labelText: "Mobile number",
            //       focusedBorder: UnderlineInputBorder(
            //         borderSide: BorderSide(color: Color(0xFFFF5C40)),
            //       ),
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 500),
            const Expanded(child: SizedBox()),

            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Obx(
                () => ReusableGradientButton(
                  width: 250,
                  height: 48,
                  gradient: loginC.phoneController.value.text.length == 10 ? AppColors.linearGradient : AppColors.disablelinearGradient,
                  onPressed: loginC.phoneController.value.text.length == 10
                      ? () async {
                          loginC.storeValue();
                          if (!loginC.isLoading.isTrue) {
                            bool? cekAutoLogout = await controller.signInWithOtp();
                            if (cekAutoLogout == true) {
                              controller.startTimer();
                              controller.disableButtonForDuration();
                              Get.to(() => VerifyOtpView());
                            }
                          }
                        }
                      : null,
                  child: loginC.isLoading.isFalse
                      ? const Text(
                          "Send code",
                          style: buttonTextStyle,
                        )
                      : const CircularProgressIndicator(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




















// String supabaseUrl = 'https://wfzcvhyinqzhjctsdmud.supabase.co';
// String anonKey =
//     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndmemN2aHlpbnF6aGpjdHNkbXVkIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTUzODg0MzQsImV4cCI6MjAxMDk2NDQzNH0.5OuFOMuqZGovjfd-d24frSLEGMhkUS_nO09W_kyWrOI';
// Future signInWithPhone(String phoneNumber) async {
//   try {
//     isLoading.value = true;
//     // print("====== SENDING FROM PHONE NUMBER = $phoneNumber ======");
//     await supabase.auth.signInWithOtp(phone: phoneNumber, shouldCreateUser: true);
//     goToOtpScreen();
//     isLoading.value = false;
//     return true;
//   } catch (e) {
//     SnackbarUtils.customSnackWithIcon(
//       snackType: SnackBarType.error,
//       message: e.toString(),
//     );
//     if (kDebugMode) {
//       // print("======= ERROR PHONE = $e ========");
//     }
//     isLoading.value = false;
//     return false;
//   }
// }
