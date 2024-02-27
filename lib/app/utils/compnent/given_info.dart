import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:prajalok/app/utils/customer_loading.dart';
import 'package:url_launcher/url_launcher.dart';

void GivenInputInfoSheet(context, List<dynamic> list, bool isdocurl, bool isinputdocurl) {
  showGeneralDialog(
    context: context,
    barrierColor: Colors.black54,
    barrierDismissible: true,
    barrierLabel: 'Label',
    pageBuilder: (_, __, ___) {
      return Align(
        alignment: Alignment.centerRight,
        child: SafeArea(
          child: Material(
            child: SizedBox(
              width: 300,
              height: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  children: [
                    AppBar(
                      titleSpacing: 0,
                      automaticallyImplyLeading: false,
                      elevation: 0.5,
                      title: const Text(
                        'Given information',
                        style: TextStyle(
                          color: AppColors.textcolor,
                          fontSize: 16,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Uploaded case files",
                        style: TextStyle(
                          color: AppColors.blacktxtColor,
                          fontSize: 16,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Expanded(
                      child: list.isEmpty
                          ? const CircularProgressIndicator(color: AppColors.textcolor)
                          : ListView.builder(
                              itemCount: list.length,
                              itemBuilder: (BuildContext context, int i) {
                                if (isdocurl == true) {
                                  return TextButton.icon(
                                    onPressed: () async {
                                      try {
                                        await launchUrl(Uri.parse(isinputdocurl == true ? list[i].inputDocUrl : list[i].docUrl));
                                      } catch (e) {
                                        throw Exception('Could not launch');
                                      }
                                    },
                                    icon: SvgPicture.asset(
                                      getFileIconPath(isinputdocurl == true ? list[i].inputDocUrl : list[i].docUrl),
                                      height: 21.6,
                                      width: 16.68,
                                      fit: BoxFit.fill,
                                    ),
                                    label: Text(
                                      isinputdocurl == true ? list[i].inputDocUrl : list[i].docUrl,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                      textAlign: TextAlign.center,
                                      textDirection: TextDirection.ltr,
                                      textScaleFactor: 1.0,
                                      textWidthBasis: TextWidthBasis.parent,
                                      textHeightBehavior: const TextHeightBehavior(applyHeightToFirstAscent: false),
                                      style: const TextStyle(color: AppColors.blacktxtColor),
                                    ),
                                  );
                                } else {
                                  return Column(
                                    children: List.generate(list[i].docUrls.length, (index) {
                                      return TextButton.icon(
                                        onPressed: () async {
                                          try {
                                            await launchUrl(Uri.parse(list[i].docUrls[index].toString()));
                                          } catch (e) {
                                            throw Exception('Could not launch');
                                          }
                                        },
                                        icon: SvgPicture.asset(
                                          getFileIconPath(list[i].docUrls[index].toString()),
                                          height: 21.6,
                                          width: 16.68,
                                          fit: BoxFit.fill,
                                        ),
                                        label: Text(
                                          list[i].docUrls[index].toString(),
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                          textAlign: TextAlign.center,
                                          textDirection: TextDirection.ltr,
                                          textScaleFactor: 1.0,
                                          textWidthBasis: TextWidthBasis.parent,
                                          textHeightBehavior: const TextHeightBehavior(applyHeightToFirstAscent: false),
                                          style: const TextStyle(color: AppColors.blacktxtColor),
                                        ),
                                      );
                                    }),
                                  );
                                }
                              }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
