import 'package:ahshiaka/shared/components.dart';
import 'package:ahshiaka/utilities/app_util.dart';
import 'package:ahshiaka/view/layout/bottom_nav_screen/tabs/bag/checkout/payment/successful_payment.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'add_new_credit_card.dart';
class SavedCreditCard extends StatefulWidget {
  const SavedCreditCard({Key? key}) : super(key: key);

  @override
  _SavedCreditCardState createState() => _SavedCreditCardState();
}

class _SavedCreditCardState extends State<SavedCreditCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(title: "myCards".tr(),),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: List.generate(5, (index) {
                  return InkWell(
                    onTap: (){
                      AppUtil.mainNavigator(context, SuccessfulPayment());
                    },
                    child: Column(
                      children: [
                        CustomCreditCard(),
                        const SizedBox(height: 20,)
                      ],
                    ),
                  );
                }),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: CustomCard(
        height: 75,padding: 0.0,
        child: CustomButton(text: "addCard".tr(),onPressed: (){
          AppUtil.mainNavigator(context, AddNewCreditCard());
        },),
      ),
    );
  }
}
