import 'package:get/get.dart';

class NotifcationController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  final switchValue1 = true.obs;
  final switchValue2 = false.obs;
  final switchValue3 = true.obs;

  void setState(value) {
    switchValue1.value = value!;
  }

  void setState2(value) {
    switchValue2.value = value!;
  }

  void setState3(value) {
    switchValue3.value = value!;
  }
}
