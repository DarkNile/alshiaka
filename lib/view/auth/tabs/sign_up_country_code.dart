import 'dart:developer';
import 'package:ahshiaka/bloc/auth_cubit/auth_cubit.dart';
import 'package:ahshiaka/utilities/app_ui.dart';
import 'package:ahshiaka/utilities/app_util.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class SignUpCountryCodeWidget extends StatelessWidget {
  final AuthCubit cubit;
  const SignUpCountryCodeWidget({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: InternationalPhoneNumberInput(
        countries: [
          'SA',
          'EG',
        ],
        onInputChanged: (PhoneNumber number) {
          log(number.phoneNumber.toString());
          cubit.phoneCode = number.dialCode ?? "+966";
          cubit.phoneNumber = number;
          cubit.registerPhone.text = number.phoneNumber.toString();
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
            fontFamily: AppUtil.rtlDirection(context) ? "cairo" : "Tajawal",
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
              borderSide: BorderSide(color: AppUI.shimmerColor, width: 0.5)),
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
    );
  }
}
