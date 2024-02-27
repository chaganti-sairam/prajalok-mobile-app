import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prajalok/app/modules/profile/controllers/profile_controller.dart';
import 'package:prajalok/app/utils/color_const.dart';

final profileC = Get.put(ProfileController());

class Formsteps {
  TextEditingController firstName;
  TextEditingController lastName;
  TextEditingController email;
  TextEditingController location;
  Formsteps({required this.firstName, required this.lastName, required this.email, required this.location});
  List<Widget> getContents() {
    return [
      Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 20, bottom: 80),
            child: SizedBox(
              width: 342,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Let's get to know you. \n",
                      style: TextStyle(
                        color: Color(0xFF2B2B2B),
                        fontSize: 24,
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: "What's your name?",
                      style: TextStyle(
                        color: Color(0xFFFF5C40),
                        fontSize: 24,
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Obx(() {
          //   return

          TextFormField(
            //  focusNode: profileC.focusNode,
            onChanged: (value) {},
            controller: firstName,
            decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.textcolor),
                ),
                labelStyle: TextStyle(
                  color: AppColors.closeIconColor,
                ),
                //profileC.hasFocus.value ? AppColors.textcolor :

                labelText: 'First Name'),
            onTap: () {},
          ),
          // }),
          const SizedBox(
            height: 10,
          ),
          // Obx(() {
          //   return

          TextFormField(
            //     focusNode: profileC.focusNode1,
            onChanged: (value) {},
            controller: lastName,
            decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.textcolor),
                ),
                labelStyle: TextStyle(
                  color: AppColors.closeIconColor,
                ),
                // labelStyle: TextStyle(
                //   color: profileC.hasFocus1.value ? AppColors.textcolor : AppColors.closeIconColor,
                // ),
                labelText: 'Last Name'),
            onTap: () {},
          ),
          //}),
          // TextFormField(
          //   controller: lastName,
          //   decoration: const InputDecoration(labelText: 'Last Name'),
          // ),
        ],
      ),
      Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 20, bottom: 80),
            child: SizedBox(
              width: 342,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "To notify updates, we need\n",
                      style: TextStyle(
                        color: Color(0xFF2B2B2B),
                        fontSize: 24,
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: "Your E-Mail ID?",
                      style: TextStyle(
                        color: Color(0xFFFF5C40),
                        fontSize: 24,
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Obx(() {
          //   return
          TextFormField(
            //   focusNode: profileC.focusNode2,
            controller: email,
            decoration: const InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.textcolor),
              ),
              labelText: 'Email optional',
              labelStyle: TextStyle(
                color: AppColors.closeIconColor,
              ),
              // labelStyle: TextStyle(
              //   color: profileC.hasFocus2.value ? AppColors.textcolor : AppColors.closeIconColor,
            ),
          ),
          //  );
          //  })
        ],
      ),
      Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 20, bottom: 80),
            child: SizedBox(
              width: 342,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "For better service. we need \n",
                      style: TextStyle(
                        color: Color(0xFF2B2B2B),
                        fontSize: 24,
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: "your location ?",
                      style: TextStyle(
                        color: Color(0xFFFF5C40),
                        fontSize: 24,
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          TextFormField(
            controller: location,
            decoration: const InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.textcolor),
              ),
              labelText: 'Location',
              labelStyle: TextStyle(
                color: AppColors.closeIconColor,
              ),
            ),
            onTap: () {
              profileC.requestLocationPermission2();
            },
          ),
        ],
      )
    ];
  }
}
