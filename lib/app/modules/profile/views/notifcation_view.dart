import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:prajalok/app/utils/widget_const.dart';

import '../controllers/notifcation_controller.dart';

class NotifcationView extends GetView<NotifcationController> {
  NotifcationView({Key? key}) : super(key: key);
  @override
  final controller = Get.put(NotifcationController());
  TextStyle titleStyle = createCustomTextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: AppColors.blacktxtColor,
  );
  TextStyle subtitleStyle = createCustomTextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: AppColors.grey44,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text("Notifications",
            style: createCustomTextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: AppColors.blacktxtColor,
            )),
      ),
      body: Container(
          height: 200,
          width: Get.width,
          margin: const EdgeInsets.only(top: 16),
          color: Colors.white,
          //padding: const EdgeInsets.all(16),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              MergeSemantics(
                child: ListTile(
                  visualDensity: VisualDensity.compact,
                  titleTextStyle: titleStyle,
                  subtitleTextStyle: subtitleStyle,
                  title: const Text("Push notifications"),
                  subtitle: const Text("Receive real-time updates and alerts"),
                  trailing: Obx(() {
                    return Transform.scale(
                      scale: 0.9,
                      child: CupertinoSwitch(
                        activeColor: AppColors.textcolor,
                        value: controller.switchValue1.value,
                        onChanged: (bool? value) {
                          controller.setState(value);
                        },
                      ),
                    );
                  }),
                ),
              ),
              MergeSemantics(
                child: ListTile(
                  visualDensity: VisualDensity.compact,
                  titleTextStyle: titleStyle,
                  subtitleTextStyle: subtitleStyle,
                  title: const Text("Email notifications"),
                  subtitle: const Text("Receive real-time updates and alerts"),
                  trailing: Obx(() {
                    return Transform.scale(
                      scale: 0.9,
                      child: CupertinoSwitch(
                        activeColor: AppColors.textcolor,
                        value: controller.switchValue2.value,
                        onChanged: (bool? value) {
                          controller.setState2(value);
                        },
                      ),
                    );
                  }),
                ),
              ),
              ListTile(
                visualDensity: VisualDensity.compact,
                titleTextStyle: titleStyle,
                subtitleTextStyle: subtitleStyle,
                title: const Text("In-app alerts"),
                subtitle: const Text("Receive real-time updates and alerts"),
                trailing: Obx(() {
                  return Transform.scale(
                    scale: 0.9,
                    child: CupertinoSwitch(
                      activeColor: AppColors.textcolor,
                      value: controller.switchValue3.value,
                      onChanged: (bool? value) {
                        controller.setState3(value);
                      },
                    ),
                  );
                }),
              ),
            ],
          )),
    );
  }
}
