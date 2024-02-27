import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_svg/svg.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:get/get.dart';
import 'package:prajalok/app/utils/icons_const.dart';
import 'package:prajalok/app/utils/widget_const.dart';

class FileUploadSection extends StatelessWidget {
  final VoidCallback onFilePickerTap;
  final VoidCallback onCameraTap;
  final VoidCallback onScannerTap;
  final int files;
  final int maxFiles;
  const FileUploadSection({
    Key? key,
    required this.onFilePickerTap,
    required this.onCameraTap,
    required this.onScannerTap,
    required this.files,
    required this.maxFiles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 125,
      width: Get.width,
      child: DottedBorder(
        strokeCap: StrokeCap.square,
        radius: const Radius.circular(12),
        dashPattern: const [10, 8],
        borderType: BorderType.RRect,
        color: AppColors.textcolor,
        strokeWidth: 1.5,
        child: ReusableGradientButton(
          onPressed: () {
            if (files == maxFiles) {
              Get.snackbar(
                icon: SvgPicture.asset(SvgIcons.snakbarInfo),
                "Info",
                "The maximum limit has been reached you can modify your files by removing one",
              );
            } else {
              Get.bottomSheet(
                CustomBottomSheet(
                  onFilePickerTap: onFilePickerTap,
                  onCameraTap: onCameraTap,
                  onScannerTap: onScannerTap,
                ),
              );
            }
          },
          child: const Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Icon(
                    Icons.add_circle_outline_outlined,
                    size: 30,
                    color: AppColors.textcolor,
                  ),
                ),
                Text(
                  "Upload Files (s)",
                  style: TextStyle(fontSize: 14, color: AppColors.textcolor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
