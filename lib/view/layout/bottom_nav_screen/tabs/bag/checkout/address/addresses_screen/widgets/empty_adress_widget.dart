import 'package:flutter/material.dart';
import 'package:ahshiaka/view/layout/bottom_nav_screen/tabs/bag/checkout/address/add_new_address/add_new_address.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../../../../shared/components.dart';
import '../../../../../../../../../utilities/app_ui.dart';
import '../../../../../../../../../utilities/app_util.dart';

class EmptyAddressWidget extends StatelessWidget {
  final bool isFromProfile;
  final bool isQuest;
  const EmptyAddressWidget(
      {super.key, required this.isFromProfile, required this.isQuest});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        Image.asset("assets/images/address.PNG"),
        SizedBox(
          height: 11,
        ),
        CustomText(
          text: "noAddressesFound".tr(),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(
          height: 8,
        ),
        CustomText(
          text: "noaddress2".tr(),
          fontSize: 12,
          color: Colors.black38,
        ),
        SizedBox(
          height: 20,
        ),
        GestureDetector(
            onTap: () {
              AppUtil.mainNavigator(
                  context,
                  AddNewAddress(
                      isFromProfile: isFromProfile, isQuest: isQuest));
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
                )))
      ],
    ));
  }
}
