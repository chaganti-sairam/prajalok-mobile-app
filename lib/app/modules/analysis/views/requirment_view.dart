import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:prajalok/app/utils/color_const.dart';

class RequirmentView extends GetView {
  const RequirmentView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: const Text(
          'Requirment',
          style: TextStyle(
            color: AppColors.blacktxtColor,
            fontWeight: FontWeight.w600,
            fontFamily: 'Open Sans',
            fontSize: 18,
          ),
        ),
        centerTitle: false,
      ),
      body: Center(
          child: Column(
        children: <Widget>[Container()],
      )),
    );
  }
}
