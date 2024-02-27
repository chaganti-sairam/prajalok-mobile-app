import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prajalok/app/modules/home/views/home_view.dart';
import 'package:prajalok/app/modules/profile/controllers/profile_controller.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:prajalok/app/utils/icons_const.dart';
import 'package:prajalok/app/utils/widget_const.dart';

class ProfileComplted extends StatelessWidget {
  ProfileComplted({super.key});
  final profileC = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: Center(
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 100,
                  height: 30.47,
                  child: Image.asset(
                    ImagesColletions.logo,
                  ),
                ),
                const Spacer(),
                const SizedBox(
                  width: 266,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Nicely done!\n',
                                style: TextStyle(
                                  color: AppColors.textcolor,
                                  fontSize: 36,
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: 'completed profile setup',
                                style: TextStyle(
                                  color: Color(0xFF404040),
                                  fontSize: 36,
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 32),
                      SizedBox(
                        width: 266,
                        child: Text(
                          'Welcome to the Prajalok\ncommunity',
                          style: TextStyle(
                            color: Color(0xFF404040),
                            fontSize: 16,
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Expanded(child: SizedBox()),
                ReusableGradientButton(
                  width: 250,
                  height: 48,
                  gradient: AppColors.linearGradient,
                  onPressed: () {
                    Get.to(() => HomeView());
                  },
                  child: const Text(
                    "Continue",
                    style: buttonTextStyle,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
