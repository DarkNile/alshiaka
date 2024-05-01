import 'package:ahshiaka/bloc/layout_cubit/checkout_cubit/checkout_cubit.dart';
import 'package:ahshiaka/models/checkout/amount_aramex_model.dart';
import 'package:ahshiaka/view/layout/bottom_nav_screen/tabs/bag/checkout/address/addresses_screen/widgets/add_new_address_button_widget.dart';
import 'package:ahshiaka/view/layout/bottom_nav_screen/tabs/bag/checkout/address/addresses_screen/widgets/empty_adress_widget.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:ahshiaka/bloc/layout_cubit/checkout_cubit/checkout_state.dart';
import 'package:ahshiaka/models/AddressLocalModel.dart';
import 'package:ahshiaka/models/checkout/addresses_model.dart';
import 'package:ahshiaka/models/checkout/shipping_model.dart';
import 'package:ahshiaka/view/layout/bottom_nav_screen/tabs/bag/checkout/address/add_new_address/add_new_address.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../../../../../../../../../shared/components.dart';
import '../../../../../../../../../utilities/app_ui.dart';
import '../../../../../../../../../utilities/app_util.dart';

class AddressisQuestWidget extends StatelessWidget {
  final CheckoutCubit cubit;
  final bool isFromProfile;
  final bool isQuest;
  const AddressisQuestWidget(
      {super.key,
      required this.cubit,
      required this.isFromProfile,
      required this.isQuest});

