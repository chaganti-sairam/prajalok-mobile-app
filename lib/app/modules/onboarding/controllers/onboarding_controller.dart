import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  final currentIndex = 0.obs;
  PageController? pageController;
  final end = false.obs;
  @override
  void onInit() {
    pageController = PageController(initialPage: 0);
    Future.delayed(Duration.zero, () {
      Timer.periodic(const Duration(seconds: 2), (Timer timer) {
        if (currentIndex.value == 2) {
          end.value = true;
        } else if (currentIndex.value == 0) {
          end.value = false;
        }
        if (end.value == false) {
          currentIndex.value++;
        } else {
          currentIndex.value--;
        }
        stateUpdate();
      });
    });
    super.onInit();
  }

  @override
  void onClose() {
    pageController?.dispose();
    super.onClose();
  }

  void stateUpdate() {
    if (pageController!.hasClients) {
      pageController?.animateToPage(
        currentIndex.value,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeInOutCubicEmphasized,
      );
    }
  }

  void onChanged(index) {
    currentIndex.value = index;
    update();
  }
}
