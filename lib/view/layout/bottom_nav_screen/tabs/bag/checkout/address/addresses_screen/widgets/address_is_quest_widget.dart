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

class AddressIsQuestWidget extends StatefulWidget {
  final CheckoutCubit cubit;
  final bool isFromProfile;
  final bool isQuest;
  const AddressIsQuestWidget(
      {super.key,
      required this.cubit,
      required this.isFromProfile,
      required this.isQuest});

  @override
  State<AddressIsQuestWidget> createState() => _AddressIsQuestWidgetState();
}

class _AddressIsQuestWidgetState extends State<AddressIsQuestWidget> {
  void dispose() {
    if (widget.cubit.selectedState != AppUtil.ksa && !(widget.isFromProfile)) {
      getTaxAramex(widget.cubit, context, true);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("Address Is Quest Widget");
    return Expanded(
      child: widget.cubit.dataLocal.length == 0
          ? EmptyAddressWidget(
              isQuest: widget.isQuest,
              isFromProfile: widget.isFromProfile,
            )
          : StatefulBuilder(
              builder: (BuildContext context, setState) => ListView(
                shrinkWrap: true,
                children: List.generate(widget.cubit.dataLocal.length, (index) {
                  AddressMedelLocal c =
                      AddressMedelLocal.fromMap(widget.cubit.dataLocal[index]);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () async {
                          if (widget.isFromProfile) {
                            var phoneNumber;

                            String phone = c.phone == '' ? "966555" : c.phone;
                            try {
                              log("phoneNumber try");
                              phoneNumber = await PhoneNumber
                                  .getRegionInfoFromPhoneNumber(phone);
                            } catch (e) {
                              log("phoneNumber catch");
                              phoneNumber = await PhoneNumber
                                  .getRegionInfoFromPhoneNumber("+966555");
                            }

                            log("phoneNumber \n $phoneNumber \n");
                            widget.cubit.phoneNumber = phoneNumber;
                            widget.cubit.selectedState = c.state;
                            widget.cubit.stateController.text =
                                widget.cubit.selectedState;
                            log("Edit Local cubit.selectedState ========> ${widget.cubit.selectedState}");

                            setSelectedCountry(widget.cubit);
                            widget.cubit.updateState();

                            print(c.city);
                            AppUtil.mainNavigator(
                              context,
                              AddNewAddress(
                                isQuest: widget.isQuest,
                                isFromProfile: widget.isFromProfile,
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
                          widget.cubit.selectedState = c.state;
                          widget.cubit.selectedCity = c.city;
                          widget.cubit.cityController.text = c.city;
                          widget.cubit.stateController.text =
                              widget.cubit.selectedState;
                          log("OnTap Local cubit.selectedState ========> ${widget.cubit.selectedState}");
                          if (!widget.isFromProfile) {
                            await setSelectedCountry(widget.cubit);
                          }
                          widget.cubit.updateState();
                          if (widget.cubit.selectedState != AppUtil.ksa &&
                              (!widget.isFromProfile) &&
                              context.mounted) {
                            log("VISA ${widget.cubit.paymentGetawayNoCash.length} ");
                            widget.cubit.selectedPaymentGetaways =
                                widget.cubit.paymentGetawayNoCash[0];
                            // AppUtil.newSuccessToastTOP(context, null);
                            // await getTaxAramex(widget.cubit, context, true);
                          }

                          widget.cubit.selectedAddress = AddressesModel(
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

                          widget.cubit.emit(AddressesState());
                          widget.cubit.updateState();

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
                                                c.state
                                        ? AppUI.mainColor
                                        : AppUI.whiteColor))),
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
                                          widget.cubit.phoneNumber =
                                              phoneNumber;
                                          widget.cubit.selectedState = c.state;
                                          widget.cubit.stateController.text =
                                              widget.cubit.selectedState;
                                          log("Edit Local cubit.selectedState ========> ${widget.cubit.selectedState}");

                                          setSelectedCountry(widget.cubit);
                                          widget.cubit.updateState();

                                          print(c.city);
                                          AppUtil.mainNavigator(
                                            context,
                                            AddNewAddress(
                                              isQuest: widget.isQuest,
                                              isFromProfile:
                                                  widget.isFromProfile,
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
                                          widget.cubit.db.delete(c.code);
                                          widget.cubit.loadAddressLocal();
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
                      if (widget.cubit.dataLocal.length < 1)
                        AddNewAddressButtonWidget(
                          isFromProfile: widget.isFromProfile,
                          isQuest: widget.isQuest,
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
