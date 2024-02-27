import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:prajalok/app/modules/analysis/views/analysis_view.dart';
import 'package:prajalok/app/modules/document_analyser/views/document_analysis_view.dart';
import 'package:prajalok/app/modules/profile/controllers/profile_controller.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:prajalok/app/utils/compnent/cache_image.dart';
import 'package:prajalok/app/utils/compnent/get_credit.dart';
import 'package:prajalok/app/utils/icons_const.dart';
import 'package:prajalok/app/utils/widgetButton.dart';
import 'package:prajalok/app/utils/widget_const.dart';
import '../../chats/views/chat_user_list.dart';
import '../../contract_Analysis/views/contract_analysis_view.dart';
import '../../document_chat/views/document_chat_view.dart';
import '../../document_transalator/views/document_transalator_view.dart';
import '../../document_writer/views/document_write_view.dart';
import '../../legalIssueSpotter/views/legal_issue_spotter_view.dart';
import '../../login/controllers/login_controller.dart';
import '../../searchlaw/views/searchlaw_view.dart';
import '../controllers/home_controller.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

import 'drawer.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});
  HomeController homeC = Get.put(HomeController(), permanent: false);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: homeC.pageController,
        onPageChanged: (index) {
          homeC.SetSatate(index);
        },
        children: [
          HomePageScreen(),
          Container(color: Colors.green, child: const Center(child: Text('My Enquires '))),
          ChatUserList(),
          Container(color: Colors.red, child: const Center(child: Text('myScases Page'))),
        ],
      ),
      bottomNavigationBar: Container(
        height: size.width * .200,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.15),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
          borderRadius: BorderRadius.circular(5),
        ),
        child: ListView.builder(
          itemCount: 4,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: size.width * .030),
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              homeC.SetSatate(index);
              homeC.pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease,
              );
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => AnimatedContainer(
                      duration: const Duration(milliseconds: 1500),
                      curve: Curves.fastLinearToSlowEaseIn,
                      margin: EdgeInsets.only(
                        bottom: index == homeC.currentIndex.value ? 0 : size.width * .029,
                        right: size.width * .0422,
                        left: size.width * .0422,
                      ),
                      width: size.width * .150,
                      height: index == homeC.currentIndex.value ? size.width * .014 : 0,
                      decoration: const BoxDecoration(
                        color: AppColors.textcolor, // Change color according to your theme
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(10),
                        ),
                      ),
                    )),
                Obx(() => Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: index == homeC.currentIndex.value ? AppColors.textcolor : null, // Change color according to your theme
                      ),
                      padding: const EdgeInsets.all(5),
                      child: SvgPicture.asset(
                        width: size.width * .24,
                        height: size.width * .24,
                        fit: BoxFit.cover,
                        color: index == homeC.currentIndex.value ? Colors.white : AppColors.closeIconColor,
                        listOfIcons[index],
                      ),
                    )),
                Obx(() => Text(
                      getTitle(index),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.openSans(
                        // fontFamily: "Open Sans",
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: index == homeC.currentIndex.value ? AppColors.textcolor : AppColors.closeIconColor,
                      ),
                    )),
                SizedBox(height: size.width * .02),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<String> listOfIcons = [SvgIcons.homeIcons, SvgIcons.editIconsSvg, SvgIcons.chatregularsvg, SvgIcons.documentSvg];
  String getTitle(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'My enquries';
      case 2:
        return 'Chats';
      case 3:
        return 'My cases';
      default:
        return '';
    }
  }
}

