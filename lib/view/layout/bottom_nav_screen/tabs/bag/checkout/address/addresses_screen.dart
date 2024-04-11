import 'package:ahshiaka/bloc/layout_cubit/checkout_cubit/checkout_cubit.dart';
import 'package:ahshiaka/bloc/layout_cubit/checkout_cubit/checkout_state.dart';
import 'package:ahshiaka/models/AddressLocalModel.dart';
import 'package:ahshiaka/view/layout/bottom_nav_screen/tabs/bag/checkout/address/add_new_address/add_new_address.dart';
import 'package:ahshiaka/view/layout/bottom_nav_screen/tabs/bag/checkout/checkout_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../../../../../shared/components.dart';
import '../../../../../../../../utilities/app_ui.dart';
import '../../../../../../../../utilities/app_util.dart';
import '../../../../../../../models/checkout/addresses_model.dart';
import '../../../../../../../models/checkout/shipping_model.dart';
import '../../../../../../../shared/cash_helper.dart';
import '../../../../../../../utilities/dbHelper.dart';
import 'add_new_address_old.dart';
import 'package:ahshiaka/shared/CheckNetwork.dart';

class AddressesScreen extends StatefulWidget {
  bool isquest;
  final bool isFromProfile;
  AddressesScreen({
    Key? key,
    required this.isquest,
    this.isFromProfile = false,
  }) : super(key: key);

