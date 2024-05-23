import 'package:ahshiaka/bloc/layout_cubit/checkout_cubit/checkout_cubit.dart';
import 'package:ahshiaka/models/checkout/amount_aramex_model.dart';
import 'package:ahshiaka/utilities/cache_helper.dart';
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

class AddressFromInternetWidget extends StatefulWidget {
  final CheckoutCubit cubit;
  final bool isFromProfile;
  final bool isQuest;
  const AddressFromInternetWidget(
      {super.key,
      required this.cubit,
      required this.isFromProfile,
      required this.isQuest});

  @override
  State<AddressFromInternetWidget> createState() =>
      _AddressFromInternetWidgetState();
}

class _AddressFromInternetWidgetState extends State<AddressFromInternetWidget> {
  @override
  void dispose() {
    if (widget.cubit.selectedState != AppUtil.ksa && !(widget.isFromProfile)) {
      getTaxAramex(widget.cubit, context, true);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("Address From Internet Widget");
    return Expanded(
      child: widget.cubit.addresses == null ||
              widget.cubit.addresses!.shipping == null ||
              widget.cubit.addresses!.shipping!.address0 == null ||
              widget.cubit.addresses!.shipping!.address0!.isEmpty
          ? EmptyAddressWidget(
              isQuest: widget.isQuest,
              isFromProfile: widget.isFromProfile,
            )
          : ListView(
              shrinkWrap: true,
              children: List.generate(
                  widget.cubit.addresses!.shipping!.address0!.length, (index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () async {
                        if (widget.isFromProfile) {
                          log("Edit From Internet");
                          String phone = widget.cubit.addresses?.shipping!
                                  .address0?[index].shippingPhone ??
                              "+966555";
                          log("phone ${phone}");
                          var phoneNumber;
                          try {
                            log("phoneNumber try");
                            phoneNumber =
                                await PhoneNumber.getRegionInfoFromPhoneNumber(
                                    phone);
                          } catch (e) {
                            log("phoneNumber catch");
                            phoneNumber =
                                await PhoneNumber.getRegionInfoFromPhoneNumber(
                                    "+966555");
                          }
                          log("phoneNumber \n $phoneNumber \n");
                          widget.cubit.phoneNumber = phoneNumber;
                          widget.cubit.selectedState = widget.cubit.addresses!
                              .shipping!.address0![index].shippingState!;
                          widget.cubit.stateController.text =
                              widget.cubit.selectedState;
                          log("Edit Fetch cubit.selectedState ========> ${widget.cubit.selectedState}");
                          setSelectedCountry(widget.cubit);
                          widget.cubit.updateState();
                          AppUtil.mainNavigator(
                              context,
                              AddNewAddress(
                                isFromProfile: widget.isFromProfile,
                                address: widget.cubit.addresses!.shipping!
                                    .address0![index],
                                addressKey: widget.cubit.addresses!.shipping!
                                    .addressesKey![index],
                                isQuest: widget.isQuest,
                              ));
                          return;
                        }
                        widget.cubit.selectedState = widget.cubit.addresses!
                            .shipping!.address0![index].shippingState!;
                        widget.cubit.selectedCity = widget.cubit.addresses!
                            .shipping!.address0![index].shippingCity!;
                        widget.cubit.cityController.text = widget
                            .cubit
                            .addresses!
                            .shipping!
                            .address0![index]
                            .shippingCity!;
                        widget.cubit.stateController.text =
                            widget.cubit.selectedState;
                        log("OnTap Fetch cubit.selectedState ========> ${widget.cubit.selectedState}");
                        if (!widget.isFromProfile) {
                          await setSelectedCountry(widget.cubit);
                        }
                        if (index == 0) {
                          await CacheHelper.write(
                              "Country Code",
                              widget.cubit.selectedState == AppUtil.ksa
                                  ? "SA"
                                  : "EG");
                        }

                        widget.cubit.updateState();
                        if (widget.cubit.selectedState != AppUtil.ksa &&
                            !(widget.isFromProfile) &&
                            context.mounted) {
                          log("VISA ${widget.cubit.paymentGetawayNoCash.length} ");
                          widget.cubit.selectedPaymentGetaways =
                              widget.cubit.paymentGetawayNoCash[0];
                        }

                        widget.cubit.selectedAddress = AddressesModel(
                            fullName: widget.cubit.addresses!.shipping!
                                .address0![index].shippingFirstName,
                            surName: widget.cubit.addresses!.shipping!
                                .address0![index].shippingLastName,
                            phoneNumber: widget.cubit.addresses!.shipping!
                                .address0![index].shippingPhone,
                            email: widget.cubit.addresses!.shipping!
                                .address0![index].shippingEmail,
                            address: widget.cubit.addresses!.shipping!
                                .address0![index].shippingAddress1,
                            state: widget.cubit.addresses!.shipping!
                                .address0![index].shippingState,
                            address2: widget.cubit.addresses!.shipping!
                                .address0![index].shippingAddress2,
                            city: widget.cubit.addresses!.shipping!
                                .address0![index].shippingCity,
                            postCode: widget.cubit.addresses!.shipping!
                                .address0![index].shippingPostcode,
                            country: widget.cubit.addresses!.shipping!
                                .address0![index].shippingCountry,
                            defaultAddress: index == 0 ? true : false);

                        widget.cubit.emit(AddressesState());
                        widget.cubit.updateState();
                        print(widget.cubit.selectedAddress!.email!);
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
                                  color: ((!widget.isFromProfile) &&
                                          widget.cubit.selectedState ==
                                              widget
                                                  .cubit
                                                  .addresses!
                                                  .shipping!
                                                  .address0![index]
                                                  .shippingState!)
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
                                      text: widget.cubit.addresses!.shipping!
                                          .address0![index].shippingCity,
                                      color: AppUI.blackColor,
                                      fontSize: 12,
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    CustomText(
                                      text: widget.cubit.addresses!.shipping!
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
                                        String phone = widget
                                                .cubit
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
                                        widget.cubit.phoneNumber = phoneNumber;
                                        widget.cubit.selectedState = widget
                                            .cubit
                                            .addresses!
                                            .shipping!
                                            .address0![index]
                                            .shippingState!;
                                        widget.cubit.stateController.text =
                                            widget.cubit.selectedState;
                                        log("Edit Fetch cubit.selectedState ========> ${widget.cubit.selectedState}");
                                        setSelectedCountry(widget.cubit);
                                        widget.cubit.updateState();
                                        AppUtil.mainNavigator(
                                            context,
                                            AddNewAddress(
                                              isFromProfile:
                                                  widget.isFromProfile,
                                              address: widget.cubit.addresses!
                                                  .shipping!.address0![index],
                                              addressKey: widget
                                                  .cubit
                                                  .addresses!
                                                  .shipping!
                                                  .addressesKey![index],
                                              isQuest: widget.isQuest,
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
                                        log("${widget.cubit.addresses?.shipping!.addressesKey![index]}");
                                        await widget.cubit.deleteAddress(widget
                                            .cubit
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
                    if (widget.cubit.addresses!.shipping!.address0!.length < 2)
                      AddNewAddressButtonWidget(
                        isFromProfile: widget.isFromProfile,
                        isQuest: widget.isQuest,
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
