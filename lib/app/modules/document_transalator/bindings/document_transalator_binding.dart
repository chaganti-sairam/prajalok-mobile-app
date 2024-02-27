import 'package:get/get.dart';

import '../controllers/document_transalator_controller.dart';

class DocumentTransalatorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DocumentTransalatorController>(
      () => DocumentTransalatorController(),
    );
  }
}