  @override
  _AddressesScreenState createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  loadData() {
    final cubit = CheckoutCubit.get(context);
    print(widget.isquest);
    print(
        "*******************************************************************************************");
    if (widget.isquest) {
      print(
          "questttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt");

      cubit.loadaddresslocal();
    } else {
      cubit.fetchAddresses();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = CheckoutCubit.get(context);
    return CheckNetwork(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            CustomAppBar(
              title: "addresses".tr(),
              onBack: () {
                if (widget.isFromProfile) {
                  Navigator.of(context).pop();
                } else {
                  AppUtil.mainNavigator(context, CheckoutScreen());
                }
              },
            ),
            BlocBuilder<CheckoutCubit, CheckoutState>(
                buildWhen: (_, state) => state is AddressesState,
                builder: (context, state) {
                  return widget.isquest
                      ? Expanded(
                          child: cubit.dataLocal.length == 0
                              ? Center(
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
                                                isquest: widget.isquest,
                                              ));
                                        },
                                        child: Container(
                                            // width: MediaQuery.of(context)
                                            //         .size
                                            //         .width *
                                            //     .45,
                                            // height: MediaQuery.of(context)
                                            //         .size
                                            //         .height *
                                            //     .065,
                                            width: 45,
                                            height: 45,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: AppUI.alshiakaColor),
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: 25,
                                            )))
                                  ],
                                ))
                              : ListView(
                                  shrinkWrap: true,
                                  children: List.generate(
                                      cubit.dataLocal.length, (index) {
                                    AddressMedelLocal c =
                                        AddressMedelLocal.fromMap(
                                            cubit.dataLocal[index]);
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (widget.isFromProfile) {
                                              print('from profile');
                                            } else {
                                              cubit.selectedAddress =
                                                  AddressesModel(
                                                      fullName: c.firstname,
                                                      surName: c.lastname,
                                                      phoneNumber: c.phone,
                                                      email: c.email,
                                                      address:
                                                          c.address.toString(),
                                                      state: c.state,
                                                      address2:
                                                          c.address.toString(),
                                                      city: c.city,
                                                      postCode: c.code,
                                                      country: c.region,
                                                      defaultAddress: index == 0
                                                          ? true
                                                          : false);

                                              cubit.emit(AddressesState());
                                              Navigator.pop(context);
                                              // AppUtil.mainNavigator(
                                              //     context, CheckoutScreen());
                                            }
                                          },
                                          child: Container(
                                            color: AppUI.whiteColor,
                                            width: double.infinity,
                                            padding: const EdgeInsets.all(16),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 3,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      CustomText(
                                                        text: index == 0
                                                            ? "primaryAddress"
                                                                .tr()
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
                                                        text: c.address
                                                            .toString(),
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w100,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                    child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    InkWell(
                                                        onTap: () {
                                                          print(c.city);
                                                          AppUtil.mainNavigator(
                                                            context,
                                                            AddNewAddress(
                                                              isquest: widget
                                                                  .isquest,
                                                              address: Address0(
                                                                shippingFirstName:
                                                                    c.firstname,
                                                                shippingLastName:
                                                                    c.lastname,
                                                                shippingCity:
                                                                    c.city,
                                                                shippingAddress1: c
                                                                    .address
                                                                    .toString(),
                                                                shippingEmail:
                                                                    c.email,
                                                                shippingPhone:
                                                                    c.phone,
                                                                shippingPostcode:
                                                                    c.code,
                                                                shippingCountry:
                                                                    c.region,
                                                                shippingState:
                                                                    c.state,
                                                              ),
                                                              //
                                                              addressKey: index
                                                                  .toString(),
                                                            ),
                                                          );
                                                        },
                                                        child: Icon(
                                                          Icons.edit,
                                                          color:
                                                              AppUI.greyColor,
                                                          size: 19,
                                                        )),
                                                    const SizedBox(
                                                      width: 15,
                                                    ),
                                                    GestureDetector(
                                                        onTap: () async {
                                                          AppUtil.dialog2(
                                                              context, "", [
                                                            const LoadingWidget(),
                                                            const SizedBox(
                                                              height: 30,
                                                            )
                                                          ]);
                                                          print(c.code);
                                                          print(
                                                              "sssssssssssssssssssssssssssssssssssssssss");
                                                          cubit.db
                                                              .delete(c.code);
                                                          cubit
                                                              .loadaddresslocal();
                                                          setState(() {});
                                                          Navigator.of(context,
                                                                  rootNavigator:
                                                                      true)
                                                              .pop();
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Icon(
                                                            Icons.delete,
                                                            color:
                                                                AppUI.greyColor,
                                                            size: 19,
                                                          ),
                                                        )),
                                                  ],
                                                )),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        cubit.dataLocal.length - 1 == index
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  GestureDetector(
                                                      onTap: () {
                                                        AppUtil.mainNavigator(
                                                            context,
                                                            AddNewAddress(
                                                              isquest: widget
                                                                  .isquest,
                                                            ));
                                                      },
                                                      child: Container(
                                                          // width: MediaQuery.of(
                                                          //             context)
                                                          //         .size
                                                          //         .width *
                                                          //     .45,
                                                          // height: MediaQuery.of(
                                                          //             context)
                                                          //         .size
                                                          //         .height *
                                                          //     .065,
                                                          width: 45,
                                                          height: 45,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: AppUI
                                                                  .alshiakaColor),
                                                          child: Icon(
                                                            Icons.add,
                                                            color: Colors.white,
                                                            size: 25,
                                                          )))
                                                ],
                                              )
                                            : SizedBox()
                                      ],
                                    );
                                  }),
                                ),
                        )
                      : Expanded(
                          child: cubit.addresses == null ||
                                  cubit.addresses!.shipping == null ||
                                  cubit.addresses!.shipping!.address0 == null ||
                                  cubit.addresses!.shipping!.address0!.isEmpty
                              ? Center(
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
                                                isquest: widget.isquest,
                                              ));
                                        },
                                        child: Container(
                                            // width: MediaQuery.of(context)
                                            //         .size
                                            //         .width *
                                            //     .45,
                                            // height: MediaQuery.of(context)
                                            //         .size
                                            //         .height *
                                            //     .065,
                                            width: 45,
                                            height: 45,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: AppUI.alshiakaColor),
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: 25,
                                            )))
                                  ],
                                ))
                              : ListView(
                                  shrinkWrap: true,
                                  children: List.generate(
                                      cubit.addresses!.shipping!.address0!
                                          .length, (index) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (widget.isFromProfile) {
                                              print('from profile');
                                            } else {
                                              cubit.selectedAddress =
                                                  AddressesModel(
                                                      fullName: cubit
                                                          .addresses!
                                                          .shipping!
                                                          .address0![index]
                                                          .shippingFirstName,
                                                      surName: cubit
                                                          .addresses!
                                                          .shipping!
                                                          .address0![index]
                                                          .shippingLastName,
                                                      phoneNumber: cubit
                                                          .addresses!
                                                          .shipping!
                                                          .address0![index]
                                                          .shippingPhone,
                                                      email: cubit
                                                          .addresses!
                                                          .shipping!
                                                          .address0![index]
                                                          .shippingEmail,
                                                      address: cubit
                                                          .addresses!
                                                          .shipping!
                                                          .address0![index]
                                                          .shippingAddress1,
                                                      state: cubit
                                                          .addresses!
                                                          .shipping!
                                                          .address0![index]
                                                          .shippingState,
                                                      address2: cubit
                                                          .addresses!
                                                          .shipping!
                                                          .address0![index]
                                                          .shippingAddress2,
                                                      city: cubit
                                                          .addresses!
                                                          .shipping!
                                                          .address0![index]
                                                          .shippingCity,
                                                      postCode: cubit
                                                          .addresses!
                                                          .shipping!
                                                          .address0![index]
                                                          .shippingPostcode,
                                                      country: cubit
                                                          .addresses!
                                                          .shipping!
                                                          .address0![index]
                                                          .shippingCountry,
                                                      defaultAddress: index == 0
                                                          ? true
                                                          : false);

                                              cubit.emit(AddressesState());
                                              print(cubit
                                                  .selectedAddress!.email!);
                                              print(
                                                  "---------------------------------------------");
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: Container(
                                            color: AppUI.whiteColor,
                                            width: double.infinity,
                                            padding: const EdgeInsets.all(16),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 3,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      CustomText(
                                                        text: index == 0
                                                            ? "primaryAddress"
                                                                .tr()
                                                            : "",
                                                        color: AppUI.mainColor,
                                                        fontSize: 12,
                                                      ),
                                                      const SizedBox(
                                                        height: 6,
                                                      ),
                                                      CustomText(
                                                        text: cubit
                                                            .addresses!
                                                            .shipping!
                                                            .address0![index]
                                                            .shippingCity,
                                                        color: AppUI.blackColor,
                                                        fontSize: 12,
                                                      ),
                                                      const SizedBox(
                                                        height: 6,
                                                      ),
                                                      CustomText(
                                                        text: cubit
                                                            .addresses!
                                                            .shipping!
                                                            .address0![index]
                                                            .shippingAddress1,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w100,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                    child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    InkWell(
                                                        onTap: () {
                                                          AppUtil.mainNavigator(
                                                              context,
                                                              AddNewAddress(
                                                                address: cubit
                                                                    .addresses!
                                                                    .shipping!
                                                                    .address0![index],
                                                                addressKey: cubit
                                                                    .addresses!
                                                                    .shipping!
                                                                    .addressesKey![index],
                                                                isquest: widget
                                                                    .isquest,
                                                              ));
                                                        },
                                                        child: Icon(
                                                          Icons.edit,
                                                          color:
                                                              AppUI.greyColor,
                                                          size: 19,
                                                        )),
                                                    const SizedBox(
                                                      width: 15,
                                                    ),
                                                    InkWell(
                                                        onTap: () async {
                                                          AppUtil.dialog2(
                                                              context, "", [
                                                            const LoadingWidget(),
                                                            const SizedBox(
                                                              height: 30,
                                                            )
                                                          ]);
                                                          await cubit.deleteAddress(
                                                              "address_$index");
                                                          Navigator.of(context,
                                                                  rootNavigator:
                                                                      true)
                                                              .pop();
                                                        },
                                                        child: Icon(
                                                          Icons.delete,
                                                          color:
                                                              AppUI.greyColor,
                                                          size: 19,
                                                        )),
                                                  ],
                                                )),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        cubit.addresses!.shipping!.address0!
                                                        .length -
                                                    1 ==
                                                index
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  GestureDetector(
                                                      onTap: () {
                                                        AppUtil.mainNavigator(
                                                            context,
                                                            AddNewAddress(
                                                              isquest: widget
                                                                  .isquest,
                                                            ));
                                                      },
                                                      child: Container(
                                                          width: 45,
                                                          height: 45,
                                                          // width: MediaQuery.of(
                                                          //             context)
                                                          //         .size
                                                          //         .width *
                                                          //     .45,
                                                          // height: MediaQuery.of(
                                                          //             context)
                                                          //         .size
                                                          //         .height *
                                                          //     .065,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: AppUI
                                                                  .alshiakaColor),
                                                          child: Icon(
                                                            Icons.add,
                                                            color: Colors.white,
                                                            size: 25,
                                                          )))
                                                ],
                                              )
                                            : SizedBox()
                                      ],
                                    );
                                  }),
                                ),
                        );
                }),
          ],
        ),
      ),
    );
  }
}
