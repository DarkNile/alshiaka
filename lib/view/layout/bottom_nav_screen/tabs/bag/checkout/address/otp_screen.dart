import 'package:ahshiaka/bloc/layout_cubit/checkout_cubit/checkout_cubit.dart';
import 'package:ahshiaka/shared/components.dart';
import 'package:ahshiaka/view/layout/bottom_nav_screen/tabs/bag/checkout/address/custom_otp_field.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({
    super.key,
    required this.phone,
    required this.addressId,
    required this.isQuest,
    required this.selectedCity,
    required this.selectedRegion,
  });

  final String phone;
  final String? addressId;
  final bool isQuest;
  final String selectedCity;
  final String selectedRegion;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  String code = '';
  String code1 = '', code2 = '', code3 = '', code4 = '', code5 = '';
  bool isError = false;

  Future<void> verify() async {
    code = code1 + code2 + code3 + code4 + code5;
    print(code);
    if (code.isEmpty || code.length != 5) {
      setState(() {
        isError = true;
      });
    } else {
      final response =
          await CheckoutCubit.get(context).verifyPhone(widget.phone, code);
      if (response['success'] == 1) {
        setState(() {
          isError = false;
        });
        await CheckoutCubit.get(context).saveAddress(
          context,
          address_id: widget.addressId,
          isquest: widget.isQuest,
          selectedCity: widget.selectedCity,
          selectedRegion: widget.selectedRegion,
        );
      } else {
        setState(() {
          isError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(
            text: "pleaseVerify".tr() + '\n' + widget.phone,
            textAlign: TextAlign.center,
          ),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomOTPField(
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      code1 = value;
                      FocusScope.of(context).nextFocus();
                    }
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                CustomOTPField(
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      code2 = value;
                      FocusScope.of(context).nextFocus();
                    }
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                CustomOTPField(
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      code3 = value;
                      FocusScope.of(context).nextFocus();
                    }
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                CustomOTPField(
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      code4 = value;
                      FocusScope.of(context).nextFocus();
                    }
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                CustomOTPField(
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      code5 = value;
                      FocusScope.of(context).nextFocus();
                    }
                  },
                ),
              ],
            ),
          ),
          if (isError)
            CustomText(
              text: "invalidCode".tr(),
              color: Colors.red,
            ),
          CustomButton(
            text: "verify".tr(),
            onPressed: verify,
          ),
        ],
      ),
    );
  }
}
