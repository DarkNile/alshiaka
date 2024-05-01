import 'package:ahshiaka/bloc/layout_cubit/checkout_cubit/checkout_cubit.dart';
import 'package:ahshiaka/models/checkout/amount_aramex_model.dart';
import 'package:ahshiaka/view/layout/bottom_nav_screen/tabs/bag/checkout/address/addresses_screen/widgets/add_new_address_button_widget.dart';
import 'package:ahshiaka/view/layout/bottom_nav_screen/tabs/bag/checkout/address/addresses_screen/widgets/empty_adress_widget.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:ahshiaka/bloc/layout_cubit/checkout_cubit/checkout_state.dart';
import 'package:ahshiaka/models/checkout/addresses_model.dart';
import 'package:ahshiaka/view/layout/bottom_nav_screen/tabs/bag/checkout/address/add_new_address/add_new_address.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../../../../../../../../../shared/components.dart';
import '../../../../../../../../../utilities/app_ui.dart';
import '../../../../../../../../../utilities/app_util.dart';

class AddressFromInternetWidget extends StatelessWidget {
  final CheckoutCubit cubit;
  final bool isFromProfile;
  final bool isQuest;
  const AddressFromInternetWidget(
      {super.key,
      required this.cubit,
      required this.isFromProfile,
      required this.isQuest});

