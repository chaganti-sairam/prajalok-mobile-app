import 'package:get/get.dart';

import '../controllers/document_analysis_controller.dart';

class DocumentAnalysisBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DocumentAnalysisController>(
      () => DocumentAnalysisController(),
    );
  }
}
