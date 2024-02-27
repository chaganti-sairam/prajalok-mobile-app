import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:prajalok/app/data/serlization/docWriterAnswerModel.dart';
import 'package:prajalok/app/utils/api_const.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:prajalok/app/utils/widgetButton.dart';
import 'package:prajalok/app/utils/widget_const.dart';
import 'package:r_dotted_line_border/r_dotted_line_border.dart';
import '../controllers/document_write_controller.dart';
import 'doc_writer_first_steps.dart';

class DocWriterStepeps extends StatelessWidget {
  DocWriterStepeps({super.key});
  final documentWriteController = Get.put(DocumentWriteController());
  final List<Widget> listWidget = [
    MyFirstStep(),
    build2ndStepAnswer(),
    build3rdStepReview()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Document Steps',
          style: TextStyle(color: Colors.black45),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black54,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 70,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Obx(() {
                  return ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: documentWriteController.listOfIcons.length,
                    separatorBuilder: (context, index) {
                      return Column(
                        children: [
                          Obx(() {
                            return Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              margin: const EdgeInsets.only(top: 20),
                              width: 100,
                              decoration: BoxDecoration(
                                border: RDottedLineBorder.symmetric(
                                  horizontal: BorderSide(
                                    width: 0,
                                    color: documentWriteController
                                                .currentIndex.value <=
                                            index
                                        ? const Color(0xFF707070)
                                        : AppColors.textcolor,
                                  ),
                                  dottedSpace: 0,
                                ),
                              ),
                            );
                          }),
                        ],
                      );
                    },
                    itemBuilder: (_, i) {
                      return InkWell(
                        // onTap: () {
                        //   documentWriteController.moveToStepersPage();
                        // documentWriteController.changeSateFunc(documentWriteController.currentIndex.value + i);
                        // documentWriteController.pageController.animateToPage(
                        //   i,
                        //   duration: const Duration(milliseconds: 500),
                        //   curve: Curves.ease,
                        // );
                        //},
                        child: SizedBox(
                          child: Column(
                            children: <Widget>[
                              Obx(() {
                                return SvgPicture.asset(
                                  documentWriteController.listOfIcons[i],
                                  fit: BoxFit.cover,
                                  color: documentWriteController
                                              .currentIndex.value <
                                          i
                                      ? null
                                      : AppColors.textcolor,
                                  cacheColorFilter: true,
                                  height: 36,
                                  width: 36,
                                );
                              }),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                // width: 50,
                                child: Obx(
                                  () => Text(
                                    documentWriteController.listOfTitles[i],
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: documentWriteController
                                                  .currentIndex.value <
                                              i
                                          ? const Color(0xFF707070)
                                          : AppColors.textcolor,
                                      fontSize: 12,
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                })),
          ),
          Expanded(
            child: PageView.builder(
              // physics: const NeverScrollableScrollPhysics(),
              allowImplicitScrolling: false,
              padEnds: true,
              reverse: false,
              controller: documentWriteController.pageController,
              onPageChanged: (index) {
                documentWriteController.changeSateFunc(index);
              },
              itemCount: listWidget.length,
              itemBuilder: (context, index) {
                return listWidget[index];
              },
            ),
          ),
        ],
      ),
    );
  }
}

// 2rd stepss

Widget build2ndStepAnswer() {
  final documentWriteController = Get.put(DocumentWriteController());
  return Column(
    children: <Widget>[
      Expanded(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: StreamBuilder(
                  stream: supabase
                      .schema(ApiConst.templatecshema)
                      .from("user_responses")
                      .stream(primaryKey: ["id"])
                      .eq("generation_id",
                          documentWriteController.readId() ?? 0)
                      .order("id", ascending: false),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text("Error : ${snapshot.error}");
                    } else if (snapshot.data == null) {
                      return const Center(child: Text("Not Data Found"));
                    }
                    final data = snapshot.data as List;
                    final res = data
                        .map((e) => DocWriterAnswerModel.fromJson(e))
                        .toList();
                    if (res.isEmpty) {
                      return const Center(child: Text("No Data Found"));
                    }
                    return CarouselSlider.builder(
                        options: CarouselOptions(
                          viewportFraction: 1,
                          padEnds: true,
                          pageSnapping: true,
                          initialPage: 0,
                          enableInfiniteScroll: false,
                          reverse: false,
                          autoPlayInterval: const Duration(seconds: 5),
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          autoPlay: false,
                          height: 521.0,
                        ),
                        itemCount: res.length,
                        itemBuilder: (_, i, int pageViewIndex) {
                          final result = res[i];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 5,
                            child: Column(
                              children: <Widget>[
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(result.sectionRef.toString()),
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "$i",
                                              style: colorbuttonTextStyle,
                                            ),
                                            TextSpan(
                                              text: "/${res.length}",
                                              style: const TextStyle(
                                                color: AppColors.disableColor,
                                                fontSize: 16,
                                                fontFamily: 'Open Sans',
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Text(
                                        "${result.question}",
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                          color: AppColors.blacktxtColor,
                                          fontSize: 16,
                                          fontFamily: 'Open Sans',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    res[i].questionType == "fill_in_the_blank"
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(top: 20),
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 14),
                                              height: 90,
                                              decoration: ShapeDecoration(
                                                color: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  side: const BorderSide(
                                                      width: 1,
                                                      color: Color(0xFFCFCFCF)),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                              child: Obx(() {
                                                return TextFormField(
                                                  controller:
                                                      documentWriteController
                                                          .answerController
                                                          .value,
                                                  onChanged: (value) {
                                                    documentWriteController
                                                        .answerController
                                                        .refresh();
                                                  },
                                                  maxLength: 80,
                                                  maxLines: 2,
                                                  decoration:
                                                      const InputDecoration(
                                                    hintText:
                                                        'Type your answer here',
                                                    hintStyle: TextStyle(
                                                      color: Color(0xFFBFBFBF),
                                                      fontSize: 14,
                                                      fontFamily: 'Open Sans',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                    border: InputBorder.none,
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8.0,
                                                            horizontal: 12.0),
                                                  ),
                                                );
                                              }),
                                            ),
                                          )
                                        : ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: result.options?.length,
                                            itemBuilder: (context, index) {
                                              return Obx(() {
                                                return RadioListTile(
                                                    value: result
                                                        .options?[index]
                                                        .toString(),
                                                    activeColor: Colors.red,
                                                    groupValue:
                                                        documentWriteController
                                                            .selectedOptions
                                                            .value,
                                                    title: Text(
                                                      "${result.options?[index]}",
                                                    ),
                                                    onChanged: (newValue) {
                                                      documentWriteController
                                                              .selectedOptions
                                                              .value =
                                                          newValue.toString();
                                                      if (kDebugMode) {
                                                        print(
                                                            "Amreshkumar ${documentWriteController.selectedOptions.value}");
                                                      }
                                                    });
                                              });
                                            }),
                                  ],
                                ),
                                const Expanded(child: SizedBox()),
                                TextButton(
                                  style: TextButton.styleFrom(),
                                  onPressed: () {
                                    documentWriteController.answerController
                                        .value.text = "No Response";
                                    documentWriteController.answerController
                                        .refresh();
                                  },
                                  child: const Text(
                                    "No Response",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColors.textcolor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      fontFamily: 'Open Sans',
                                    ),
                                  ),
                                ),
                                const Opacity(
                                  opacity: 0.90,
                                  child: Text(
                                    'Click here if you don’t know the answer',
                                    style: TextStyle(
                                      color: Color(0xFF505050),
                                      fontSize: 12,
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          );
                        });
                  }),
            ),
          ),
        ),
      ),

      // ?? Widget Button start here --------

      Padding(
        padding: const EdgeInsets.all(20.0),
        child: WidgetButtonPress(child: Obx(() {
          return ReusableGradientButton(
            width: 250,
            height: 34,
            gradient:
                documentWriteController.answerController.value.text.isEmpty
                    ? AppColors.disablelinearGradient
                    : AppColors.linearGradient,
            onPressed: documentWriteController
                    .answerController.value.text.isEmpty
                ? null
                : () async {
                    if (!documentWriteController.isLoading.isTrue) {
                      bool? res =
                          await documentWriteController.UpdateUserResponse();
                      if (res == true) {
                        documentWriteController.moveToStepersPage1();
                      }
                    }
                  },
            child: documentWriteController.isLoading.isFalse
                ? const Text(
                    "Proceed",
                    style: buttonTextStyle,
                  )
                : const CircularProgressIndicator(),
          );
        })),
      ),
    ],
  );
}