// ignore: must_be_immutable
class HomePageScreen extends StatelessWidget {
  HomePageScreen({super.key});
  HomeController controller = Get.put(HomeController());
  final profileC = Get.put(ProfileController());
  final verifyC = Get.put(LoginController());
  final _advancedDrawerController = AdvancedDrawerController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AdvancedDrawer(
        // backdrop: Container(
        //   width: 200,
        //   height: double.infinity,
        //   decoration: BoxDecoration(
        //     gradient: LinearGradient(
        //       begin: Alignment.topLeft,
        //       end: Alignment.bottomRight,
        //       colors: [Colors.blueGrey, Colors.blueGrey.withOpacity(0.2)],
        //     ),
        //   ),
        // ),
        controller: _advancedDrawerController,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        animateChildDecoration: true,
        rtlOpening: false,
        // openScale: 1.0,
        disabledGestures: false,
        childDecoration: const BoxDecoration(
          // NOTICE: Uncomment if you want to add shadow behind the page.
          // Keep in mind that it may cause animation jerks.
          // boxShadow: <BoxShadow>[
          //   BoxShadow(
          //     color: Colors.black12,
          //     blurRadius: 0.0,
          //   ),
          // ],
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        drawer: Drawer(
            width: 281,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: DrawerPage(),
            )),

        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0.0,
              titleSpacing: 15.0,
              title: Row(
                children: <Widget>[
                  // IconButton(
                  //   onPressed: () {
                  //     _advancedDrawerController.showDrawer();
                  //   },
                  //   icon: ValueListenableBuilder<AdvancedDrawerValue>(
                  //     valueListenable: _advancedDrawerController,
                  //     builder: (_, value, __) {
                  //       return AnimatedSwitcher(
                  //         duration: Duration(milliseconds: 250),
                  //         child: Icon(
                  //           value.visible ? Icons.clear : Icons.menu,
                  //           key: ValueKey<bool>(value.visible),
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                  Obx(() {
                    return GestureDetector(
                      onTap: () {
                        _advancedDrawerController.showDrawer();
                      },
                      child: profileC.profileModel.isEmpty
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: AppColors.textcolor,
                              ),
                            )
                          : CachedImage(
                              imageUrl: "${profileC.profileModel[0].avatarUrl}",
                              size: 40,
                            ),
                    );
                  })
                ],
              ),

              //Image.asset(ImagesColletions.logo, width: 72, height: 20.94),
              actions: [
                // GestureDetector(
                //   onTap: () async {
                //     await verifyC.logout();
                //     await verifyC.resetTimer();
                //     Get.offAllNamed(Routes.LOGIN);
                //   },
                //   child: const CircleAvatar(
                //     backgroundImage: NetworkImage(
                //         "https://images.unsplash.com/photo-1702838834569-bf20a161824c?q=80&w=1602&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
                //   ),
                // ),
                const SizedBox(
                  width: 15,
                ),
                IconButton(
                  splashRadius: 20,
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications,
                    color: Colors.black45,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    child: Obx(
                      () => profileC.profileModel.isNotEmpty
                          ? Text(
                              "Hello! ${profileC.profileModel.first.firstName ?? "null"}",
                              style: GoogleFonts.openSans(
                                color: AppColors.chatRecivedTextCollor,
                                fontSize: 18,
                                // fontFamily: 'Open Sans',
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          : const Text(
                              "Loading...",
                              style: TextStyle(
                                color: Color(0xFF505050),
                                fontSize: 18,
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                    ),
                  ),
                  // const SizedBox(
                  //   height: 4,
                  // ),
                  SizedBox(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Describe the issue',
                            style: GoogleFonts.openSans(
                              color: AppColors.textcolor,
                              fontSize: 17.5,
                              // fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: " you're dealing with",
                            style: GoogleFonts.openSans(
                              color: AppColors.chatRecivedTextCollor,
                              //Color(0xFF505050),
                              fontSize: 17.5,
                              //fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => AnalysisView());
                    },
                    child: Container(
                        margin: const EdgeInsets.only(
                          top: 12,
                        ),
                        width: Get.width,
                        height: 130,
                        decoration: BoxDecoration(
                            color: Colors.white, border: Border.all(color: AppColors.textcolor, width: 1), borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20, left: 20),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Obx(
                                  () => Text(
                                    (controller.currentIndex.value < controller.strings.length)
                                        ? controller.strings[controller.currentIndex.value].substring(
                                            0,
                                            (controller.currentCharIndex.value < controller.strings[controller.currentIndex.value].length)
                                                ? controller.currentCharIndex.value
                                                : controller.strings[controller.currentIndex.value].length,
                                          )
                                        : '',
                                    style: GoogleFonts.openSans(
                                      color: AppColors.blacktxtColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(right: 10, top: 50),
                                width: 110,
                                height: 32,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: ShapeDecoration(
                                  gradient: AppColors.linearGradient,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  // shadows: const [
                                  //   BoxShadow(
                                  //     color: Color(0xFF000000),
                                  //     offset: Offset(0, 2),
                                  //   )
                                  // ],
                                ),
                                child: Text(
                                  'Solve my Issue',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.openSans(
                                    color: Colors.white,
                                    fontSize: 12,
                                    //fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                  // const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    child: Divider(
                      color: AppColors.searchLawAppBarColors,
                      thickness: 1,
                    ),
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: Get.width,
                          height: 160,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 334,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 12,
                                    top: 10,
                                  ),
                                  child: Text(
                                    'Popular features',
                                    style: GoogleFonts.openSans(
                                      color: AppColors.chatRecivedTextCollor,
                                      fontSize: 16,
                                      //   fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    width: 159,
                                    child: _buildWidgetButton(
                                      svgIcon: SvgIcons.leagalOpennion,
                                      text: "Legal\nopinion",
                                      icon: Icons.north_east_outlined,
                                      onTap: () {
                                        //Get.bottomSheet(BuyCredit());
                                        //  Get.dialog(const ReusableProcessingDialog());
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 159,
                                    child: _buildWidgetButton(
                                      svgIcon: SvgIcons.documentwriter,
                                      text: "Document\nwriter",
                                      icon: Icons.north_east_outlined,
                                      onTap: () {
                                        //  Get.to(() => DocumentWriteView());
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          width: Get.width,
                          padding: EdgeInsets.only(left: 16, right: 0),
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CircleAvatar(
                                radius: 25,
                                child: Lottie.asset(AnimatedJson.maleLawyerjson),
                              ),
                              SizedBox(width: 8), // Add spacing
                              Expanded(
                                flex: 2,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "AI lawyers",
                                      style: GoogleFonts.openSans(
                                        color: AppColors.chatRecivedTextCollor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Engage in conversations ",
                                      style: GoogleFonts.openSans(
                                        color: AppColors.grey44,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8), // Add spacing
                              ReusableGradienOutlinedtButton(
                                width: 110,
                                color: AppColors.textcolor,
                                child: Text(
                                  'Start chat',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.openSans(
                                    color: AppColors.textcolor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        //? Pages list Sections start here
                        const SizedBox(height: 16),
                        Container(
                          height: 140,
                          width: Get.width,
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 334,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 12,
                                    top: 12,
                                  ),
                                  child: Text(
                                    'Documents generations',
                                    style: GoogleFonts.openSans(
                                      color: AppColors.chatRecivedTextCollor,
                                      fontSize: 16,
                                      //   fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    LawLibraryItem(
                                      iconPath: SvgIcons.documentTranslator,
                                      title: 'Document \ntranslator',
                                      onTap: () {
                                        Get.to(() => DocumentTransalatorView());
                                      },
                                    ),
                                    LawLibraryItem(
                                      iconPath: SvgIcons.searchLaw,
                                      title: 'Search \nlaw',
                                      onTap: () {
                                        Get.to(() => SearchlawView());
                                      },
                                    ),
                                    LawLibraryItem(
                                      iconPath: SvgIcons.agreementwriterSvg,
                                      title: 'Agreement \nwriter',
                                      onTap: () {
                                        // Define your action here
                                      },
                                    ),
                                    LawLibraryItem(
                                      iconPath: SvgIcons.quickwriter,
                                      title: 'Quick \nwriter',
                                      onTap: () {
                                        // Define your action here
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        //  ),
                        SizedBox(height: 20),

                        //?? ------------------- DOCUMENT HUB-----------------------------

                        Container(
                          height: 140,
                          width: Get.width,
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 334,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 12,
                                    top: 12,
                                  ),
                                  child: Text(
                                    'Analysis',

                                    style: GoogleFonts.openSans(
                                      color: AppColors.chatRecivedTextCollor,
                                      fontSize: 16,
                                      //   fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.w600,
                                    ),
                                    // style: TextStyle(
                                    //   color: Color(0xFF2B2B2B),
                                    //   fontSize: 16,
                                    //   fontFamily: 'Open Sans',
                                    //   fontWeight: FontWeight.w600,
                                    // ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    LawLibraryItem(
                                      iconPath: SvgIcons.documentAnalyzer,
                                      title: 'Document \nanalysis',
                                      onTap: () {
                                        Get.to(() => DocumentAnalysisView());
                                      },
                                    ),
                                    LawLibraryItem(
                                      iconPath: SvgIcons.leagalissue,
                                      title: 'Legal issue \nspotter',
                                      onTap: () {
                                        Get.to(() => LegalIssueSpotterView());
                                      },
                                    ),
                                    LawLibraryItem(
                                      iconPath: SvgIcons.contractAnalysis,
                                      title: 'Contract \nanalysis',
                                      onTap: () {
                                        Get.to(() => ContractAnalysisView());
                                      },
                                    ),
                                    LawLibraryItem(
                                      iconPath: SvgIcons.documentchat,
                                      title: 'Document \nchat',
                                      onTap: () {
                                        Get.to(() => DocumentChatView());

                                        // Define your action here
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildWidgetButton({required VoidCallback onTap, required String text, required IconData icon, required String svgIcon}) {
  return WidgetButtonPress(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        width: 159,
        height: 128,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
                top: 16,
                left: 20,
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: AppColors.textcolor,
                  child: SvgPicture.asset(
                    svgIcon,
                    color: Colors.white,
                    width: 30,
                    height: 30,
                  ),
                )

                // SvgPicture.asset(
                //   SvgIcons.leagalOpennion,
                //   width: 32,
                //   height: 32,
                // ),
                ),
            Positioned(
              left: 20,
              top: 70,
              child: Text(
                text,
                textAlign: TextAlign.start,
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  //      fontFamily: "Open Sans",
                  fontWeight: FontWeight.w500,
                  color: AppColors.chatRecivedTextCollor,
                ),
              ),
            ),
            Positioned(
              left: 120,
              top: 80,
              child: Icon(
                icon,
                size: 24,
                color: const Color(0xFF606060),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class LawLibraryItem extends StatelessWidget {
  final String iconPath;
  final String title;
  final VoidCallback onTap;

  const LawLibraryItem({
    Key? key,
    required this.iconPath,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WidgetButtonPress(
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: SvgPicture.asset(
                iconPath,
                width: 32,
                height: 32,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: SizedBox(
                width: 80,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                    fontSize: 12,
                    //      fontFamily: "Open Sans",
                    fontWeight: FontWeight.w500,
                    color: AppColors.chatRecivedTextCollor,
                  ),

                  // TextStyle(
                  //   color: AppColors.chatRecivedTextCollor,
                  //   fontSize: 12,
                  //   fontFamily: 'Open Sans',
                  //   fontWeight: FontWeight.w400,
                  // ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
