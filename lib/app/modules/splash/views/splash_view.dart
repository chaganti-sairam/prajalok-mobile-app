import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:prajalok/app/utils/icons_const.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  SplashView({Key? key}) : super(key: key);
  final splashC = Get.put(SplashController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Container(
            height: 55.18,
            decoration: const BoxDecoration(
                color: Colors.transparent,
                image: DecorationImage(
                    repeat: ImageRepeat.noRepeat,
                    filterQuality: FilterQuality.high,
                    fit: BoxFit.fitHeight,
                    image: AssetImage(
                      ImagesColletions.logo,
                    ))),
          ),
        ),
      ),
    );
  }
}
