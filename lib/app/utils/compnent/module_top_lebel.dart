import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prajalok/app/utils/color_const.dart';

Widget buildTopBar(String svgIcons, String colorText, String noneColorText) {
  return Padding(
    padding: const EdgeInsets.only(top: 0, bottom: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 40,
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: AppColors.gradientOppcityColor,
          ),
          child: SvgPicture.asset(
            svgIcons,
            fit: BoxFit.cover,
            height: 24,
            width: 24,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Wrap(
            alignment: WrapAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: colorText,
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textcolor,
                      ),
                    ),
                    const WidgetSpan(
                      child: SizedBox(width: 8),
                    ),
                    TextSpan(
                      text: noneColorText,
                      style: GoogleFonts.openSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppColors.blacktxtColor,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    ),
  );
}
