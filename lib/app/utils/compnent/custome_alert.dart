import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:prajalok/app/utils/widget_const.dart';

import '../icons_const.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final bool visible;
  final VoidCallback onNoPressed;
  final VoidCallback onYesPressed;
  const CustomAlertDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.visible,
    required this.onNoPressed,
    required this.onYesPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Visibility(
            visible: visible,
            child: SizedBox(
              height: 100,
              width: 250,
              child: Center(
                child: FittedBox(
                  child: Lottie.asset(
                    AnimatedJson.alertjson, // Replace with your animation path
                    width: 200,
                    height: 200,
                    animate: true,
                    alignment: Alignment.topCenter,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: createCustomTextStyle(color: AppColors.blacktxtColor2, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.blacktxtColor2, fontSize: 15, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              ReusableGradienOutlinedtButton(
                width: 100,
                height: 45,
                onPressed: onNoPressed,
                child: Text(
                  'No',
                  style: createCustomTextStyle(color: AppColors.textcolor),
                ),
              ),
              //  const SizedBox(width: 0),
              ReusableGradientButton(
                width: 100,
                height: 45,
                gradient: AppColors.linearGradient,
                onPressed: onYesPressed,
                child: Text(
                  'Yes',
                  style: createCustomTextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
