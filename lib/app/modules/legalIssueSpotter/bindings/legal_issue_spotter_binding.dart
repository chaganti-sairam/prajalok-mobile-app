import 'package:get/get.dart';

import '../controllers/legal_issue_spotter_controller.dart';

class LegalIssueSpotterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LegalIssueSpotterController>(
      () => LegalIssueSpotterController(),
    );
  }
}