//?? review Step close here
Widget build3rdStepReview() {
  final documentWriteController = Get.put(DocumentWriteController());
  return Column(
    children: <Widget>[
      Expanded(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: Column(
                children: [
                  StreamBuilder(
                      stream: supabase
                          .schema(ApiConst.templatecshema)
                          .from("user_responses")
                          .stream(primaryKey: ["id"]).eq("generation_id",
                              documentWriteController.readId() ?? 0),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        final data = snapshot.data as List;
                        final res = data
                            .map((e) => DocWriterAnswerModel.fromJson(e))
                            .toList();
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 1,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 340,
                                child: ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: res.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                          minVerticalPadding: 8.0,
                                          minLeadingWidth: 8.0,
                                          leading: Text(
                                            "${index + 1}.",
                                            style: const TextStyle(
                                              color: Color(0xff2C2C2C),
                                              fontSize: 14,
                                              fontFamily: 'Open Sans',
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          title: SizedBox(
                                            width: 298,
                                            child: Text(
                                              textAlign: TextAlign.start,
                                              "${res[index].question}",
                                              style: const TextStyle(
                                                color: Color(0xFF2B2B2B),
                                                fontSize: 14,
                                                fontFamily: 'Open Sans',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                          subtitle: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8),
                                            child: SizedBox(
                                              width: 298,
                                              child: Opacity(
                                                opacity: 0.90,
                                                child: Text(
                                                  textAlign: TextAlign.start,
                                                  "${res[index].answer}",
                                                  style: const TextStyle(
                                                    color: Color(0xFF707070),
                                                    fontSize: 14,
                                                    fontFamily: 'Open Sans',
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ));
                                    }),
                              ),
                            ],
                          ),
                        );
                      }),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(
                              left: 14,
                              top: 10,
                              bottom: 10,
                              right: 14), // EdgeInsets.all(),
                          child: Text(
                            'Additional information',
                            style: TextStyle(
                              color: Color(0xFF404040),
                              fontSize: 16,
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 14),
                          height: 116,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 1, color: Color(0xFFCFCFCF)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Obx(
                            () => TextFormField(
                              controller: documentWriteController
                                  .additionalInformationController.value,
                              onChanged: (value) {
                                documentWriteController
                                    .additionalInformationController
                                    .refresh();
                              },
                              maxLength: 80,
                              maxLines: 3,
                              decoration: const InputDecoration(
                                hintText:
                                    'If you wish to add any other details you can add here',
                                hintStyle: TextStyle(
                                  color: Color(0xFFBFBFBF),
                                  fontSize: 14,
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.w400,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 12.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      // ?? Widget Button start here --------
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: WidgetButtonPress(
          child: Obx(() {
            return ReusableGradientButton(
              width: 250,
              height: 34,
              onPressed: () async {
                if (!documentWriteController.isLoading.isTrue) {
                  bool? res =
                      await documentWriteController.additionalInformation();
                  if (res == true) {
                    bool? resdraftWrite =
                        await documentWriteController.postdFinaldraftwrite();
                    if (resdraftWrite == true) {
                      supabase
                          .schema(ApiConst.templatecshema)
                          .from("doc_generations")
                          .stream(primaryKey: ["id"])
                          .eq('id', documentWriteController.readId() ?? 0)
                          .listen((data) {
                            if (data[0]['task_id'] != null) {
                              if (kDebugMode) {
                                print("amreshhhhrrrrr ${data[0]['task_id']}");
                              }
                              documentWriteController
                                  .webSocketFinalDraftWebSoket(
                                      data[0]['task_id']);
                            }
                          });
                    }
                  }
                }
              },
              gradient: AppColors.linearGradient,
              child: documentWriteController.isLoading.isFalse
                  ? const Text(
                      "Proceed",
                      style: buttonTextStyle,
                    )
                  : const CircularProgressIndicator(),
            );
          }),
        ),
      ),
    ],
  );
}
