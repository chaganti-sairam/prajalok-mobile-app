import 'package:get/get.dart';

import 'package:prajalok/app/modules/profile/controllers/notifcation_controller.dart';

import '../controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotifcationController>(
      () => NotifcationController(),
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
  }
}
