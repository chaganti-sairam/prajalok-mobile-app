import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:prajalok/app/data/model/stepform.dart';
import 'package:prajalok/app/data/serlization/profile_model.dart';
import 'package:prajalok/app/utils/api_const.dart';

import '../../../utils/constant.dart';
import 'dart:developer' as dev;

class ProfileController extends GetxController {
  final isLoading = false.obs;
  final firstNameC = TextEditingController().obs;
  final lastNameC = TextEditingController().obs;
  final emailC = TextEditingController().obs;
  final loactionC = TextEditingController().obs;
  final lat = 0.0.obs;
  final long = 0.0.obs;
  final List location = <double>[].obs;
  final uuid = supabase.auth.currentUser?.id;
  Functions functions = Functions();
  final RxString publicUrl = "".obs;
  final RxString address = "".obs;

  @override
  onClose() {
    controller?.dispose();
    super.onClose();
  }

  @override
  void onReady() {
    getProfiles();
    super.onReady();
  }

  @override
  void onInit() {
    controller = PageController(initialPage: 0);
    getProfiles();
    super.onInit();
    requestLocationPermission2();
  }

  Rx<Formsteps> formSteps = Formsteps(
    firstName: TextEditingController(),
    lastName: TextEditingController(),
    email: TextEditingController(),
    location: TextEditingController(),
  ).obs;

  Future<bool?> createProfile() async {
    isLoading.value = true;
    try {
      final result = await supabase
          .schema(ApiConst.coreshema)
          .from("profiles")
          .update({
            "role_id": 2,
            "first_name": formSteps.value.firstName.text.toString(),
            "last_name": formSteps.value.lastName.text.toString(),
            "location": [address.value],
            "email_id": formSteps.value.email.text.toString(),
          })
          .eq('id', uuid.toString())
          .select("*");
      isLoading.isFalse;
      Get.snackbar("profile", "$result");
      getProfiles();
      return true;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("$e, $stackTrace");
      }
    }
    isLoading.value = false;
    return false;
  }

  final profileModel = <ProfileModel>[].obs;

  Future<void> getProfiles() async {
    try {
      final result = await supabase.schema(ApiConst.coreshema).from("profiles").select("*").eq('id', uuid.toString());
      profileModel.value = result.map((e) => ProfileModel.fromJson(e)).toList();
      dev.log(jsonEncode(result));
      if (kDebugMode) {
        print("profilleeeee $result");
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  //?----------------------multistepform---------
  RxInt currentIndex = 0.obs;
  PageController? controller;

  void setState(index) {
    currentIndex.value = index;
  }

//? get current location
  Future<void> requestLocationPermission2() async {
    var permissionStatus = await Permission.location.request();
    if (permissionStatus.isGranted) {
      getCurrentLocation2();
    } else {
      // Permission denied, handle accordingly
      // You can show a message or ask the user to grant permission manually
    }
  }

  Future<void> getCurrentLocation2() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      lat.value = position.latitude;
      long.value = position.longitude;
      //print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      address.value = "${place.subLocality},${place.locality}, ${place.administrativeArea},  ${place.country}, ${place.postalCode}";
      formSteps.value.location.text = address.toString();
      if (kDebugMode) {
        print("Amresh $address");
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting location: $e');
      }
    }
  }

  final RxString pickedloacalfile = "".obs;

  Future<void> onPickFiles() async {
    List<File> selectedFiles = await functions.pickFiles();
    if (selectedFiles.isNotEmpty) {
      pickedloacalfile.value = selectedFiles[0].path;
      functions.sendGcsFile(selectedFiles[0].path).then((value) {
        publicUrl.value = value["public_url"];
      });
      Get.back();
      // Do something with the selected files, e.g., update UI, upload to server
    } else {
      // Handle the case where no files were selected
    }
  }

  void takeSnapshot() async {
    File? capturedImage = await functions.captureImage();
    if (capturedImage != null) {
      pickedloacalfile.value = capturedImage.path;
      // Do something with the captured image, e.g., update UI, upload to server
    } else {
      // Handle the case where no image was captured
    }
  }

// updateprofile
  final avatarlUrl = "".obs;
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final locationController = TextEditingController();

  Future<bool?> updateProfile() async {
    isLoading.value = true;
    try {
      final result = await supabase
          .schema(ApiConst.coreshema)
          .from("profiles")
          .update({
            "role_id": 2,
            "first_name": firstNameController.text,
            "last_name": lastNameController.text,
            "location": [locationController.text],
            "email_id": emailController.text,
            "avatar_url": publicUrl.value.toString(),
          })
          .eq('id', uuid.toString())
          .select("*");
      isLoading.isFalse;
      Get.snackbar("profile", "$result");
      getProfiles();
      return true;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("$e, $stackTrace");
      }
    }
    isLoading.value = false;
    return false;
  }

  Future<bool?> deleteAccount() async {
    isLoading.value = true;
    try {
      await supabase
          .schema(ApiConst.coreshema)
          .from("profiles")
          .update({
            "role_id": 2,
            "account_delete": true,
            "deleted_at": DateTime.now().toIso8601String(),
          })
          .eq('id', uuid.toString())
          .select("*");
      isLoading.value = false;
      Get.snackbar("Account Deleted", "Successfully account deleted");
      getProfiles();
      return true;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("$e, $stackTrace");
      }
      isLoading.value = false;
    }
    return false;
  }

  Future<bool?> restoreAccount() async {
    isLoading.value = true;
    try {
      await supabase
          .schema(ApiConst.coreshema)
          .from("profiles")
          .update({"role_id": 2, "account_delete": null, "deleted_at": null})
          .eq('id', uuid.toString())
          .select("*");
      isLoading.value = false;
      Get.snackbar("Account Restored", "successfully account restored");
      getProfiles();
      return true;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("$e, $stackTrace");
      }
      isLoading.value = false;
    }
    return false;
  }
}
