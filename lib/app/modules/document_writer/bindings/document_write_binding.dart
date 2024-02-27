import 'package:get/get.dart';

import '../controllers/document_write_controller.dart';

class DocumentWriteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DocumentWriteController>(
      () => DocumentWriteController(),
    );
  }
}
