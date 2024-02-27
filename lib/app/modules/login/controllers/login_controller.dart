import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:prajalok/app/routes/app_pages.dart';
import 'package:prajalok/app/utils/api_const.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginController extends GetxController {
  Timer? authTimer;
  final isLoading = false.obs;
  final isHide = false.obs;
  final Rx<FocusNode> myFocusNode = FocusNode().obs;

  void passwordVisibility() {
    isHide.value = !isHide.value;
  }

  final isResponse = false.obs;

  void toggleResposne() {
    isResponse.value = !isResponse.value;
  }

  final isloginRegister = false.obs;
  void toggleLoginRegister(bool value) {
    isloginRegister.value = value;
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }

  Future<void> resetTimer() async {
    if (authTimer != null) {
      authTimer!.cancel();
      authTimer = null;
    }
  }

  Future<void> autoLogout() async {
    if (authTimer != null) {
      authTimer!.cancel();
    }
    authTimer = Timer(const Duration(seconds: 3600), () async {
      await supabase.auth.signOut();
      Get.offAllNamed(Routes.ONBOARDING);
    }); // after login will run auto logout after 1 hours
  }

  final phoneController = TextEditingController().obs;
  final verifyOtpController = TextEditingController().obs;

  var isButtonDisabled = false.obs;

  void disableButtonForDuration() {
    isButtonDisabled.value = true;
    Timer(const Duration(seconds: 30), () {
      isButtonDisabled.value = false;
    });
  }

  final pNumberhonebox = GetStorage();

  void storeValue() {
    pNumberhonebox.write('phone', phoneController.value.text);
    if (kDebugMode) {
      print('Value stored: ${pNumberhonebox.changes}');
    }
    phoneController.value.text = pNumberhonebox.read('phone');
  }

  String? getStoredValue() {
    return pNumberhonebox.read('phone');
  }

  Future<bool?> reSend() async {
    isLoading.value = true;
    try {
      await supabase.auth
          .signInWithOtp(
        phone: getStoredValue().toString(),
        shouldCreateUser: true,
      )
          .then((value) {
        startTimer();
        toggleResposne();
      }).onError((error, stackTrace) {
        Get.snackbar("Error", "$error");
      });
      isLoading.value = false;
      return true;
    } catch (error, stackTrace) {
      Get.snackbar("$error", "$stackTrace");
    }
    isLoading.value = false;
    return false;
  }

  Future<bool?> signInWithOtp() async {
    isLoading.value = true;
    try {
      await supabase.auth
          .signInWithOtp(
        phone: phoneController.value.text.toString(),
        shouldCreateUser: true,
      )
          .then((value) {
        Get.snackbar("Send", "Otp");
      }).onError((error, stackTrace) {
        Get.snackbar("Error", "$error");
      });
      isLoading.value = false;
      return true;
    } catch (error, stackTrace) {
      Get.snackbar("$error", "$stackTrace");
    }
    isLoading.value = false;
    return false;
  }

  final RxString uuid = "".obs;
  final authException = "".obs;

  Future<bool?> verifyWithOtp() async {
    isLoading.value = true;
    try {
      var response = await supabase.auth.verifyOTP(
        phone: getStoredValue().toString(),
        token: verifyOtpController.value.text,
        type: OtpType.sms,
      );

      Get.snackbar("Verified Otp", "${response.user?.phone}");
      uuid.value = response.user!.id;
      getProfiles(response.user?.id);

      isLoading.value = false;
      return true;
    } catch (error) {
      authException.value = error.toString();
      if (kDebugMode) {
        print("error: $error");
      }
      Get.snackbar("Error", "$error");
      isLoading.value = false;
      return false;
    }
  }

  // Future<bool?> verifyWithOtp() async {
  //   isLoading.value = true;
  //   try {
  //     await supabase.auth
  //         .verifyOTP(
  //       phone: getStoredValue().toString(),
  //       token: verifyOtpController.value.text,
  //       type: OtpType.sms,
  //     )
  //         .then((value) {
  //       Get.snackbar("Verified Otp", "${value.user?.phone}");
  //       uuid.value = value.user!.id;
  //       getProfiles(value.user?.id);
  //     }).onError((error, stackTrace) {
  //       authException.value = error.toString();
  //       if (kDebugMode) {
  //         print("errorerror $error  $stackTrace");
  //       }
  //       Get.snackbar("Error", "$error");
  //     });
  //     isLoading.value = false;
  //     return true;
  //   } catch (e, StackTrace) {
  //     if (kDebugMode) {
  //       print("$e  , $StackTrace");
  //     }
  //   }
  //   isLoading.value = false;
  //   return false;
  // }

  Future<int?> getProfiles(uuid) async {
    try {
      final result = await supabase.schema(ApiConst.coreshema).from("profiles").select("*").eq('id', uuid.toString());
      if (kDebugMode) {
        print("profilleeeee1 ${result[0]["role_id"]}");
      }
      return result[0]["role_id"];
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }

  // ?? Timer

  RxInt secondsRemaining = 60.obs;
  RxBool isButtonEnabled = true.obs;
  late Timer _timer;

  @override
  void onClose() {
    // myFocusNode.value.dispose();
    super.onClose();
    _timer.cancel();
  }

  @override
  void onInit() {
    //  toggleLoginRegister();
    startTimer();
    super.onInit();
    myFocusNode.value = FocusNode();
    myFocusNode.listen(requestFocus);
  }

  void requestFocus(context) {
    FocusScope.of(context).requestFocus(myFocusNode.value);
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (secondsRemaining.value == 0) {
        timer.cancel();
        isButtonEnabled.value = true; // Enable the button after the timer ends
      } else {
        secondsRemaining.value--;
      }
    });
  }

  void handleButtonPress() {
    startTimer();
    // isButtonEnabled.value = false;
  }
}
