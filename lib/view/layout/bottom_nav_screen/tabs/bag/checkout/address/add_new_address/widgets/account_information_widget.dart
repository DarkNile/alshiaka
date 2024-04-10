import 'package:ahshiaka/bloc/layout_cubit/checkout_cubit/checkout_cubit.dart';
import 'package:flutter/widgets.dart';
import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../../../../../../../../../shared/components.dart';
import '../../../../../../../../../utilities/app_ui.dart';
import '../../../../../../../../../utilities/app_util.dart';

class AccountInformationWidget extends StatelessWidget {
  final CheckoutCubit cubit;
  const AccountInformationWidget({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          children: [
            CustomText(
              text: "accountInformation".tr(),
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
      Container(
        color: AppUI.whiteColor,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "firstName".tr(),
              color: AppUI.greyColor,
            ),
            CustomInput(
              controller: cubit.nameController2,
              textInputType: TextInputType.text,
              hint: "firstName".tr(),
            ),
            const SizedBox(
              height: 10,
            ),
            CustomText(
              text: "lastName".tr(),
              color: AppUI.greyColor,
            ),
            CustomInput(
              controller: cubit.surNameController2,
              textInputType: TextInputType.text,
              hint: "lastName".tr(),
            ),
            const SizedBox(
              height: 10,
            ),
            CustomText(
              text: "phoneNumber".tr(),
              color: AppUI.greyColor,
            ),
            InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {
                log(number.phoneNumber.toString());
                cubit.phoneCode = number.dialCode ?? "+966";
                cubit.phoneNumber = number;
                cubit.phoneController.text = number.phoneNumber.toString();
              },
              onInputValidated: (bool value) {
                log("Input Validated  " + value.toString());
              },
              validator: (number) {
                if (number!.isEmpty) {
                  return "phoneNumberRequired".tr();
                }
                return null;
              },

              selectorConfig: SelectorConfig(
                selectorType: PhoneInputSelectorType.DROPDOWN,
                useBottomSheetSafeArea: true,
              ),
              ignoreBlank: false,
              autoValidateMode: AutovalidateMode.disabled,
              selectorTextStyle: TextStyle(color: AppUI.blackColor),
              initialValue: cubit.phoneNumber,
              // textFieldController: cubit.phoneController,
              // formatInput: true,
              keyboardType:
                  TextInputType.numberWithOptions(signed: true, decimal: true),
              inputDecoration: InputDecoration(
                hintText: "phoneNumber".tr(),
                counterStyle: TextStyle(fontSize: 0, height: 0),
                hintStyle: TextStyle(
                  fontFamily:
                      AppUtil.rtlDirection(context) ? "cairo" : "Tajawal",
                ),
                filled: true,
                fillColor: AppUI.whiteColor,
                suffixIconConstraints: const BoxConstraints(minWidth: 63),
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: AppUtil.responsiveHeight(context) * 0.021),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    borderSide: BorderSide(color: AppUI.shimmerColor)),
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    borderSide: BorderSide(color: AppUI.shimmerColor)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    borderSide:
                        BorderSide(color: AppUI.shimmerColor, width: 0.5)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    borderSide: BorderSide(color: AppUI.mainColor)),
              ),
              onSaved: (PhoneNumber number) {
                print('On Saved: $number');
              },
            ),
          ],
        ),
      )
    ]);
  }
}
