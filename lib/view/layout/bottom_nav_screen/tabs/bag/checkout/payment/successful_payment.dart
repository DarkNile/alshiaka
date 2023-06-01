import 'package:ahshiaka/shared/components.dart';
import 'package:ahshiaka/utilities/app_util.dart';
import 'package:ahshiaka/view/layout/bottom_nav_screen/bottom_nav_tabs_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../utilities/app_ui.dart';
import '../../../profile/my_orders/track_order_screen.dart';

class SuccessfulPayment extends StatefulWidget {
  const SuccessfulPayment({Key? key}) : super(key: key);

  @override
  _SuccessfulPaymentState createState() => _SuccessfulPaymentState();
}

class _SuccessfulPaymentState extends State<SuccessfulPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppUI.backgroundColor,
      body: Column(
        children: [
          CustomAppBar(title: "successfulPayment".tr()),
          const SizedBox(height: 20,),
          Container(
            color: AppUI.whiteColor,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    CustomText(text: "orderId".tr(),fontWeight: FontWeight.w100,color: AppUI.greyColor,),
                    const Spacer(),
                    CustomText(text: "#12345",fontWeight: FontWeight.w100,color: AppUI.blackColor,),
                  ],
                ),
                const SizedBox(height: 10,),
                Row(
                  children: [
                    CustomText(text: "status".tr(),fontWeight: FontWeight.w100,color: AppUI.greyColor,),
                    const Spacer(),
                    CustomText(text: "Paid",fontWeight: FontWeight.w100,color: AppUI.activeColor,),
                  ],
                ),

                const SizedBox(height: 10,),
                Row(
                  children: [
                    CustomText(text: "date".tr(),fontWeight: FontWeight.w100,color: AppUI.greyColor,),
                    const Spacer(),
                    CustomText(text: "may 30.2022at 3:30 pm",fontWeight: FontWeight.w100,color: AppUI.blackColor,),
                  ],
                ),

                const SizedBox(height: 10,),

                Row(
                  children: [
                    CustomText(text: "date".tr(),fontWeight: FontWeight.w100,color: AppUI.greyColor,),
                    const Spacer(),
                    CustomText(text: "May 30.2022at 3:30 pm",fontWeight: FontWeight.w100,color: AppUI.blackColor,),
                  ],
                ),

                const SizedBox(height: 10,),

                Row(
                  children: [
                    CustomText(text: "paymentMethod".tr(),fontWeight: FontWeight.w100,color: AppUI.greyColor,),
                    const Spacer(),
                    CustomText(text: "Credit card",fontWeight: FontWeight.w100,color: AppUI.blackColor,),
                  ],
                ),
                const SizedBox(height: 10,),
                const Divider(),
                const SizedBox(height: 10,),
                Row(
                  children: [
                    CustomText(text: "subtotal".tr(),fontWeight: FontWeight.w100,color: AppUI.greyColor,),
                    const Spacer(),
                    CustomText(text: "sar 3.000",fontWeight: FontWeight.w700,color: AppUI.blackColor,),
                  ],
                ),
                const SizedBox(height: 10,),
                Row(
                  children: [
                    CustomText(text: "shipping".tr(),fontWeight: FontWeight.w100,color: AppUI.greyColor,),
                    const Spacer(),
                    CustomText(text: "sar 20",fontWeight: FontWeight.w700,color: AppUI.blackColor,),
                  ],
                ),
                const SizedBox(height: 10,),
                const Divider(),
                const SizedBox(height: 10,),
                InkWell(
                  onTap: (){
                    // AppUtil.mainNavigator(context, ContactUs());
                  },
                  child: Text.rich(
                      TextSpan(
                          text: 'Your order is paid any help contact our support team via the ',
                          children: <InlineSpan>[
                            TextSpan(
                              text: 'contact us ',
                              style: TextStyle(fontSize: 14,fontWeight: FontWeight.w100,color: AppUI.mainColor),
                            ),
                            const TextSpan(
                              text: 'from .',
                              style: TextStyle(fontSize: 14,fontWeight: FontWeight.w100),
                            ),

                          ]
                      )
                  ),
                ),

              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: CustomCard(
        height: 160,padding: 0.0,
        child: Column(
          children: [
            CustomButton(text: "trackYourOrder".tr(),onPressed: (){
              AppUtil.mainNavigator(context, TrackOrderScreen());
            },),
            const SizedBox(height: 10,),
            CustomButton(text: "goToHome".tr(),onPressed: (){
              AppUtil.removeUntilNavigator(context, BottomNavTabsScreen());
            },borderColor: AppUI.mainColor,color: AppUI.whiteColor,textColor: AppUI.mainColor,),
          ],
        ),
      ),
    );
  }
}
