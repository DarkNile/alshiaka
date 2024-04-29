import 'package:ahshiaka/utilities/app_ui.dart';
import 'package:ahshiaka/utilities/app_util.dart';
import 'package:ahshiaka/view/layout/bottom_nav_screen/tabs/bag/checkout/address/add_new_address/add_new_address.dart';
import 'package:flutter/material.dart';

class AddNewAddressButtonWidget extends StatelessWidget {
  final bool isFromProfile;
  final bool isQuest;
  const AddNewAddressButtonWidget(
      {super.key, required this.isFromProfile, required this.isQuest});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
          onTap: () {
            AppUtil.mainNavigator(
                context,
                AddNewAddress(
                  isFromProfile: isFromProfile,
                  isQuest: isQuest,
                ));
          },
          child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppUI.alshiakaColor),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 25,
              ))),
    );
  }
}
