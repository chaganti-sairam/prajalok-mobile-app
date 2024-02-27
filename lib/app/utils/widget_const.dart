import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:prajalok/app/utils/icons_const.dart';
import 'package:prajalok/app/utils/widgetButton.dart';

class ReusableGradientButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color? color;
  final Gradient? gradient;
  final EdgeInsets? padding;
  final ShapeBorder? shape;
  final double? width;
  final double? height;
  const ReusableGradientButton(
      {super.key, required this.child, this.onPressed, this.color, this.padding, this.shape, this.gradient, this.width, this.height});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(12),
        // boxShadow: const [
        //   BoxShadow(
        //     color: Color(0xFF000000),
        //     blurRadius: 0,
        //     offset: Offset(0, 2),
        //     spreadRadius: 0,
        //   )
        // ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: Colors.transparent,
          primary: Colors.transparent,
          onSurface: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}

class ReusableGradienOutlinedtButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color? color;
  final Gradient? gradient;
  final EdgeInsets? padding;
  final ShapeBorder? shape;
  final double? width;
  final double? height;
  const ReusableGradienOutlinedtButton(
      {super.key, required this.child, this.onPressed, this.color, this.padding, this.shape, this.gradient, this.width, this.height});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(gradient: gradient, borderRadius: BorderRadius.circular(12)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          margin: const EdgeInsets.all(2),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              side: const BorderSide(
                color: AppColors.textcolor,
                width: 2.0,
                style: BorderStyle.solid,
              ),
              //  backgroundColor: Colors.transparent,
            ),
            onPressed: onPressed,
            child: child,
          ),
        ),
      ),

      //      OutlinedButton(
      //       style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.transparent), backgroundColor: Colors.transparent),
      //       onPressed: onPressed,
      //       child: child,
      //     ),
      //   ),
      // ),
    );
  }
}

const buttonTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 16,
  fontFamily: 'Open Sans',
  fontWeight: FontWeight.w600,
);
const colorbuttonTextStyle = TextStyle(
  color: AppColors.textcolor,
  fontSize: 16,
  fontFamily: 'Open Sans',
  fontWeight: FontWeight.w600,
);

// TextStyle createCustomTextStyle({
//   Color color = AppColors.textcolor,
//   double fontSize = 16,
//   Decoration? textDecoration,
//   FontWeight fontWeight = FontWeight.w600,
// }) {
//   return TextStyle(
//     color: color,
//     fontSize: fontSize,
//     fontFamily: 'Open Sans',
//     fontWeight: fontWeight,
//     decoration: textDecoration,
//     fontStyle: FontStyle.normal,
//     // etc.
//   );
// }

TextStyle createCustomTextStyle({
  Color color = Colors.black, // You can change this to your default color
  double fontSize = 16,
  TextDecoration? textDecoration,
  FontWeight fontWeight = FontWeight.w600,
}) {
  return TextStyle(
    color: color,
    fontSize: fontSize,
    fontFamily: 'Open Sans',
    fontWeight: fontWeight,
    decoration: textDecoration,
    fontStyle: FontStyle.normal,
    // etc.
  );
}

Widget appBar() {
  return AppBar(
    elevation: 0,
    leading: IconButton(
      onPressed: () {
        Get.back();
      },
      icon: const Icon(
        Icons.arrow_back,
        color: Colors.black,
      ),
    ),
    actions: [
      Image.asset(
        ImagesColletions.logo,
        width: 100,
        height: 30.47,
      ),
      const SizedBox(
        width: 20,
      ),
    ],
    backgroundColor: Colors.transparent,
  );
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Function()? onLeadingPressed;
  final Function()? onActionPressed;
  // final IconButton? leading;
  final Widget? actionIcon;

  const CustomAppBar({Key? key, required this.title, this.onLeadingPressed, this.onActionPressed, this.actionIcon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFF8F8F8),
      elevation: 0,
      leading: IconButton(
        onPressed: onLeadingPressed ?? () => Navigator.of(context).pop(),
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.black54,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontFamily: 'Open Sans',
          fontSize: 18,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: IconButton(
            onPressed: onActionPressed ?? () {},
            icon: actionIcon ?? SizedBox.shrink(),
          ),
        ),
        //SvgPicture.asset(SvgIcons.recentlyicons)
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class UploadInstructions extends StatelessWidget {
  final String title;
  final List<String> instructions;
  const UploadInstructions({
    Key? key,
    required this.title,
    required this.instructions,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 0),
          child: SizedBox(
            width: 390,
            child: Text(
              title,
              style: GoogleFonts.openSans(
                color: AppColors.blacktxtColor,
                fontSize: 14,
                // fontFamily: 'Open Sans',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        //const SizedBox(height: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildInstructions(),
        ),
      ],
    );
  }

  List<Widget> _buildInstructions() {
    return instructions.map((instruction) {
      return Padding(
        padding: const EdgeInsets.all(2),
        child: Text(
          "•   $instruction",
          style: GoogleFonts.openSans(
            color: AppColors.closeIconColor,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }).toList();
  }
}

//?? Custome BottomSheet Re-usable

class CustomBottomSheet extends StatelessWidget {
  final Function() onFilePickerTap;
  final Function() onCameraTap;
  final Function() onScannerTap;
  const CustomBottomSheet({
    required this.onFilePickerTap,
    required this.onCameraTap,
    required this.onScannerTap,
  });
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      color: Colors.white,
      height: screenHeight * 0.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 17, bottom: 30, left: 16, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Choose to upload file',
                  style: TextStyle(
                    color: Color(0xFF2B2B2B),
                    fontSize: 18,
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: SvgPicture.asset(
                      width: 24,
                      height: 24,
                      SvgIcons.crossIcons,
                      color: AppColors.textcolor,
                    )),
              ],
            ),
          ),
          WidgetButtonPress(
            child: InkWell(
              onTap: onCameraTap,
              child: Row(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    width: 48,
                    height: 48,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: const Color(0xFFFDF0DF),
                    ),
                    child: SvgPicture.asset(
                      SvgIcons.filledCameraSvg,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    'Camera',
                    style: TextStyle(
                      color: Color(0xFF404040),
                      fontSize: 16,
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          WidgetButtonPress(
            child: InkWell(
              onTap: onScannerTap,
              child: Row(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    width: 48,
                    height: 48,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: const Color(0xFFFDF0DF),
                    ),
                    child: SvgPicture.asset(
                      SvgIcons.gallrySvgIcon,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    'Gallery',
                    style: TextStyle(
                      color: Color(0xFF404040),
                      fontSize: 16,
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          WidgetButtonPress(
            child: InkWell(
              onTap: onFilePickerTap,
              child: Row(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    width: 48,
                    height: 48,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: const Color(0xFFFDF0DF),
                    ),
                    child: SvgPicture.asset(
                      SvgIcons.documentFilledSvg,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    'File amanger',
                    style: TextStyle(
                      color: Color(0xFF404040),
                      fontSize: 16,
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