  @override
  Widget build(BuildContext context) {
    log("Address From Internet Widget");
    return Expanded(
      child: cubit.addresses == null ||
              cubit.addresses!.shipping == null ||
              cubit.addresses!.shipping!.address0 == null ||
              cubit.addresses!.shipping!.address0!.isEmpty
          ? EmptyAddressWidget(
              isQuest: isQuest,
              isFromProfile: isFromProfile,
            )
          : ListView(
              shrinkWrap: true,
              children: List.generate(
                  cubit.addresses!.shipping!.address0!.length, (index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () async {
                        if (isFromProfile) {
                          log("Edit From Internet");
                          String phone = cubit.addresses?.shipping!
                                  .address0?[index].shippingPhone ??
                              "+9665";
                          log("phone ${phone}");
                          var phoneNumber =
                              await PhoneNumber.getRegionInfoFromPhoneNumber(
                                  phone);
                          log("phoneNumber \n $phoneNumber \n");
                          cubit.phoneNumber = phoneNumber;
                          cubit.selectedState = cubit.addresses!.shipping!
                              .address0![index].shippingState!;
                          cubit.stateController.text = cubit.selectedState;
                          log("Edit Fetch cubit.selectedState ========> ${cubit.selectedState}");
                          setSelectedCountry(cubit);
                          cubit.updateState();
                          AppUtil.mainNavigator(
                              context,
                              AddNewAddress(
                                isFromProfile: isFromProfile,
                                address:
                                    cubit.addresses!.shipping!.address0![index],
                                addressKey: cubit
                                    .addresses!.shipping!.addressesKey![index],
                                isQuest: isQuest,
                              ));
                          return;
                        }
                        cubit.selectedState = cubit.addresses!.shipping!
                            .address0![index].shippingState!;
                        cubit.selectedCity = cubit.addresses!.shipping!
                            .address0![index].shippingCity!;
                        cubit.cityController.text = cubit.addresses!.shipping!
                            .address0![index].shippingCity!;
                        cubit.stateController.text = cubit.selectedState;
                        log("OnTap Fetch cubit.selectedState ========> ${cubit.selectedState}");
                        if (!isFromProfile) {
                          await setSelectedCountry(cubit);
                        }

                        cubit.updateState();
                        AmountAramexModel? tax;
                        if (cubit.selectedState != AppUtil.ksa &&
                            !(isFromProfile) &&
                            context.mounted) {
                          AppUtil.newSuccessToastTOP(context, null);
                          tax = await getTaxAramex(cubit, context, true);
                        }

                        cubit.selectedAddress = AddressesModel(
                            fullName: cubit.addresses!.shipping!
                                .address0![index].shippingFirstName,
                            surName: cubit.addresses!.shipping!.address0![index]
                                .shippingLastName,
                            phoneNumber: cubit.addresses!.shipping!
                                .address0![index].shippingPhone,
                            email: cubit.addresses!.shipping!.address0![index]
                                .shippingEmail,
                            address: cubit.addresses!.shipping!.address0![index]
                                .shippingAddress1,
                            state: cubit.addresses!.shipping!.address0![index]
                                .shippingState,
                            address2: cubit.addresses!.shipping!
                                .address0![index].shippingAddress2,
                            city: cubit.addresses!.shipping!.address0![index]
                                .shippingCity,
                            postCode: cubit.addresses!.shipping!
                                .address0![index].shippingPostcode,
                            country: cubit.addresses!.shipping!.address0![index]
                                .shippingCountry,
                            defaultAddress: index == 0 ? true : false);

                        cubit.emit(AddressesState());
                        cubit.updateState();
                        print(cubit.selectedAddress!.email!);
                        print("---------------------------------------------");
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
                                  color: cubit.selectedState ==
                                          cubit.addresses!.shipping!
                                              .address0![index].shippingState!
                                      ? AppUI.mainColor
                                      : AppUI.whiteColor)),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      text: cubit.addresses!.shipping!
                                          .address0![index].shippingCity,
                                      color: AppUI.blackColor,
                                      fontSize: 12,
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    CustomText(
                                      text: cubit.addresses!.shipping!
                                          .address0![index].shippingAddress1,
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
                                  // Edit
                                  InkWell(
                                      onTap: () async {
                                        log("Edit From Internet");
                                        String phone = cubit
                                                .addresses
                                                ?.shipping!
                                                .address0?[index]
                                                .shippingPhone ??
                                            "+9665";
                                        log("phone ${phone}");
                                        var phoneNumber = await PhoneNumber
                                            .getRegionInfoFromPhoneNumber(
                                                phone);
                                        log("phoneNumber \n $phoneNumber \n");
                                        cubit.phoneNumber = phoneNumber;
                                        cubit.selectedState = cubit
                                            .addresses!
                                            .shipping!
                                            .address0![index]
                                            .shippingState!;
                                        cubit.stateController.text =
                                            cubit.selectedState;
                                        log("Edit Fetch cubit.selectedState ========> ${cubit.selectedState}");
                                        setSelectedCountry(cubit);
                                        cubit.updateState();
                                        AppUtil.mainNavigator(
                                            context,
                                            AddNewAddress(
                                              isFromProfile: isFromProfile,
                                              address: cubit.addresses!
                                                  .shipping!.address0![index],
                                              addressKey: cubit
                                                  .addresses!
                                                  .shipping!
                                                  .addressesKey![index],
                                              isQuest: isQuest,
                                            ));
                                      },
                                      child: Icon(
                                        Icons.edit,
                                        color: AppUI.greyColor,
                                        size: 19,
                                      )),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  InkWell(
                                      onTap: () async {
                                        AppUtil.dialog2(context, "", [
                                          const LoadingWidget(),
                                          const SizedBox(
                                            height: 30,
                                          )
                                        ]);
                                        // OLD
                                        //await cubit
                                        // .deleteAddress("address_$index");
                                        log("cubit.addresses.shipping!.addressesKey![index]");
                                        log("${cubit.addresses?.shipping!.addressesKey![index]}");
                                        await cubit.deleteAddress(cubit
                                            .addresses!
                                            .shipping!
                                            .addressesKey![index]);
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                      },
                                      child: Icon(
                                        Icons.delete,
                                        color: AppUI.greyColor,
                                        size: 19,
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
                    if (cubit.addresses!.shipping!.address0!.length < 2)
                      AddNewAddressButtonWidget(
                        isFromProfile: isFromProfile,
                        isQuest: isQuest,
                      )
                  ],
                );
              }),
            ),
    );
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
}
