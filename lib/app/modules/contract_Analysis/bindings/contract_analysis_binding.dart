import 'package:get/get.dart';

import '../controllers/contract_analysis_controller.dart';

class ContractAnalysisBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContractAnalysisController>(
      () => ContractAnalysisController(),
    );
  }
}
