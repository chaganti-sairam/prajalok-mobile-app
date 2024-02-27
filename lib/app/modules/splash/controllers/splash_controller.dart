import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:prajalok/app/routes/app_pages.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashController extends GetxController {
  User? _user;

  @override
  void onInit() {
    _getAuth();
    checkInternet();
    super.onInit();
  }

  Future<void> _getAuth() async {
    _user = Supabase.instance.client.auth.currentUser;
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      _user = data.session?.user;
    });
  }

  Future<void> checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (_user != null) {
          Get.offAllNamed(Routes.HOME);
        } else {
          Get.offAllNamed(Routes.ONBOARDING);
        }
      });
    } else {
      Get.toNamed(Routes.SPLASH);
      Get.snackbar("No Internet", "Please check your internet connection");
    }
  }

  @override
  void onReady() {
    super.onReady();
  }
}






// class SplashController extends GetxController {
//   User? _user;

//   @override
//   void onInit() {
//     _getAuth();
//     super.onInit();
//   }

//   Future<void> _getAuth() async {
//     _user = Supabase.instance.client.auth.currentUser;
//     Supabase.instance.client.auth.onAuthStateChange.listen((data) {
//       _user = data.session?.user;
//     });
//   }

// Future<bool> checkInternet() async {
//   var connectivityResult = await (Connectivity().checkConnectivity());
//   if (connectivityResult == ConnectivityResult.mobile) {
//     return true;
//   } else if (connectivityResult == ConnectivityResult.wifi) {
//     return true;
//   }
//   return false;
// }

//   @override
//   void onReady() {

// if (_user != null) {
//   Future.delayed(const Duration(milliseconds: 500), () {
//     Get.offAllNamed(Routes.HOME);
//   });
//     } else {
//       Get.offAllNamed(Routes.ONBOARDING);
//     }

//     super.onReady();
//   }
// }