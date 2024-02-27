import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:prajalok/app/modules/document_writer/controllers/document_write_controller.dart';
import 'package:prajalok/app/utils/api_const.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:prajalok/app/utils/icons_const.dart';
import 'package:prajalok/app/utils/widget_const.dart';
import '../../../data/serlization/doc_generation_model.dart';
import '../../../utils/customer_loading.dart';
import 'package:url_launcher/url_launcher.dart';

class GeneratedDocument extends StatelessWidget {
  final int profileId;
  GeneratedDocument({super.key, required this.profileId});
  final controller = Get.put(DocumentWriteController());
  final docGenerationModel = <DocGenerationModel>[].obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Generated document",
        onLeadingPressed: () {
          Get.back();
        },
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: StreamBuilder(
              stream: supabase.schema(ApiConst.documentwriter).from("doc_generations").stream(primaryKey: ["id"]).eq("id", profileId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(
                      child: Text(
                    'No activity',
                    style: TextStyle(
                      color: Color(0xFFFF5C40),
                      fontSize: 20,
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.w600,
                    ),
                  ));
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'error',
                      style: TextStyle(
                        color: Color(0xFFFF5C40),
                        fontSize: 20,
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }

                final res = snapshot.data as List;
                docGenerationModel.value = res.map((e) => DocGenerationModel.fromJson(e)).toList(growable: false);

                return Obx(() {
                  if (docGenerationModel.isEmpty) {
                    return const ReusableProcessingDialog();
                  } else if (docGenerationModel.first.status == "processing") {
                    return const Text("Document is Not Generated Under processing...");
                  } else {
                    return Column(
                      children: [
                        Container(
                            height: 56,
                            width: 358,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDBEEE7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 300,
                                  child: Text(
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textWidthBasis: TextWidthBasis.longestLine,
                                    docGenerationModel.first.title.toString(),
                                    style: const TextStyle(
                                      color: Color(0xFF1D976C),
                                      fontSize: 16,
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Lottie.asset(
                            width: double.infinity,
                            height: 300,
                            fit: BoxFit.fill,
                            AnimatedJson.swipeIcons,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20, bottom: 0),
                          width: 358,
                          height: 140,
                          decoration: BoxDecoration(
                            gradient: AppColors.gradientOppcityColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              docGenerationModel.isNotEmpty
                                  ? SvgPicture.asset(
                                      getFileIconPath(docGenerationModel[0].finalDocUrl.toString()),
                                      height: 64,
                                      width: 64,
                                      fit: BoxFit.fill,
                                    )
                                  : const SizedBox(),
                              const SizedBox(height: 10),
                              Text(
                                "${docGenerationModel[0].finalDocUrl}".replaceAll(
                                  "https://storage.googleapis.com/ld_user_bucket/templates/doc_generations/",
                                  "",
                                ),
                                style: const TextStyle(
                                  color: Color(0xFF505050),
                                  fontSize: 14,
                                  fontFamily: 'open-sans',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 163,
                                height: 38,
                                child: ReusableGradienOutlinedtButton(
                                  gradient: AppColors.linearGradient,
                                  onPressed: () async {
                                    try {
                                      print("urlllllll ${docGenerationModel.first.finalDocUrl}");
                                      await launchUrl(Uri.parse(docGenerationModel.first.finalDocUrl ?? ""));
                                    } catch (e) {
                                      throw Exception('Could not launch ');
                                    }
                                  },
                                  child: const Text(
                                    'View',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.textcolor,
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              ReusableGradientButton(
                                width: 150,
                                height: 38,
                                gradient: AppColors.linearGradient,
                                onPressed: () async {
                                  try {
                                    await launchUrl(Uri.parse(controller.docGeneratedModel.first.finalDocUrl ?? ""));
                                  } catch (e) {
                                    throw Exception('Could not launch ');
                                  }
                                  //   controller.download(controller.docGeneratedModel.first.finalDocUrl.toString());
                                },
                                child: const Text("Download", style: buttonTextStyle),
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  }
                });
              }),
        ),
      ),
    );
  }
}
