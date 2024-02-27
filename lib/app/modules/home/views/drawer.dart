import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:prajalok/app/modules/profile/views/notifcation_view.dart';
import 'package:prajalok/app/routes/app_pages.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:prajalok/app/utils/compnent/cache_image.dart';
import 'package:prajalok/app/utils/compnent/custome_alert.dart';
import 'package:prajalok/app/utils/customeSnackbar.dart';
import 'package:prajalok/app/utils/icons_const.dart';
import 'package:prajalok/app/utils/widget_const.dart';
import '../../login/controllers/login_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../profile/views/countdown_timer.dart';
import '../../profile/views/invoice.dart';
import '../../profile/views/update_profile.dart';
import '../controllers/home_controller.dart';

TextStyle style = const TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  color: AppColors.blacktxtColor,
);

class DrawerPage extends StatelessWidget {
  DrawerPage({super.key});
  final profileC = Get.put(ProfileController());
  final homeC = Get.put(HomeController());
  final verifyC = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 180,
            child: DrawerHeader(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                child: Obx(() {
                  if (profileC.profileModel.isEmpty) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: AppColors.textcolor,
                    ));
                  }
                  return ListView.builder(
                      itemCount: profileC.profileModel.length,
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                CachedImage(
                                  imageUrl: profileC.profileModel[index].avatarUrl.toString(),
                                  size: 80,
                                ),
                                InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () {
                                      Get.to(() => UpdateProfile());
                                    },
                                    child: SvgPicture.asset(SvgIcons.editPenIcons, height: 20, width: 20)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              child: Obx(
                                () => profileC.profileModel.isNotEmpty
                                    ? Text(
                                        "${profileC.profileModel[index].firstName ?? ""} ${profileC.profileModel[index].lastName ?? ""} ",
                                        style: createCustomTextStyle(
                                          color: AppColors.blacktxtColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20,
                                        ),
                                      )
                                    : Text(
                                        "Loading...",
                                        style: createCustomTextStyle(
                                          color: AppColors.blacktxtColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              profileC.profileModel[index].emailId ?? "No Email",
                              style: createCustomTextStyle(
                                color: AppColors.blacktxtColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ), // const Text(
                            const SizedBox(height: 6),
                            Row(
                              children: <Widget>[
                                SvgPicture.asset(
                                  SvgIcons.locationsIons,
                                  color: AppColors.invalidColor,
                                  height: 20,
                                  width: 20,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  profileC.profileModel[index].location?[0].toString() ?? "no location",
                                  style: style,
                                ),
                              ],
                            )
                          ],
                        );
                      });
                })),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            titleTextStyle: style,
            minLeadingWidth: 0,
            leading: SvgPicture.asset(
              SvgIcons.notificationIcons,
              height: 20,
              width: 20,
              fit: BoxFit.cover,
            ),
            title: const Text('Notifications'),
            onTap: () {
              Get.to(() => NotifcationView());
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            titleTextStyle: style,
            minLeadingWidth: 0,
            leading: SvgPicture.asset(
              SvgIcons.languageIcons,
              height: 20,
              width: 20,
              fit: BoxFit.cover,
            ),
            title: const Text('Languages'),
            onTap: () {},
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            titleTextStyle: style,
            minLeadingWidth: 0,
            leading: SvgPicture.asset(
              SvgIcons.invoiceIcons,
              height: 20,
              width: 20,
              fit: BoxFit.cover,
            ),
            title: const Text('Invoices'),
            onTap: () {
              Get.to(() => Invoice());
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            titleTextStyle: style,
            minLeadingWidth: 0,
            leading: SvgPicture.asset(
              SvgIcons.leagalTermsIcons,
              height: 20,
              width: 20,
              fit: BoxFit.cover,
            ),
            title: const Text('Legal terms'),
            onTap: () {},
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            titleTextStyle: style,
            minLeadingWidth: 0,
            leading: SvgPicture.asset(
              SvgIcons.supportIcons,
              height: 20,
              width: 20,
              fit: BoxFit.cover,
            ),
            title: const Text('Support'),
            onTap: () {},
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            titleTextStyle: style,
            minLeadingWidth: 0,
            leading: SvgPicture.asset(
              SvgIcons.logoutIcons,
              height: 20,
              width: 20,
              fit: BoxFit.cover,
            ),
            title: const Text('Sign out'),
            onTap: () async {
              Get.dialog(
                CustomAlertDialog(
                  visible: false,
                  title: 'you want to sign out?',
                  message: "We'll miss having you around! Can't wait for you to join us again.",
                  onNoPressed: () {
                    Get.back(canPop: true, closeOverlays: false);
                  },
                  onYesPressed: () async {
                    await verifyC.logout().then((value) async {
                      CustomSnackBar.snakbarInfo(title: "Sign out", message: "Sign out successfully");
                      await verifyC.resetTimer();
                      Get.offAllNamed(Routes.ONBOARDING);
                    });
                  },
                ),
              );
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            titleTextStyle: style,
            minLeadingWidth: 0,
            leading: SvgPicture.asset(
              SvgIcons.trashSvgIcons,
              height: 20,
              width: 20,
              color: AppColors.invalidColor,
              fit: BoxFit.cover,
            ),
            title: Text(
              'Delete account',
              style: TextStyle(color: AppColors.invalidColor),
            ),
            onTap: () {
              Get.dialog(
                CustomAlertDialog(
                  visible: true,
                  title: 'Deleting account \n is irreversible.',
                  message: "Are you sure you want to proceed?",
                  onNoPressed: () {
                    Get.back(canPop: true, closeOverlays: false);
                  },
                  onYesPressed: () async {
                    Get.back(canPop: true, closeOverlays: false);

                    Get.bottomSheet(
                      isScrollControlled: true,
                      buildBottomSheet(),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

Widget buildBottomSheet() {
  final profileC = Get.put(ProfileController());

  return Container(
    padding: const EdgeInsets.only(left: 16, right: 24, top: 20, bottom: 20),
    height: Get.height * 0.6,
    color: Colors.white,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "We're sorry to see you go!",
          style: createCustomTextStyle(
            color: AppColors.textcolor,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 16),
        Text("Your insights matter and will help us enhance our services for others.",
            style: createCustomTextStyle(
              color: AppColors.blacktxtColor,
              fontWeight: FontWeight.w400,
              fontSize: 16,
            )),
        const SizedBox(height: 16),
        TextFormField(
          maxLines: 6,
          focusNode: FocusScopeNode(),
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                style: BorderStyle.solid,
                color: AppColors.searchLawAppBarColors,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            hintText: "Would you mind sharing why you're choosing to delete your account?",
            hintStyle: createCustomTextStyle(
              color: AppColors.searchLawAppBarColors,
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(
                style: BorderStyle.solid,
                color: AppColors.blacktxtColor,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.stausYellowHalfColor,
          ),
          child: Text(
            "In 30 working days, your account will be deleted. But don't worry, you can still restore it if you change your mind.",
            textAlign: TextAlign.justify,
            style: createCustomTextStyle(
              color: AppColors.blacktxtColor,
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          ),
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ReusableGradienOutlinedtButton(
              width: 171,
              height: 45,
              onPressed: () {
                Get.back();
              },
              child: Text(
                'Not, interested',
                style: createCustomTextStyle(color: AppColors.textcolor),
              ),
            ),
            Obx(() {
              return ReusableGradientButton(
                width: 171,
                height: 45,
                gradient: AppColors.linearGradient,
                onPressed: () async {
                  if (profileC.isLoading.isFalse) {
                    bool? result = await profileC.deleteAccount();
                    if (result != null && result == true) {
                      Get.offAll(CountdownTimer());
                    }
                  }
                },
                child: profileC.isLoading.isFalse
                    ? Text(
                        'Done',
                        style: createCustomTextStyle(color: Colors.white),
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
              );
            }),
          ],
        ),
      ],
    ),
  );
}
