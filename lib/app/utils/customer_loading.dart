import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:prajalok/app/utils/icons_const.dart';
import 'widget_const.dart';

class ReusableProcessingDialog extends StatelessWidget {
  const ReusableProcessingDialog({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: SizedBox(
        height: 298,
        width: 350,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: Lottie.asset(
                AnimatedJson.loadingAnimation, // Replace with your animation path
                width: 120,
                height: 120,
                animate: true,
                alignment: Alignment.topCenter,
                fit: BoxFit.fill,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 24),
              child: Text(
                'Just a moment !',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textcolor,
                  fontSize: 18,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.18,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                'We are processing your query',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.blacktxtColor,
                  fontSize: 14,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.14,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

//?? File ChecKing Re-Usable Dilog Box   Using Getx

class FileCheckingDialog extends StatelessWidget {
  final String? filePath;
  final bool? isPageLimit;
  final bool? isEnglish;
  final bool? isLegal;
  final bool? isReadable;
  final int? length;
  const FileCheckingDialog({
    Key? key,
    this.filePath,
    this.isPageLimit,
    this.isEnglish,
    this.isLegal,
    this.isReadable,
    this.length,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: SizedBox(
          width: 350,
          height: 298,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: AppColors.textcolor,
                child: Text(
                  "${length ?? 0}/1",
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  "Analyzing File",
                ),
              ),
              SizedBox(
                height: 40,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xFFFFEDEA),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 2),
                      SvgPicture.asset(
                        getFileIconPath(filePath!),
                        height: 20,
                        width: 20,
                        fit: BoxFit.fill,
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          filePath?.replaceAll("/data/user/0/com.example.prajalok/cache/file_picker/", "") ?? "",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildRow(isPageLimit, "Less than 40 pages"),
              const SizedBox(height: 12),
              _buildRow(isEnglish, "Language is in English"),
              const SizedBox(height: 10),
              _buildRow(isReadable, "Document is readable"),
              const SizedBox(height: 10),
              _buildRow(isLegal, "Document is legal"),
              const SizedBox(height: 10),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildRow(bool? res, String text) {
    return StatefulBuilder(builder: (context, setState) {
      return Row(
        children: [
          SizedBox(
            height: 24,
            width: 24,
            child: res == null
                ? CircularProgressIndicator(strokeWidth: 3, backgroundColor: AppColors.invalidColor)
                : res != true
                    ? SvgPicture.asset(SvgIcons.cllosedFilled)
                    : SvgPicture.asset(SvgIcons.chekboxfilled),
          ),
          const SizedBox(width: 20),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF505050),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'Open Sans',
            ),
          ),
        ],
      );
    });
  }
}

String getFileIconPath(String filePath) {
  String extension = filePath.split('.').last.toLowerCase();

  switch (extension) {
    case 'pdf':
      return SvgIcons.pdfIcons;
    case 'jpg':
      return SvgIcons.jpgIcons;
    case 'docs':
      return SvgIcons.docsIcons;
    case 'csv':
      return SvgIcons.csvIcons;
    case 'png':
      return SvgIcons.pngIcons;
    case 'docx':
      return SvgIcons.docsIcons;

    default:
      return SvgIcons.pdfIcons;
  }
}

// get Credit Re-usable Dilog Box
class GetCreditCustomDialog {
  static void showConfirmationDialog({
    required BuildContext context,
    required Function()? onPressed,
    required int res,
    // required String title,
    required String subtitle,
    required String message,
    required String buttonText,
  }) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: SizedBox(
          width: 350,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "1",
                    style: TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Open Sans',
                      color: AppColors.textcolor,
                    ),
                  ),
                  Text(
                    "/$res",
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF808080),
                    ),
                  ),
                ],
              ),
              Text(
                'available',
                style: TextStyle(
                  color: AppColors.greenColor,
                  fontSize: 18,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFF808080),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 4),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color(0xFF808080),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ReusableGradienOutlinedtButton(
                      gradient: AppColors.linearGradient,
                      onPressed: () {
                        Get.back();
                      },
                      height: 32,
                      width: 110,
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: AppColors.textcolor,
                          fontSize: 14,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ReusableGradientButton(
                      gradient: AppColors.linearGradient,
                      height: 32,
                      width: 110,
                      onPressed: onPressed,
                      child: Text(buttonText,
                          // "Continue",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class WebSoketDilog extends StatelessWidget {
  final String? label;
  final String? description;
  final bool? status;

  const WebSoketDilog({super.key, required this.label, required this.description, required this.status});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: status == null
                ? const SizedBox.shrink()
                : status == false
                    ? const SizedBox(
                        width: 21,
                        height: 21,
                        child: CircularProgressIndicator(
                          color: AppColors.textcolor,
                          strokeWidth: 3,
                        ),
                      )
                    : SvgPicture.asset(
                        SvgIcons.chekboxfilled,
                        fit: BoxFit.cover,
                        height: 33,
                        width: 3,
                      ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                SizedBox(
                  width: 234,
                  child: Text(
                    label ?? "",
                    style: const TextStyle(
                      color: Color(0xFF404040),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: 234,
                  child: Text(
                    description ?? "",
                    style: const TextStyle(
                      color: Color(0xFF808080),
                      fontSize: 12,
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
