import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:prajalok/app/utils/icons_const.dart';
import 'package:prajalok/app/utils/widget_const.dart';

class BuyCredit extends StatelessWidget {
  final String moduleName;
  final int price;
  final int usePrice;
  final VoidCallback onPressed;
  const BuyCredit({super.key, required this.moduleName, required this.price, required this.usePrice, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 24, top: 20, bottom: 20),
      height: Get.height * 0.4,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: SvgPicture.asset(
                  SvgIcons.crossIcons,
                  color: AppColors.textcolor,
                )),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Unlock this feature with credits.",
              textAlign: TextAlign.left,
              style: createCustomTextStyle(
                color: AppColors.textcolor,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text("Just tap 'Proceed to Pay' and you're in",
                style: createCustomTextStyle(
                  color: AppColors.blacktxtColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                )),
          ),
          const SizedBox(height: 16),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                style: BorderStyle.solid,
                width: 1,
                color: AppColors.searchLawAppBarColors,
              ),
            ),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: AppColors.stausYellowHalfColor,
                  radius: 32,
                  child: SvgPicture.asset(
                    SvgIcons.maintenance,
                    height: 30,
                    width: 30,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Column(
                  children: [
                    Text(
                      moduleName,
                      // "Document analyser",
                      textAlign: TextAlign.justify,
                      style: createCustomTextStyle(
                        color: AppColors.blacktxtColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    RichText(
                      text: TextSpan(
                        text: '₹$price ',
                        style: createCustomTextStyle(color: AppColors.textcolor, fontSize: 16, fontWeight: FontWeight.w600),
                        children: <TextSpan>[
                          TextSpan(
                              text: '₹$usePrice /Use',
                              style: createCustomTextStyle(
                                textDecoration: TextDecoration.lineThrough,
                                color: AppColors.blacktxtColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              )),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Spacer(),
          ReusableGradientButton(
            gradient: AppColors.linearGradient,
            width: 200,
            height: 45,
            onPressed: onPressed,

            // () {
            //   Get.back();
            // Get.bottomSheet(
            //   enterBottomSheetDuration: const Duration(milliseconds: 250),
            //   ignoreSafeArea: true,
            //   isScrollControlled: true,
            //   const CustomerDetails(),
            // );
            // },

            child: Text(
              'Procced to pay',
              style: createCustomTextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Terms & Conditions',
            style: createCustomTextStyle(color: AppColors.textcolor, fontSize: 14, fontWeight: FontWeight.w400),
          )
        ],
      ),
    );
  }
}

class CustomerDetails extends StatelessWidget {
  const CustomerDetails({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 24, top: 20, bottom: 20),
      height: Get.height * 0.6,
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    size: 24,
                    color: AppColors.textcolor,
                  )),
              const SizedBox(width: 16),
              Text(
                "Customer details",
                textAlign: TextAlign.left,
                style: createCustomTextStyle(
                  color: AppColors.blacktxtColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(
                // padding: EdgeInsets.zero,
                // shrinkWrap: true,
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.textcolor),
                        ),
                        labelStyle: TextStyle(
                          color: AppColors.closeIconColor,
                        ),
                        labelText: 'Full name'),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.textcolor),
                        ),
                        labelStyle: TextStyle(
                          color: AppColors.closeIconColor,
                        ),
                        labelText: 'Email ID'),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.textcolor),
                        ),
                        labelStyle: TextStyle(
                          color: AppColors.closeIconColor,
                        ),
                        labelText: 'Mobile number'),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.textcolor),
                        ),
                        labelStyle: TextStyle(
                          color: AppColors.closeIconColor,
                        ),
                        labelText: 'GSTIN (Optional)'),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.textcolor),
                        ),
                        hintText: "Ex: 5/2/77, Road no 2",
                        labelStyle: TextStyle(
                          color: AppColors.closeIconColor,
                        ),
                        labelText: 'Address'),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: TextFormField(
                          decoration: const InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: AppColors.textcolor),
                              ),
                              labelStyle: TextStyle(
                                color: AppColors.closeIconColor,
                              ),
                              labelText: 'Pincode'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Flexible(
                        child: TextFormField(
                          decoration: const InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: AppColors.textcolor),
                              ),
                              labelStyle: TextStyle(
                                color: AppColors.closeIconColor,
                              ),
                              labelText: 'City/Town'),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: TextFormField(
                          decoration: const InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: AppColors.textcolor),
                              ),
                              labelStyle: TextStyle(
                                color: AppColors.closeIconColor,
                              ),
                              labelText: 'State'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Flexible(
                        child: TextFormField(
                          decoration: const InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: AppColors.textcolor),
                              ),
                              labelStyle: TextStyle(
                                color: AppColors.closeIconColor,
                              ),
                              labelText: 'Country'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ReusableGradienOutlinedtButton(
                width: 120,
                height: 46,
                onPressed: () {},
                child: Text(
                  'Clear all',
                  style: createCustomTextStyle(color: AppColors.textcolor),
                ),
              ),
              const SizedBox(width: 16),
              ReusableGradientButton(
                gradient: AppColors.linearGradient,
                width: 120,
                height: 45,
                onPressed: () {},
                child: Text(
                  'Continue',
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
