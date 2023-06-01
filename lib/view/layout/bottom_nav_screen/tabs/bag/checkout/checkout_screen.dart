import 'dart:convert';

import 'package:ahshiaka/bloc/layout_cubit/bottom_nav_cubit.dart';
import 'package:ahshiaka/bloc/layout_cubit/categories_cubit/categories_cubit.dart';
import 'package:ahshiaka/bloc/profile_cubit/profile_cubit.dart';
import 'package:ahshiaka/shared/cash_helper.dart';
import 'package:ahshiaka/view/layout/bottom_nav_screen/bottom_nav_tabs_screen.dart';
import 'package:ahshiaka/view/layout/bottom_nav_screen/tabs/bag/checkout/payment/Webview.dart';
import 'package:ahshiaka/view/layout/bottom_nav_screen/tabs/bag/checkout/payment/saved_credit_card.dart';
import 'package:ahshiaka/view/layout/bottom_nav_screen/tabs/profile/my_orders/my_orders_screen.dart';
import 'package:amazon_payfort/amazon_payfort.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ahshiaka/shared/CheckNetwork.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../../../shared/components.dart';
import '../../../../../../../utilities/app_ui.dart';
import '../../../../../../../utilities/app_util.dart';
import '../../../../../../bloc/layout_cubit/checkout_cubit/checkout_cubit.dart';
import '../../../../../../bloc/layout_cubit/checkout_cubit/checkout_state.dart';
import 'address/addresses_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  Map selectedCustomizations = {};

  String email = "";
  getEmail() async {
    await ProfileCubit.get(context).fetchCustomer();
    email = ProfileCubit.get(context).email.text;
    print(email);
    print(
        "idddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd");
    if (email != null) {
      final cubit = CheckoutCubit.get(context);
      cubit.selectedAddress == null;
      setState(() {});
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ProfileCubit.get(context).fetchCustomer();
    getEmail();
    getSelectedCustomizations();
    // CheckoutCubit.get(context).fetchFreeShippingMethods();
  }

  Future<void> getSelectedCustomizations() async {
    final catCubit = CategoriesCubit.get(context);
    if (catCubit.selectedCustomizations.isNotEmpty) {
      selectedCustomizations = catCubit.selectedCustomizations;
    } else {
      final data =
          await CashHelper.getSavedString("selectedCustomizations", "");
      selectedCustomizations = jsonDecode(data);
    }
    print('test $selectedCustomizations}');
  }

  @override
  Widget build(BuildContext context) {
    final cubit = CheckoutCubit.get(context);
    final catCubit = CategoriesCubit.get(context);

    return CheckNetwork(
      child: BlocBuilder<CheckoutCubit, CheckoutState>(
          buildWhen: (_, state) => state is CheckoutChangeState,
          builder: (context, state) {
            if (cubit.cartList.isEmpty) {
              return Scaffold(
                backgroundColor: AppUI.backgroundColor,
                body: Column(
                  children: [
                    CustomAppBar(
                      title: "checkout".tr(),
                      onBack: () {
                        // AppUtil.mainNavigator(context, BagScreen());
                        BottomNavCubit.get(context).setCurrentIndex(2);
                        AppUtil.removeUntilNavigator(
                            context, const BottomNavTabsScreen());
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset("${AppUI.imgPath}emptyBag.png",
                              height: 200),
                          const SizedBox(
                            height: 50,
                            width: double.infinity,
                          ),
                          CustomText(
                            text: "noProductsFound".tr(),
                            fontSize: 18,
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          CustomText(
                            text: "shoppingInOurApp".tr(),
                            textAlign: TextAlign.center,
                            color: AppUI.iconColor,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Scaffold(
                backgroundColor: AppUI.backgroundColor,
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomAppBar(
                        title: "checkout".tr(),
                        onBack: () {
                          // AppUtil.mainNavigator(context, BagScreen());
                          BottomNavCubit.get(context).setCurrentIndex(2);
                          AppUtil.removeUntilNavigator(
                              context, const BottomNavTabsScreen());
                        },
                      ),

                      /*   Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    CustomText(text: "yourCart".tr(),fontWeight: FontWeight.w500,),
                  ],
                ),
              ),*/

                      BlocBuilder<CheckoutCubit, CheckoutState>(
                          buildWhen: (_, state) => state is CheckoutChangeState,
                          builder: (context, state) {
                            return Container(
                                color: AppUI.whiteColor,
                                padding: const EdgeInsets.all(7),
                                child: ListView(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: List.generate(cubit.cartList.length,
                                      (index) {
                                    return Column(
                                      children: [
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: CachedNetworkImage(
                                                    imageUrl: cubit
                                                                .cartList[index]
                                                                .image !=
                                                            null
                                                        ? cubit.cartList[index]
                                                            .image!['src']!
                                                        : cubit.cartList[index]
                                                                        .images !=
                                                                    null &&
                                                                cubit
                                                                    .cartList[
                                                                        index]
                                                                    .images!
                                                                    .isNotEmpty
                                                            ? cubit
                                                                .cartList[index]
                                                                .images![0]
                                                                .src!
                                                            : "",
                                                    placeholder:
                                                        (context, url) => Stack(
                                                      children: [
                                                        Image.asset(
                                                          "${AppUI.imgPath}product_background.png",
                                                          height: 150,
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ],
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Stack(
                                                      children: [
                                                        Image.asset(
                                                          "${AppUI.imgPath}product_background.png",
                                                          height: 170,
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 7,
                                                ),
                                                Expanded(
                                                  flex: 5,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 3),
                                                    child: Row(
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            // if(cubit.cartModel!.items![index].title!=null)
                                                            Container(
                                                                width: AppUtil
                                                                        .responsiveWidth(
                                                                            context) *
                                                                    0.6,
                                                                child:
                                                                    CustomText(
                                                                  text: cubit
                                                                      .cartList[
                                                                          index]
                                                                      .name,
                                                                  color: AppUI
                                                                      .blueColor,
                                                                )),
                                                            // CustomText(text: cubit.cartModel!.items![index].name!.length<3?cubit.cartModel!.items![index].name:"${cubit.cartModel!.items![index].name!.substring(3,cubit.cartModel!.items![index].name!.length>29?24:cubit.cartModel!.items![index].name!.length-5)}...",color: AppUI.blackColor,),
                                                            CustomText(
                                                              text:
                                                                  "${cubit.cartList[index].price} SAR",
                                                              color: cubit
                                                                          .cartList[
                                                                              index]
                                                                          .salePrice ==
                                                                      ""
                                                                  ? AppUI
                                                                      .mainColor
                                                                  : AppUI
                                                                      .orangeColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                            if (cubit
                                                                        .cartList[
                                                                            index]
                                                                        .salePrice !=
                                                                    "" &&
                                                                cubit
                                                                        .cartList[
                                                                            index]
                                                                        .salePrice !=
                                                                    null)
                                                              CustomText(
                                                                text:
                                                                    "${cubit.cartList[index].salePrice} SAR",
                                                                color: AppUI
                                                                    .iconColor,
                                                                textDecoration:
                                                                    TextDecoration
                                                                        .lineThrough,
                                                                fontSize: 12,
                                                              ),
                                                            // if(cubit.cartList[index].attributes!.isNotEmpty)
                                                            //   Row(
                                                            //     children: [
                                                            //       CustomText(text: cubit.cartList[index].attributes![0].name,color: AppUI.iconColor,),
                                                            //       const SizedBox(width: 10,),
                                                            //       CustomText(text:  cubit.cartList[index].attributes![0].option,color: AppUI.blackColor,),
                                                            //     ],
                                                            //   ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            if (cubit
                                                                        .cartList[
                                                                            index]
                                                                        .attributes !=
                                                                    null &&
                                                                cubit
                                                                    .cartList[
                                                                        index]
                                                                    .attributes!
                                                                    .isNotEmpty &&
                                                                selectedCustomizations
                                                                    .isNotEmpty)
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  if (selectedCustomizations[cubit
                                                                              .cartList[
                                                                                  index]
                                                                              .mainProductId
                                                                              .toString()] !=
                                                                          null &&
                                                                      selectedCustomizations[cubit
                                                                              .cartList[index]
                                                                              .mainProductId
                                                                              .toString()]
                                                                          .values
                                                                          .first
                                                                          .isNotEmpty)
                                                                    Row(
                                                                      children: [
                                                                        CustomText(
                                                                          text: selectedCustomizations[cubit.cartList[index].mainProductId.toString()].keys.first +
                                                                              ':',
                                                                          color:
                                                                              AppUI.blackColor,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              4,
                                                                        ),
                                                                        CustomText(
                                                                          text: selectedCustomizations[cubit.cartList[index].mainProductId.toString()]
                                                                              .values
                                                                              .first,
                                                                          color:
                                                                              AppUI.iconColor,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  if (selectedCustomizations[cubit
                                                                              .cartList[
                                                                                  index]
                                                                              .mainProductId
                                                                              .toString()] !=
                                                                          null &&
                                                                      selectedCustomizations[cubit
                                                                              .cartList[index]
                                                                              .mainProductId
                                                                              .toString()]
                                                                          .values
                                                                          .last
                                                                          .isNotEmpty)
                                                                    Row(
                                                                      children: [
                                                                        CustomText(
                                                                          text: selectedCustomizations[cubit.cartList[index].mainProductId.toString()].keys.last +
                                                                              ':',
                                                                          color:
                                                                              AppUI.blackColor,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              4,
                                                                        ),
                                                                        CustomText(
                                                                          text: selectedCustomizations[cubit.cartList[index].mainProductId.toString()]
                                                                              .values
                                                                              .last,
                                                                          color:
                                                                              AppUI.iconColor,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                ],
                                                              ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Row(
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {
                                                                    if (cubit.qty[
                                                                            index] !=
                                                                        1) {
                                                                      cubit.changeQuantity(
                                                                          cubit.cartList[index].mainProductId != null
                                                                              ? cubit.cartList[index].mainProductId
                                                                              : cubit.cartList[index].id.toString(),
                                                                          --cubit.qty[index],
                                                                          "decrement",
                                                                          context);
                                                                    }
                                                                  },
                                                                  child: CircleAvatar(
                                                                      radius: 13,
                                                                      backgroundColor: AppUI.greyColor,
                                                                      child: Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(1.0),
                                                                        child: CircleAvatar(
                                                                            backgroundColor: AppUI.whiteColor,
                                                                            child: const CustomText(
                                                                              text: "-",
                                                                              fontSize: 18,
                                                                            )),
                                                                      )),
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                CustomText(
                                                                  text:
                                                                      "${cubit.qty[index]}",
                                                                  fontSize: 22,
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    cubit.changeQuantity(
                                                                        cubit.cartList[index].mainProductId !=
                                                                                null
                                                                            ? cubit.cartList[index].mainProductId
                                                                            : cubit.cartList[index].id.toString(),
                                                                        ++cubit.qty[index],
                                                                        "increment",
                                                                        context);
                                                                  },
                                                                  child: CircleAvatar(
                                                                      radius: 13,
                                                                      backgroundColor: AppUI.greyColor,
                                                                      child: Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(1.0),
                                                                        child: CircleAvatar(
                                                                            backgroundColor: AppUI.whiteColor,
                                                                            child: const CustomText(
                                                                              text: "+",
                                                                              fontSize: 18,
                                                                            )),
                                                                      )),
                                                                ),
                                                                SizedBox(
                                                                  width: AppUtil
                                                                          .responsiveWidth(
                                                                              context) *
                                                                      0.34,
                                                                ),
                                                                InkWell(
                                                                    onTap:
                                                                        () async {
                                                                      cubit.removeCartItemItem(
                                                                          cubit.cartList[
                                                                              index],
                                                                          index,
                                                                          context);
                                                                      //
                                                                      catCubit.selectedCustomizations.remove(cubit
                                                                          .cartList[
                                                                              index]
                                                                          .mainProductId
                                                                          .toString());
                                                                      //
                                                                      await CashHelper.setSavedString(
                                                                          "selectedCustomizations",
                                                                          jsonEncode(
                                                                              catCubit.selectedCustomizations));
                                                                      print(
                                                                          'test delete ${catCubit.selectedCustomizations}');
                                                                    },
                                                                    child: Image
                                                                        .asset(
                                                                            "${AppUI.imgPath}trash.png")),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  }),
                                ));
                          }),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Row(
                          children: [
                            CustomText(
                              text: "shippingAddress".tr(),
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                      ),
                      BlocBuilder<CheckoutCubit, CheckoutState>(
                          buildWhen: (_, state) =>
                              state is AddressesState ||
                              state is CheckoutChangeState,
                          builder: (context, state) {
                            if (cubit.selectedAddress == null) {
                              return Container(
                                color: AppUI.whiteColor,
                                padding: const EdgeInsets.all(8),
                                child: InkWell(
                                  onTap: () {
                                    AppUtil.mainNavigator(
                                        context,
                                        AddressesScreen(
                                          isquest: email == "",
                                        ));
                                  },
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                          "${AppUI.iconPath}location.svg"),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      CustomText(
                                        text: "chooseShippingAddress".tr(),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      const Spacer(),
                                      IconButton(
                                          onPressed: () {
                                            AppUtil.mainNavigator(
                                                context,
                                                AddressesScreen(
                                                  isquest: email == "",
                                                ));
                                          },
                                          icon: const Icon(
                                            Icons.arrow_forward_ios,
                                            size: 16,
                                          ))
                                    ],
                                  ),
                                ),
                              );
                            }

                            return Container(
                              color: AppUI.whiteColor,
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                          "${AppUI.iconPath}location.svg"),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      CustomText(
                                        text: "addressDetails".tr(),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      const Spacer(),
                                      InkWell(
                                          onTap: () {
                                            AppUtil.mainNavigator(
                                                context,
                                                AddressesScreen(
                                                  isquest: email == "",
                                                ));
                                          },
                                          child: CustomText(
                                            text: "change".tr(),
                                            color: AppUI.mainColor,
                                            fontSize: 12,
                                          ))
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  CustomText(
                                    text: cubit.selectedAddress!.address,
                                    color: AppUI.blackColor,
                                    fontSize: 12,
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  CustomText(
                                    text: cubit.selectedAddress!.address2,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w100,
                                  ),
                                ],
                              ),
                            );
                          }),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Row(
                          children: [
                            CustomText(
                              text: "paymentMethod".tr(),
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
                            InkWell(
                              onTap: () {
                                // AppUtil.mainNavigator(context, SavedCreditCard());
                              },
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                      "${AppUI.iconPath}credit.svg"),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  CustomText(
                                    text: "choosePaymentMethods".tr(),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  // const Spacer(),
                                  // IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward_ios,size: 16,))
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            BlocBuilder<CheckoutCubit, CheckoutState>(
                                buildWhen: (_, state) =>
                                    state is SelectedPaymentState,
                                builder: (context, snapshot) {
                                  return SizedBox(
                                    height: 50,
                                    child: ListView(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      children: List.generate(
                                          cubit.paymentGetaway.length, (index) {
                                        return Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                print(cubit
                                                    .paymentGetaway[index].id);
                                                print(cubit
                                                    .paymentGetaway[index]
                                                    .title);
                                                print(
                                                    "***********************************************");
                                                if (cubit
                                                        .selectedPaymentGetaways !=
                                                    cubit.paymentGetaway[
                                                        index]) {
                                                  cubit.selectedPaymentGetaways =
                                                      cubit.paymentGetaway[
                                                          index];
                                                } else {
                                                  cubit.selectedPaymentGetaways =
                                                      null;
                                                }
                                                cubit.emit(
                                                    SelectedPaymentState());
                                              },
                                              child: Container(
                                                height: 46,
                                                width: 80,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8,
                                                        horizontal: 15),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: cubit.selectedPaymentGetaways !=
                                                                null
                                                            ? cubit.selectedPaymentGetaways!
                                                                        .id ==
                                                                    cubit
                                                                        .paymentGetaway[
                                                                            index]
                                                                        .id
                                                                ? AppUI
                                                                    .mainColor
                                                                : AppUI
                                                                    .backgroundColor
                                                            : AppUI
                                                                .backgroundColor),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                alignment: Alignment.center,
                                                // child: Image.asset(
                                                //     "${AppUI.imgPath}${index == 0 ? "cash.png" : index == 1 ? "master_card.png" : index == 2 ? "tabby.png" : "apple.png"}"),
                                                child: Image.asset(
                                                    "${AppUI.imgPath}${index == 0 ? "cash.png" : index == 1 ? "master_card.png" : "tabby.png"}"),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        );
                                      }),
                                    ),
                                  );
                                })
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Row(
                          children: [
                            CustomText(
                              text: "shippingMethod".tr(),
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
                            InkWell(
                              onTap: () {
                                AppUtil.mainNavigator(
                                    context, SavedCreditCard());
                              },
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                      "${AppUI.iconPath}credit.svg"),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  CustomText(
                                    text: "chooseShippingMethods".tr(),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  // const Spacer(),
                                  // IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_forward_ios,size: 16,))
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            SizedBox(
                              height: 70,
                              child: BlocBuilder<CheckoutCubit, CheckoutState>(
                                  buildWhen: (_, state) =>
                                      state is SelectedShippingState ||
                                      state is CheckoutChangeState,
                                  builder: (context, state) {
                                    return ListView(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      children: List.generate(
                                          cubit.shippingMethods.length,
                                          (index) {
                                        if (cubit.total >
                                                int.parse(
                                                    cubit.freeShippingMethods[
                                                        'min_amount']) &&
                                            cubit.shippingMethods[index]
                                                    .methodId ==
                                                "flat_rate") {
                                          return const SizedBox();
                                        }

                                        if (cubit.flatRateApply &&
                                            cubit.shippingMethods[index]
                                                    .methodId !=
                                                "flat_rate") {
                                          return const SizedBox();
                                        }

                                        if (cubit.total <
                                                int.parse(
                                                    cubit.freeShippingMethods[
                                                        'min_amount']) &&
                                            cubit.shippingMethods[index]
                                                    .methodId !=
                                                "flat_rate") {
                                          return const SizedBox();
                                        }
                                        cubit.selectedShippingMethods =
                                            cubit.shippingMethods[index];

                                        return Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                // if(cubit.selectedShippingMethods != cubit.shippingMethods[index]) {
                                                print(cubit
                                                    .shippingMethods[index].id);
                                                print(cubit
                                                    .shippingMethods[index]
                                                    .title);
                                                print(
                                                    "*************************************************");
                                                cubit.selectedShippingMethods =
                                                    cubit
                                                        .shippingMethods[index];
                                                // }else{
                                                //   cubit.selectedShippingMethods = null;
                                                // }
                                                cubit.emit(
                                                    SelectedShippingState());
                                              },
                                              child: Container(
                                                height: 70,
                                                padding:
                                                    const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: cubit.selectedShippingMethods !=
                                                                null
                                                            ? cubit.selectedShippingMethods!
                                                                        .id ==
                                                                    cubit
                                                                        .shippingMethods[
                                                                            index]
                                                                        .id
                                                                ? AppUI
                                                                    .mainColor
                                                                : AppUI
                                                                    .backgroundColor
                                                            : AppUI
                                                                .backgroundColor),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                alignment: Alignment.center,
                                                child: Column(
                                                  children: [
                                                    CustomText(
                                                        text: /*cubit.shippingMethods[index].title*/
                                                            "flat_rate".tr()),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    CustomText(
                                                      text: index == 0
                                                          ? "${cubit.shippingMethods[index].settings!.cost!.value} SAR"
                                                          : "0.0 SAR",
                                                      fontSize: 11,
                                                      color: AppUI.greyColor,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            )
                                          ],
                                        );
                                      }),
                                    );
                                  }),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      BlocBuilder<CheckoutCubit, CheckoutState>(
                          buildWhen: (_, state) =>
                              state is SelectedShippingState ||
                              state is CheckoutChangeState ||
                              state is SelectedPaymentState,
                          builder: (context, state) {
                            return Container(
                              color: AppUI.whiteColor,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        CustomText(text: "subTotal".tr()),
                                        const Spacer(),
                                        CustomText(
                                            text:
                                                "${(cubit.total - AppUtil.calculateTax(cubit.total)[0]).toStringAsFixed(2)} SAR"),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        CustomText(text: "shipping".tr()),
                                        const Spacer(),
                                        CustomText(
                                            text: cubit.selectedShippingMethods !=
                                                    null
                                                ? cubit.selectedShippingMethods!
                                                            .methodId ==
                                                        "flat_rate"
                                                    ? "${cubit.selectedShippingMethods!.settings!.cost!.value} SAR"
                                                    : "0 SAR"
                                                : ''),
                                      ],
                                    ),
                                    if (cubit.selectedPaymentGetaways != null &&
                                        cubit.selectedPaymentGetaways!.id ==
                                            "cod")
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    if (cubit.selectedPaymentGetaways != null &&
                                        cubit.selectedPaymentGetaways!.id ==
                                            "cod")
                                      Row(
                                        children: [
                                          CustomText(text: "paymentFees".tr()),
                                          const Spacer(),
                                          CustomText(
                                              text: cubit.selectedPaymentGetaways !=
                                                          null &&
                                                      cubit.selectedPaymentGetaways!
                                                              .id ==
                                                          "cod"
                                                  ? "5.0 SAR"
                                                  : "0 SAR"),
                                        ],
                                      ),
                                    if (cubit.couponApplied)
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    if (cubit.couponApplied)
                                      Row(
                                        children: [
                                          CustomText(text: "couponValue".tr()),
                                          const Spacer(),
                                          CustomText(
                                              text: "${cubit.couponValue} SAR"),
                                        ],
                                      ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        CustomText(text: "TAX".tr()),
                                        const Spacer(),
                                        CustomText(
                                            text:
                                                "${AppUtil.calculateTax(cubit.total + (cubit.selectedPaymentGetaways != null && cubit.selectedPaymentGetaways!.id == "cod" ? 5.75 : 0) + ((cubit.selectedShippingMethods != null ? cubit.selectedShippingMethods!.methodId == "flat_rate" ? cubit.total + double.parse(cubit.selectedShippingMethods!.settings!.cost!.value!) : 0 : 0)))[0]} SAR"),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        CustomText(text: "total".tr()),
                                        const Spacer(),
                                        CustomText(
                                            text:
                                                "${cubit.selectedPaymentGetaways != null && cubit.selectedPaymentGetaways!.id == "cod" ? (cubit.selectedShippingMethods != null ? cubit.selectedShippingMethods!.methodId == "flat_rate" ? cubit.total + double.parse(cubit.selectedShippingMethods!.settings!.cost!.value!) : cubit.total : cubit.total) + 5.75 : (cubit.selectedShippingMethods != null ? cubit.selectedShippingMethods!.methodId == "flat_rate" ? cubit.total + double.parse(cubit.selectedShippingMethods!.settings!.cost!.value!) : cubit.total : cubit.total)} SAR"),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
                bottomNavigationBar: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlocBuilder<CheckoutCubit, CheckoutState>(
                      buildWhen: (_, state) =>
                          state is CheckoutLoadingState ||
                          state is CheckoutLoadedState ||
                          state is CheckoutErrorState,
                      builder: (context, state) {
                        if (state is CheckoutLoadingState) {
                          return const SizedBox(
                              height: 80, child: LoadingWidget());
                        }
                        return CustomButton(
                          text: "completeOrder".tr(),
                          onPressed: () async {
                            if (cubit.selectedAddress == null) {
                              AppUtil.errorToast(
                                  context, "pleaseSelectShippingAddress".tr());
                              return;
                            }
                            if (cubit.selectedPaymentGetaways == null) {
                              AppUtil.errorToast(
                                  context, "pleaseSelectPaymentMethod".tr());
                              return;
                            }
                            if (cubit.selectedShippingMethods == null) {
                              AppUtil.errorToast(
                                  context, "pleaseSelectShippingMethod".tr());
                              return;
                            } else if (cubit.selectedPaymentGetaways!.id ==
                                "tabby_installments") {
                              String url =
                                  "https://alshiaka.com/wp-json/payment/mobileapp/tabbyintegrate?consumer_key=ck_0aa636e54b329a08b5328b7d32ffe86f3efd8cbe&consumer_secret=cs_7e2c98933686d9859a318365364d0c7c085e557b&lang=en&";
                              url +=
                                  "billing[first_name]=${cubit.selectedAddress!.fullName}&billing[last_name]=${cubit.selectedAddress!.fullName}&";
                              url +=
                                  "billing[address_1]=${cubit.selectedAddress!.country}&billing[address_2]=${cubit.selectedAddress!.address ?? ""}&";
                              url +=
                                  "billing[state]=${cubit.selectedAddress!.state}&billing[city]=${cubit.selectedAddress!.city}&billing[email]=${cubit.selectedAddress!.email}&billing[phone]=${cubit.selectedAddress!.phoneNumber}";
                              int i = 0;
                              for (var element in cubit.cartList) {
                                // url +=
                                //     "&line_items[$i][product_id]=${element.id}&line_items[$i][quantity]=${element.qty}";
                                url +=
                                    "&line_items[$i][product_id]=${element.mainProductId != null ? element.mainProductId! : element.id!}&line_items[$i][quantity]=${element.qty}";
                              }
                              AppUtil.mainNavigator(
                                  context,
                                  CustomWebview(
                                    url: url,
                                    type: "taby",
                                    orderId: '',
                                  ));
                            }
                            // else if (cubit.selectedPaymentGetaways!.id ==
                            //     "apple_pay") {
                            //   Map<String, dynamic> response = await cubit
                            //       .applePayCreateOrder(context, "pending");
                            //   print(cubit.selectedPaymentGetaways!.id);
                            //   print('lol $response');
                            //   print(response['id']);
                            //   print(
                            //       "sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss");
                            //   if (response['id'] != null) {
                            //     applePay(double.parse(response['total']));
                            //     cubit.emit(CheckoutLoadedState());
                            //   }
                            // }
                            else {
                              Map<String, dynamic> response =
                                  await cubit.createOrder(context);
                              print(cubit.selectedPaymentGetaways!.id);
                              print('lol $response');
                              print(response['id']);
                              print(
                                  "sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss");
                              if (response['id'] != null) {
                                var responseId = response['id'];
                                if (cubit.selectedPaymentGetaways!.id ==
                                    "aps_cc") {
                                  if (!mounted) return;
                                  AppUtil.mainNavigator(
                                      context,
                                      CustomWebview(
                                        url:
                                            'https://alshiaka.com/wp-json/payment/urls/get?order_id=$responseId&integrate_type=aps_cc&consumer_key=ck_0aa636e54b329a08b5328b7d32ffe86f3efd8cbe&consumer_secret=cs_7e2c98933686d9859a318365364d0c7c085e557b&lang=en',
                                        type: "",
                                        orderId: response['id'].toString(),
                                      ));
                                } else if (cubit.selectedPaymentGetaways!.id ==
                                    "cod") {
                                  await cubit.fetchOrders(context);
                                  cubit.emit(CheckoutLoadedState());
                                  if (!mounted) return;
                                  AppUtil.mainNavigator(
                                      context, const MyOrdersScreen());
                                }
                              }
                            }
                          },
                        );
                      }),
                ),
              );
            }
          }),
    );
  }

  // applePay(double amount) async {
  //   print('amount $amount');
  //   final cubit = CheckoutCubit.get(context);
  //   print(cubit.selectedAddress!.fullName! +
  //       ' ' +
  //       cubit.selectedAddress!.surName!);
  //   print(cubit.selectedAddress!.email!);
  //   final isInitialized = await AmazonPayfort.initialize(
  //     PayFortOptions(
  //       environment: FortEnvironment.production,
  //     ),
  //   );
  //   print('is initialized: $isInitialized');
  //   if (isInitialized) {
  //     await AmazonPayfort.instance.callPayFortForApplePay(
  //       request: FortRequest(
  //         amount: amount,
  //         customerName: cubit.selectedAddress!.fullName! +
  //             ' ' +
  //             cubit.selectedAddress!.surName!,
  //         customerEmail: cubit.selectedAddress!.email!,
  //         orderDescription: 'orderDescription',
  //         sdkToken: 'sdkToken',
  //         customerIp: 'customerIp',
  //         merchantReference: 'merchantReference',
  //         currency: 'SAR',
  //       ),
  //       countryIsoCode: 'SA',
  //       applePayMerchantId: 'merchant.com.Digital-Partner.ahshiaka',
  //       callback: ApplePayResultCallback(
  //         onSucceeded: (result) {
  //           print('success $result');
  //           cubit.applePayCreateOrder(context, "processing");
  //         },
  //         onFailed: (error) {
  //           print('error $error');
  //         },
  //       ),
  //     );
  //   }
  // }
}
