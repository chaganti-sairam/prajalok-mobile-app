import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prajalok/app/data/serlization/client_queryModel.dart';
import 'package:prajalok/app/data/webSoketModel.dart/describeModel.dart';
import 'package:prajalok/app/utils/api_const.dart';
import 'package:prajalok/app/utils/customer_loading.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../views/issue_analysis.dart';
import 'dart:developer' as dev;

class AnalysisController extends GetxController {
  final userQueryController = TextEditingController().obs;
  final uuid = supabase.auth.currentUser!.id;
  var isDialogVisible = false.obs;
  final clienQueroutputID = "".obs;
  final stream = Rx<dynamic>(null);
  final websoketStatus = false.obs;
  final RxInt queryId = 0.obs;
  final Rx<FocusNode> myFocusNode = FocusNode().obs;

  RxList<String> RandomImages = [
    "https://images.unsplash.com/photo-1702838834569-bf20a161824c?q=80&w=1602&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
        'https://img.freepik.com/free-photo/portrait-white-man-isolated_53876-40306.jpg',
    "https://images.unsplash.com/photo-1702838834569-bf20a161824c?q=80&w=1602&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
        'https://i0.wp.com/post.medicalnewstoday.com/wp-content/uploads/sites/3/2020/03/GettyImages-1092658864_hero-1024x575.jpg?w=1155&h=1528'
  ].obs;
  Future<bool?> sendData() async {
    try {
      final result = await supabase.schema("clients").from("client_query").insert({
        "profile_id": supabase.auth.currentUser!.id,
        "query": userQueryController.value.text,
      }).select();
      queryId.value = result[0]['id'];
      if (kDebugMode) {
        print('Response Body: $result');
      }
      return true;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("hhhhhhhh $e, $stackTrace");
      }
      return false;
    }
  }

  Rx<ClientQueryWebModel?> clientQueryWebSoketModel = Rx<ClientQueryWebModel?>(null);

  void webSocketConnection(taskId) {
    final wsUrl = Uri.parse("ws://redis-manager-yxfpjr3pvq-el.a.run.app/ws/$taskId");
    var channel = WebSocketChannel.connect(wsUrl);
    channel.stream.listen((message) {
      final data = jsonDecode(message);
      clientQueryWebSoketModel.value = ClientQueryWebModel.fromJson(data);
      if (data["overall_status"] == true) {
        fetchData();
        closeDialog();
        Get.to(() => IssuAnalysis());
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
          title: const Text(
            'Hang in there! \nWe are processing',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFFF5C40),
              fontSize: 20,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Obx(
            () => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                WebSoketDilog(
                  label: clientQueryWebSoketModel.value?.updateMessage?.fetchingQuery?.label,
                  description: clientQueryWebSoketModel.value?.updateMessage?.fetchingQuery?.description,
                  status: clientQueryWebSoketModel.value?.updateMessage?.fetchingQuery?.status,
                ),
                WebSoketDilog(
                  label: clientQueryWebSoketModel.value?.updateMessage?.queryProcessing?.label,
                  description: clientQueryWebSoketModel.value?.updateMessage?.queryProcessing?.description,
                  status: clientQueryWebSoketModel.value?.updateMessage?.queryProcessing?.status,
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

  final clientQueryModel = <ClientQueryModel>[].obs;

  void fetchData() async {
    try {
      final clientQueryRes = await supabase.schema(ApiConst.clientShema).from("client_query").select().eq("id", queryId.value);
      dev.log("logggggg ${jsonEncode(clientQueryRes)}");
      clientQueryModel.value = clientQueryRes.map((e) => ClientQueryModel.fromJson(e)).toList(growable: false);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // Future fetchData() async {
  //   final url = Uri.parse('https://redis-manager-yxfpjr3pvq-el.a.run.app/task-status/${clienQueroutputID.value}'); // Replace with your API endpoint
  //   // Making the GET request
  //   final response = await http.get(url);
  //   if (response.statusCode == 200) {
  //     // If the server returns a 200 OK response, parse the JSON data
  //     var jsonData = json.decode(response.body);
  //     print("jsondatat ${jsonData}");
  //     return jsonData;
  //   } else {
  //     // If the server did not return a 200 OK response, throw an error.
  //     throw Exception('Failed to load data');
  //   }
  // }

  @override
  void onInit() {
    myFocusNode.value = FocusNode();
    super.onInit();
  }

  void requestFocus(context) {
    FocusScope.of(context).requestFocus(myFocusNode.value);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    myFocusNode.value.dispose();
    userQueryController.value.dispose();
    super.onClose();
  }
}
