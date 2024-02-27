import 'package:get/get.dart';

import '../controllers/searchlaw_controller.dart';

class SearchlawBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchlawController>(
      () => SearchlawController(),
    );
  }
}