  @override
  Widget build(BuildContext context) {
    log("Address Is Quest Widget");
    return Expanded(
      child: cubit.dataLocal.length == 0
          ? EmptyAddressWidget(
              isQuest: isQuest,
              isFromProfile: isFromProfile,
            )
          : StatefulBuilder(
              builder: (BuildContext context, setState) => ListView(
                shrinkWrap: true,
                children: List.generate(cubit.dataLocal.length, (index) {
                  AddressMedelLocal c =
                      AddressMedelLocal.fromMap(cubit.dataLocal[index]);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () async {
                          if (isFromProfile) {
                            var phoneNumber =
                                await PhoneNumber.getRegionInfoFromPhoneNumber(
                                    c.phone);
                            log("phoneNumber \n $phoneNumber \n");
                            cubit.phoneNumber = phoneNumber;
                            cubit.selectedState = c.state;
                            cubit.stateController.text = cubit.selectedState;
                            log("Edit Local cubit.selectedState ========> ${cubit.selectedState}");

                            setSelectedCountry(cubit);
                            cubit.updateState();

                            print(c.city);
                            AppUtil.mainNavigator(
                              context,
                              AddNewAddress(
                                isQuest: isQuest,
                                isFromProfile: isFromProfile,
                                address: Address0(
                                  shippingFirstName: c.firstname,
                                  shippingLastName: c.lastname,
                                  shippingCity: c.city,
                                  shippingAddress1: c.address.toString(),
                                  shippingEmail: c.email,
                                  shippingPhone: c.phone,
                                  shippingPostcode: c.code,
                                  shippingCountry: c.region,
                                  shippingState: c.state,
                                ),
                                //
                                addressKey: index.toString(),
                              ),
                            );
                            return;
                          }
                          cubit.selectedState = c.state;
                          cubit.selectedCity = c.city;
                          cubit.cityController.text = c.city;
                          cubit.stateController.text = cubit.selectedState;
                          log("OnTap Local cubit.selectedState ========> ${cubit.selectedState}");
                          if (!isFromProfile) {
                            await setSelectedCountry(cubit);
                          }
                          cubit.updateState();
                          if (cubit.selectedState != AppUtil.ksa &&
                              (!isFromProfile) &&
                              context.mounted) {
                            AppUtil.newSuccessToastTOP(context, null);
                            await getTaxAramex(cubit, context, true);
                          }

                          cubit.selectedAddress = AddressesModel(
                              fullName: c.firstname,
                              surName: c.lastname,
                              phoneNumber: c.phone,
                              email: c.email,
                              address: c.address.toString(),
                              state: c.state,
                              address2: c.address.toString(),
                              city: c.city,
                              postCode: c.code,
                              country: c.region,
                              defaultAddress: index == 0 ? true : false);

                          // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

                          cubit.emit(AddressesState());
                          cubit.updateState();

                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: AppUI.whiteColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: cubit.selectedState == c.state
                                        ? AppUI.mainColor
                                        : AppUI.whiteColor)),
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        text: index == 0
                                            ? "primaryAddress".tr()
                                            : "",
                                        color: AppUI.mainColor,
                                        fontSize: 12,
                                      ),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      CustomText(
                                        text: c.city,
                                        color: AppUI.blackColor,
                                        fontSize: 12,
                                      ),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      CustomText(
                                        text: c.address.toString(),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w100,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    //? ========= Edit =========
                                    InkWell(
                                        onTap: () async {
                                          log("Edit From Internet");
                                          String phone = c.phone == ''
                                              ? "+96655"
                                              : c.phone;
                                          log("phone ${phone}");
                                          var phoneNumber = await PhoneNumber
                                              .getRegionInfoFromPhoneNumber(
                                                  phone);
                                          log("phoneNumber \n $phoneNumber \n");
                                          cubit.phoneNumber = phoneNumber;
                                          cubit.selectedState = c.state;
                                          cubit.stateController.text =
                                              cubit.selectedState;
                                          log("Edit Local cubit.selectedState ========> ${cubit.selectedState}");

                                          setSelectedCountry(cubit);
                                          cubit.updateState();

                                          print(c.city);
                                          AppUtil.mainNavigator(
                                            context,
                                            AddNewAddress(
                                              isQuest: isQuest,
                                              isFromProfile: isFromProfile,
                                              address: Address0(
                                                shippingFirstName: c.firstname,
                                                shippingLastName: c.lastname,
                                                shippingCity: c.city,
                                                shippingAddress1:
                                                    c.address.toString(),
                                                shippingEmail: c.email,
                                                shippingPhone: c.phone,
                                                shippingPostcode: c.code,
                                                shippingCountry: c.region,
                                                shippingState: c.state,
                                              ),
                                              //
                                              addressKey: index.toString(),
                                            ),
                                          );
                                        },
                                        child: Icon(
                                          Icons.edit,
                                          color: AppUI.greyColor,
                                          size: 19,
                                        )),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    GestureDetector(
                                        onTap: () async {
                                          //? ========= Delete =========
                                          AppUtil.dialog2(context, "", [
                                            const LoadingWidget(),
                                            const SizedBox(
                                              height: 30,
                                            )
                                          ]);
                                          print(c.code);
                                          print(
                                              "sssssssssssssssssssssssssssssssssssssssss");
                                          cubit.db.delete(c.code);
                                          cubit.loadAddressLocal();
                                          setState(() {});
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.delete,
                                            color: AppUI.greyColor,
                                            size: 19,
                                          ),
                                        )),
                                  ],
                                )),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      if (cubit.dataLocal.length < 1)
                        AddNewAddressButtonWidget(
                          isFromProfile: isFromProfile,
                          isQuest: isQuest,
                        )
                    ],
                  );
                }),
              ),
            ),
    );
  }
}

Future<AmountAramexModel?> getTaxAramex(
    CheckoutCubit cubit, BuildContext context, bool isPOP) async {
  return await cubit.getTaxAramex(context: context, isPOP: isPOP);
}

setSelectedCountry(CheckoutCubit cubit) async {
  if (cubit.selectedState != AppUtil.ksa) {
    if (cubit.countries.isEmpty || cubit.countries == []) {
      cubit.selectedCountry =
          cubit.countries.firstWhere((c) => c.name == cubit.selectedState);
    } else {
      await cubit.fetchCountries();
      cubit.selectedCountry =
          cubit.countries.firstWhere((c) => c.name == cubit.selectedState);
    }
  }
}
