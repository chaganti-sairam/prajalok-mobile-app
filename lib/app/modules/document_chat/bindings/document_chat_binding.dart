import 'package:get/get.dart';

import '../controllers/document_chat_controller.dart';

class DocumentChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DocumentChatController>(
      () => DocumentChatController(),
    );
  }
}
