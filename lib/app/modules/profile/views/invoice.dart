import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:prajalok/app/utils/color_const.dart';
import 'package:prajalok/app/utils/widget_const.dart';
import '../../../utils/icons_const.dart';
import '../controllers/notifcation_controller.dart';

class Invoice extends GetView<NotifcationController> {
  Invoice({Key? key}) : super(key: key);
  final controller = Get.put(NotifcationController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text("Invoices",
            style: createCustomTextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: AppColors.blacktxtColor,
            )),
      ),
      body: Center(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // _buildEmptyState(),
            Container(
                height: 280,
                width: Get.width,
                margin: const EdgeInsets.only(top: 16),
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Customer details",
                          style: createCustomTextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: AppColors.blacktxtColor,
                          ),
                        ),
                        InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {},
                            child: SvgPicture.asset(SvgIcons.editPenIcons, height: 20, width: 20)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                        visualDensity: VisualDensity.compact,
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          "Name",
                          style: createCustomTextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: AppColors.textcolor,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Text(
                                "Yashwant",
                                style: createCustomTextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: AppColors.blacktxtColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "7588676252 , yash@gmail.com",
                                style: createCustomTextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: AppColors.blacktxtColor,
                                ),
                              ),
                            ],
                          ),
                        )),
                    ListTile(
                      visualDensity: VisualDensity.compact,
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        "GSTIN",
                        style: createCustomTextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: AppColors.textcolor,
                        ),
                      ),
                      subtitle: Text(
                        "07ABCDE1234F1Z9",
                        style: createCustomTextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: AppColors.blacktxtColor,
                        ),
                      ),
                    ),
                    ListTile(
                      visualDensity: VisualDensity.compact,
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        "Address",
                        style: createCustomTextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: AppColors.textcolor,
                        ),
                      ),
                      subtitle: Text(
                        "123, Park Street, South City, Near ABC Hospital, Bangalore, Karnataka - 560001, India",
                        style: createCustomTextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: AppColors.blacktxtColor,
                        ),
                      ),
                    ),
                  ],
                )),
            Container(
              height: 250,
              width: Get.width,
              margin: const EdgeInsets.only(top: 16),
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Text(
                    "Transactions",
                    style: createCustomTextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: AppColors.blacktxtColor,
                    ),
                  ),
                  Container(
                    //   padding: const EdgeInsets.all(16),
                    // height: 154,
                    margin: const EdgeInsets.only(top: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.searchLawAppBarColors, width: 2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          titleTextStyle: createCustomTextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: AppColors.blacktxtColor,
                          ),
                          subtitleTextStyle: createCustomTextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: AppColors.searchLawAppBarColors,
                          ),
                          minLeadingWidth: 0,
                          // contentPadding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                          leading: SvgPicture.asset(
                            SvgIcons.invoiceIcons,
                            color: AppColors.textcolor,
                            height: 30,
                            width: 20,
                            fit: BoxFit.cover,
                          ),
                          title: const Text("Invoice ID"),
                          subtitle: const Text("HJU548976887JI"),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.greenHalf,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "Successful",
                              style: TextStyle(
                                color: AppColors.greenColor,
                                fontSize: 12,
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Transaction ID",
                                    style: createCustomTextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "HJU548976887JI",
                                    style: createCustomTextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: AppColors.blacktxtColor,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    "Transaction date",
                                    style: createCustomTextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "1/1/2023",
                                    style: createCustomTextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: AppColors.blacktxtColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Amount",
                                    style: createCustomTextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                  Text(
                                    "6,000/-",
                                    style: createCustomTextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: AppColors.textcolor,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: InkWell(
                                  onTap: () {},
                                  child: SvgPicture.asset(
                                    SvgIcons.downloadIcons,
                                    height: 25,
                                    width: 25,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

//emptyState
//invoiceEmtyIcons
Widget _buildEmptyState() {
  return Column(
    children: [
      SvgPicture.asset(
        SvgIcons.invoiceEmtyIcons,
      ),
      Text(
        "It appears you haven’t done any transactions",
        style: createCustomTextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: AppColors.blacktxtColor,
        ),
      )
    ],
  );
}
