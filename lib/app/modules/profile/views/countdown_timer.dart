import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:prajalok/app/routes/app_pages.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:prajalok/app/utils/icons_const.dart';
import 'package:prajalok/app/utils/widget_const.dart';
import '../controllers/profile_controller.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';

//bf8bb37f-07c4-4903-9c59-da8b31aa1b21
class CountdownTimer extends StatelessWidget {
  CountdownTimer({super.key});
  final profileC = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 45, right: 45.6),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Spacer(),
                SizedBox(
                  width: 300,
                  child: Column(
                    children: [
                      SizedBox(
                        child: SvgPicture.asset(SvgIcons.manTiredSvg),
                      ),
                      Text(
                        'Your account deletion initiated.\n',
                        style: createCustomTextStyle(
                          color: AppColors.blacktxtColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        width: 256,
                        child: Text(
                          'you can still restore it if you change your mind.',
                          textAlign: TextAlign.center,
                          style: createCustomTextStyle(
                            color: AppColors.grey44,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 66,
                      ),
                      Text(
                        'Countdown timer',
                        textAlign: TextAlign.center,
                        style: createCustomTextStyle(
                          color: AppColors.blacktxtColor2,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(2),
                        width: 180,
                        height: 50,
                        decoration: BoxDecoration(color: AppColors.stausYellowHalfColor, borderRadius: BorderRadius.circular(12)),
                        child: TimerCountdown(
                          colonsTextStyle: createCustomTextStyle(color: AppColors.blacktxtColor, fontSize: 16, fontWeight: FontWeight.w600),
                          timeTextStyle: createCustomTextStyle(color: AppColors.invalidColor, fontSize: 16, fontWeight: FontWeight.w500),
                          descriptionTextStyle: createCustomTextStyle(color: AppColors.textcolor, fontSize: 16, fontWeight: FontWeight.w500),
                          spacerWidth: 5,
                          enableDescriptions: true,
                          daysDescription: "days",
                          hoursDescription: "hrs",
                          minutesDescription: "min",
                          secondsDescription: "sec",
                          format: CountDownTimerFormat.daysHoursMinutesSeconds,
                          endTime: DateTime.parse(profileC.profileModel[0].deletedAt.toString()).add(
                            const Duration(
                              days: 7,
                              hours: 12,
                              minutes: 56,
                            ),
                          ),
                          onEnd: () {
                            print("Timer finished");
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Obx(() {
                  return ReusableGradientButton(
                    width: 250,
                    height: 48,
                    gradient: AppColors.linearGradient,
                    onPressed: () async {
                      if (!profileC.isLoading.value) {
                        bool? result = await profileC.restoreAccount();
                        if (result == true) {
                          Get.offAllNamed(Routes.ONBOARDING);
                          // Get.offAll(ProfileCompleted());
                        }
                      }
                    },
                    child: profileC.isLoading.value
                        ? const CircularProgressIndicator()
                        : const Text(
                            "Restore account",
                            style: buttonTextStyle,
                          ),
                  );
                }),
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
