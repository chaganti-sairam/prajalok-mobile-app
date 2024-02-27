import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prajalok/app/utils/api_const.dart';
import '../../../data/serlization/module.dart';
import '../../profile/controllers/profile_controller.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  final profileC = Get.put(ProfileController());
  final RxInt currentIndexTyping = 0.obs;
  final RxInt currentIndex = 0.obs;
  final RxInt currentCharIndex = 0.obs;

  final List<String> strings = [
    "Neighbour constructed a wall on my land",
    "a wall on my land.|",
  ];

  void typingAnimation() {
    if (currentCharIndex < strings[currentIndexTyping.value].length) {
      currentCharIndex.value++;
    } else {
      currentIndexTyping.value = (currentIndexTyping.value + 1) % strings.length;
      currentCharIndex.value = 0;
    }
    Future.delayed(const Duration(milliseconds: 150), () {
      typingAnimation();
    });
  }

  void SetSatate(index) {
    currentIndex.value = index;
  }

  late PageController pageController;

  @override
  void onInit() {
    profileC.getProfiles();
    pageController = PageController(initialPage: currentIndex.value);
    typingAnimation();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.onInit();
    // final subscription = supabase.schema(ApiConst.coreshema).from('modules').stream(primaryKey: ['id']).listen((event) {
    //   //  streamedData.value = event;
    //   streamResult.value = event.map((e) => Module.fromJson(e)).toList();
    //   print("streamResult  $streamResult");
    // });
    // ever(streamResult, (_) => subscription.cancel());
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
  //  streamResult.value = value?.map((e) => Module.fromJson(e)).toList();

  final streamResult = <Module>[].obs;
  final price = 0.obs;
  Future<dynamic> getModule(int id) async {
    try {
      final result = await supabase.schema(ApiConst.coreshema).from('modules').select().eq("id", id);
      price.value = result[0]["price"];
      streamResult.value = result.map((e) => Module.fromJson(e)).toList();
    } catch (e) {
      print("eeeeeeeeeeeeee$e");
    }
  }

// RazaorPay integartion setup

  final _razorpay = Razorpay();
  String apiKey = 'rzp_test_R3dodAqKlWEH1f';
  String apiSecret = 'lqwRZBuPsjQlKK82Fh2gWC30';

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    // Here we get razorpay_payment_id razorpay_order_id razorpay_signature
  }
  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
  }

  Future<void> initiatePayment(int amount, int moduleId) async {
    http.Response response = await http.post(
      Uri.parse(ApiConst.apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic ${base64Encode(utf8.encode('$apiKey:$apiSecret'))}',
      },
      body: jsonEncode({
        'amount': "50",
        'currency': 'INR',
        'receipt': 'order_receipt',
        'payment_capture': '1',
      }),
    );
    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      String orderId = responseData['id'];
      //String orderId = responseData['id'];
      var options = {
        'key': apiKey,
        'amount': "50",
        'name': 'Prajalok App',
        'description': 'this is the test payment',
        'module_id': orderId,
        //'prefill': {'contact': '1234567890', 'email': 'test@example.com'},
        // 'external': {
        //   'wallets': ['paytm']
        // }
      };
      _razorpay.open(options);
    } else {
      debugPrint('Error creating order: ${response.body}');
    }
  }
}
