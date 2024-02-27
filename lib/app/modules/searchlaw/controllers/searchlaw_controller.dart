import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prajalok/app/data/serlization/lawsearchmodel.dart';
import 'package:prajalok/app/data/webSoketModel.dart/searchLaw.dart';
import 'package:prajalok/app/utils/api_const.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:prajalok/app/utils/customer_loading.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../views/search_result.dart';

class SearchlawController extends GetxController {
  final FocusNode focusNode = FocusNode();

  final isLoading = false.obs;
  final queryId = 0.obs;
  final stream = Rx<dynamic>(null);
  final uuid = supabase.auth.currentUser?.id;
  var isDialogVisible = false.obs;
  final searchController = TextEditingController().obs;
  final lawSearchModel = <LawSearchModel>[].obs;
  RxBool isFocused = false.obs;

  @override
  void onInit() {
    focusNode.addListener(() {
      isFocused.value = focusNode.hasFocus;
    });
    super.onInit();
  }

  Future<bool?> sendSearchQuery() async {
    isLoading.value = true;
    try {
      final result = await supabase.schema(ApiConst.staticshema).from("law_search").insert({
        "profile_id": uuid,
        "query": searchController.value.text,
      }).select();
      queryId.value = result[0]['id'];
      if (kDebugMode) {
        print('ResponseBody: $result');
      }
      isLoading.value = false;
      return true;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("hhhhhhhh $e, $stackTrace");
      }
      isLoading.value = false;

      return false;
    }
  }

  Rx<SearchLawWebSoketModel?> searchLawWebSoketModel = Rx<SearchLawWebSoketModel?>(null);

  void webSocketConnect(taskid) {
    if (kDebugMode) {
      print("taskID $taskid");
    }
    final wsUrl = Uri.parse("ws://redis-manager-yxfpjr3pvq-el.a.run.app/ws/$taskid");
    var channel = WebSocketChannel.connect(wsUrl);
    channel.stream.listen((message) {
      final data = jsonDecode(message);
      searchLawWebSoketModel.value = SearchLawWebSoketModel.fromJson(data);
      if (data["overall_status"] == true) {
        fetchData();
        closeDialog();
        Get.to(() => SearcResult());
      } else {
        showStatusDialog();
      }
      channel.sink.add('received!');
      if (kDebugMode) {
        print("webSocketMessage $message");
      }
    });
  }

  void showStatusDialog() {
    if (!isDialogVisible.value) {
      isDialogVisible.toggle();
      Get.dialog(
        barrierDismissible: false,
        AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          contentPadding: EdgeInsets.zero,
          title: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Searching',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textcolor,
                  fontSize: 20,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'laws',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.blacktxtColor,
                  fontSize: 20,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Obx(
            () => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                WebSoketDilog(
                  label: searchLawWebSoketModel.value?.updateMessage?.executingLawSearch?.label,
                  description: searchLawWebSoketModel.value?.updateMessage?.executingLawSearch?.description,
                  status: searchLawWebSoketModel.value?.updateMessage?.executingLawSearch?.status,
                ),
                WebSoketDilog(
                  label: searchLawWebSoketModel.value?.updateMessage?.consolidatingSearchOutcomes?.label,
                  description: searchLawWebSoketModel.value?.updateMessage?.consolidatingSearchOutcomes?.description,
                  status: searchLawWebSoketModel.value?.updateMessage?.consolidatingSearchOutcomes?.status,
                ),
                WebSoketDilog(
                  label: "Overall Status",
                  description: searchLawWebSoketModel.value?.overallStatus == true ? "Success" : "Failed",
                  status: searchLawWebSoketModel.value?.overallStatus,
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  void closeDialog() {
    if (isDialogVisible.value) {
      Get.back();
      isDialogVisible.toggle();
    }
  }

  final searchModel = <LawSearchModel>[].obs;
  Future<void> fetchData() async {
    try {
      final lawsearchRes = await supabase.schema(ApiConst.staticshema).from("law_search").select().eq("id", queryId.value);
      final result = lawsearchRes;
      lawSearchModel.value = result.map((e) => LawSearchModel.fromJson(e)).toList(growable: false);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  void onClose() {
    searchController.value.dispose();
    super.onClose();
  }
}
