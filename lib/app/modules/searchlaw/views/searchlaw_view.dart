import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:prajalok/app/modules/searchlaw/views/recent_search_law.dart';
import 'package:prajalok/app/utils/api_const.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:prajalok/app/utils/compnent/module_top_lebel.dart';
import 'package:prajalok/app/utils/customer_loading.dart';
import 'package:prajalok/app/utils/icons_const.dart';
import 'package:prajalok/app/utils/widget_const.dart';
import '../controllers/searchlaw_controller.dart';

class SearchlawView extends GetView<SearchlawController> {
  SearchlawView({Key? key}) : super(key: key);
  final controller1 = Get.put(SearchlawController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Search law",
        onActionPressed: () {
          RecentSearchideSheet(context);
        },
        actionIcon: SvgPicture.asset(SvgIcons.recentlyicons),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: <Widget>[
                buildTopBar(
                  SvgIcons.searchIcons,
                  'Search for a',
                  'specific law/scenario\n word/phrase',
                ),
                SizedBox(height: 16),
                Obx(() {
                  return Container(
                    height: 117,
                    padding: const EdgeInsets.all(12),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          color: controller.isFocused.value ? AppColors.textcolor : AppColors.disableColor,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: TextFormField(
                      onTapOutside: (event) {
                        if (kDebugMode) {
                          print('onTapOutside');
                        }
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      focusNode: controller.focusNode,
                      onChanged: (value) {
                        controller.searchController.refresh();
                      },
                      controller: controller.searchController.value,
                      keyboardType: TextInputType.multiline,
                      maxLength: 80,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Ex: Right to information act',
                        hintStyle: TextStyle(
                          color: Color(0xFFBFBFBF),
                          fontSize: 14,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w400,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: Obx(() {
              return ReusableGradientButton(
                width: 250,
                height: 48,
                gradient: controller.searchController.value.text.length > 10 ? AppColors.linearGradient : AppColors.disablelinearGradient,
                onPressed: controller.searchController.value.text.length > 10
                    ? () async {
                        Get.dialog(
                          const ReusableProcessingDialog(),
                        );
                        bool? res = await controller.sendSearchQuery();
                        if (res != null) {
                          supabase
                              .schema(ApiConst.staticshema)
                              .from("law_search")
                              .stream(primaryKey: ["id"])
                              .eq('id', controller.queryId.value)
                              .listen((data) {
                                if (data[0]['task_id'] != null) {
                                  if (Get.isDialogOpen!) {
                                    Get.back();
                                  }
                                  controller.webSocketConnect(data[0]['task_id'].toString());
                                  controller.stream.value = data;
                                }
                              });
                        }
                      }
                    : null,
                child: const Text(
                  "Search Law",
                  style: buttonTextStyle,
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}
