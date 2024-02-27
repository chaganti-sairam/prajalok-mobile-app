import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:prajalok/app/utils/api_const.dart';
import 'package:prajalok/app/utils/customer_loading.dart';
import 'package:prajalok/app/utils/icons_const.dart';
import 'package:prajalok/app/utils/widget_const.dart';
import '../controllers/analysis_controller.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:prajalok/app/utils/widgetButton.dart';
import 'dart:math' as math;
import 'recent_clientAnalysis.dart';

// ignore: must_be_immutable
class AnalysisView extends GetView<AnalysisController> {
  AnalysisView({Key? key}) : super(key: key);
  @override
  final controller = Get.put(AnalysisController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Describe the Issue",
        onActionPressed: () {
          RecentClientAnlysisSheet(context);
        },
        actionIcon: SvgPicture.asset(SvgIcons.recentlyicons),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      width: 1,
                      color: controller.myFocusNode.value.hasFocus ? AppColors.textcolor : Color(0xFFCFCFCF),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      Obx(
                        () => TextFormField(
                          focusNode: controller.myFocusNode.value,
                          controller: controller.userQueryController.value,
                          keyboardType: TextInputType.multiline,
                          onChanged: (value) {
                            controller.userQueryController.refresh();
                          },
                          onTapOutside: (event) {
                            if (kDebugMode) {
                              print('onTapOutside');
                            }
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          maxLength: 80,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            hintText: "Type here....",
                            border: InputBorder.none,
                            counter: Text(""),
                            contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                          ),
                          onTap: () {
                            controller.requestFocus(context);
                          },
                        ),
                      ),
                      Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Obx(() => Text(
                                    '${controller.userQueryController.value.text.length}/80',
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      color: Color(0xFF8F8F8F),
                                      fontSize: 12,
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )))),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 32),
                child: WidgetButtonPress(
                  child: Obx(() {
                    return ReusableGradientButton(
                      gradient: controller.userQueryController.value.text.length > 10 ? AppColors.linearGradient : AppColors.disablelinearGradient,
                      onPressed: controller.userQueryController.value.text.length > 10
                          ? () async {
                              bool? res = await controller.sendData();
                              if (res != null) {
                                supabase
                                    .schema(ApiConst.clientShema)
                                    .from('client_query')
                                    .stream(primaryKey: ['id'])
                                    .eq('id', controller.queryId.value)
                                    .listen((data) {
                                      if (data[0]['task_id'] != null) {
                                        Get.back();
                                        controller.webSocketConnection(data[0]['task_id'].toString());
                                        if (kDebugMode) {
                                          print("TaskIDDDD  :${data[0]['task_id'].toString()}");
                                        }
                                      }
                                    });
                              }
                              Get.dialog(barrierDismissible: false, const ReusableProcessingDialog());
                            }
                          : null,
                      height: 35,
                      child: const Text(
                        'Solve my issue',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 12),
                child: SizedBox(
                  width: Get.width,
                  child: const Text(
                    'Most common issues',
                    style: TextStyle(
                      color: Color(0xFF2B2B2B),
                      fontSize: 16,
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: MasonryGridView.count(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  itemBuilder: (context, index) {
                    return WidgetButtonPress(
                      child: GestureDetector(
                        onTap: () {
                          controller.userQueryController.value.text = 'Spouse seeks unreasonable alimony after divorce.';
                        },
                        child: Container(
                          width: Get.width,
                          height: 130,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO((math.Random()).nextInt(255), (math.Random()).nextInt(255), (math.Random()).nextInt(255), 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(width: 1, color: const Color(0xFFEFEFEF))),
                          child: const Padding(
                            padding: EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Spouse",
                                  style: TextStyle(
                                    color: Color(0xFF404040),
                                    fontSize: 16,
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  // res.refinedQuery.toString(),
                                  'Spouse seeks unreasonable alimony after divorce.',
                                  style: TextStyle(
                                    color: Color(0xFF606060),
                                    fontSize: 12,
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.visibility,
                                            size: 15,
                                            color: AppColors.blacktxtColor,
                                          ),
                                          Text(
                                            "126",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'Open Sans',
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xFF606060),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.thumb_up_outlined,
                                            size: 15,
                                            color: AppColors.blacktxtColor,
                                          ),
                                          Text(
                                            "126",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'Open Sans',
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xFF606060),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
