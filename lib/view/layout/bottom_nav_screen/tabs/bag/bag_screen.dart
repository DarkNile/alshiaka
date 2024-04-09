import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:ahshiaka/repository/checkout_repository.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:http/http.dart' as http;
import 'package:ahshiaka/bloc/layout_cubit/categories_cubit/categories_cubit.dart';
import 'package:ahshiaka/bloc/layout_cubit/categories_cubit/categories_states.dart';
import 'package:ahshiaka/bloc/layout_cubit/checkout_cubit/checkout_cubit.dart';
import 'package:ahshiaka/bloc/layout_cubit/checkout_cubit/checkout_state.dart';
import 'package:ahshiaka/shared/components.dart';
import 'package:ahshiaka/utilities/app_ui.dart';
import 'package:ahshiaka/utilities/app_util.dart';
import 'package:ahshiaka/view/layout/bottom_nav_screen/tabs/categories/products/product_details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toast/toast.dart';
import '../../../../../bloc/layout_cubit/bottom_nav_cubit.dart';
import '../../../../../bloc/profile_cubit/profile_cubit.dart';
import '../../../../../shared/cash_helper.dart';
import '../../bottom_nav_tabs_screen.dart';
import 'checkout/checkout_screen.dart';

class BagScreen extends StatefulWidget {
  const BagScreen({Key? key}) : super(key: key);

  @override
  _BagScreenState createState() => _BagScreenState();
}

class _BagScreenState extends State<BagScreen> {
  Map selectedCustomizations = {};
  bool isCouponActivated = false;
  bool isCouponLoading = false;

  @override
  void initState() {
    super.initState();
    getSelectedCustomizations();
    // getCoupon();
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

  Future<void> getCoupon() async {
    final cubit = CheckoutCubit.get(context);
    String lang = await CashHelper.getSavedString("lang", "en");
    print('lang $lang');
    try {
      setState(() {
        isCouponLoading = true;
      });
      final response = await http.get(Uri.parse(
          'https://alshiaka.com/wp-json/wc/v3/coupons/145608?consumer_key=ck_0aa636e54b329a08b5328b7d32ffe86f3efd8cbe&consumer_secret=cs_7e2c98933686d9859a318365364d0c7c085e557b&lang=$lang'));
      String? coupon = jsonDecode(response.body)['code'];
      String? description = jsonDecode(response.body)['description'];
      List<dynamic>? metaData = jsonDecode(response.body)['meta_data'];
      int? quantity = metaData!.first['value']['conditions']['quantity'];
      if (quantity == 2) {
        AppUtil.couponToast(context, description);
      } else if (quantity == 3) {
        setState(() {
          cubit.couponController.text = coupon!;
          isCouponActivated = true;
        });
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isCouponLoading = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    refreshPage();
  }

  getTotal(CheckoutCubit cubit) async {
    if (cubit.selectedCountry?.code != null) {
      double weight = 0.0;
      cubit.cartList.forEach((prod) {
        weight += double.parse(prod.weight.toString());
      });

      var numberOfPieces =
          cubit.qty.fold(0, (previousValue, q) => previousValue + q).toString();
      log("Weight $weight");
      log("country ${cubit.selectedCountry!.code}");
      log("city ${cubit.cityController.text}");
      log("numberOfPieces $numberOfPieces");

      await cubit.getTotalAramex(
          context: context,
          country: cubit.selectedCountry!.code,
          city: cubit.cityController.text,
          numberOfPieces: numberOfPieces,
          actualWeight: weight.toString());
    } else {
      log("selectedCountry == null ");
    }
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.width);
    print(
        "widthhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh");

    final cubit = CheckoutCubit.get(context);
    final catCubit = CategoriesCubit.get(context);
    log("cubit.selectedState ${cubit.selectedState}");
    if (cubit.countries == [] || cubit.countries.isEmpty) {
      cubit.stateController.text = AppUtil.ksa;
      cubit.selectedState = AppUtil.ksa;
    }
    // print('here ${catCubit.selectedCustomizations}');
    CheckoutCubit.get(context).fetchCartList(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "myBag".tr(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: WillPopScope(
          onWillPop: () async {
            setState(() {
              BottomNavCubit.get(context).currentIndex = 0;
            });
            AppUtil.removeUntilNavigator(context, const BottomNavTabsScreen());
            return true;
          },
          child: Container(
            padding: const EdgeInsets.only(bottom: 5),
            color: Colors.black12.withOpacity(.025),
            child: BlocBuilder<CheckoutCubit, CheckoutState>(
                buildWhen: (_, state) => state is CheckoutChangeState,
                builder: (context, state) {
                  if (cubit.cartList.isEmpty) {
                    return Padding(
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
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * .105,
                        color: Colors.white,
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * .05,
                            right: MediaQuery.of(context).size.width * .05,
                            bottom: 8,
                            top: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            CustomText(
                              text: "myBag".tr(),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 4),
                              child: CustomText(
                                text: "(" +
                                    "${cubit.cartList.length} " +
                                    "item".tr() +
                                    ")",
                                fontSize: 14,
                                color: AppUI.orangeColor,
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children:
                              List.generate(cubit.cartList.length, (index) {
                            //
                            return Column(
                              children: [
                                Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.only(
                                      left: 15, right: 15, top: 5, bottom: 5),
                                  child: Column(
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
                                                  height: 130,
                                                  placeholder: (context, url) =>
                                                      Stack(
                                                    children: [
                                                      Image.asset(
                                                        "${AppUI.imgPath}product_background.png",
                                                        height: 130,
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
                                                        height: 130,
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
                                                      .symmetric(horizontal: 3),
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
                                                          SizedBox(
                                                              width: AppUtil
                                                                      .responsiveWidth(
                                                                          context) *
                                                                  0.4,
                                                              child: CustomText(
                                                                text: cubit
                                                                    .cartList[
                                                                        index]
                                                                    .name,
                                                                color: AppUI
                                                                    .blueColor,
                                                              )),
                                                          // CustomText(text: cubit.cartModel!.items![index].name!.length<3?cubit.cartModel!.items![index].name:"${cubit.cartModel!.items![index].name!.substring(3,cubit.cartModel!.items![index].name!.length>29?24:cubit.cartModel!.items![index].name!.length-5)}...",color: AppUI.blackColor,),
                                                          const SizedBox(
                                                            height: 6,
                                                          ),
                                                          Row(
                                                            children: [
                                                              CustomText(
                                                                text:
                                                                    "${cubit.cartList[index].price} SAR",
                                                                color: cubit
                                                                            .cartList[
                                                                                index]
                                                                            .salePrice ==
                                                                        ""
                                                                    ? AppUI
                                                                        .blackColor
                                                                    : AppUI
                                                                        .orangeColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              if (cubit
                                                                          .cartList[
                                                                              index]
                                                                          .salePrice !=
                                                                      "" &&
                                                                  cubit.cartList[index]
                                                                          .salePrice !=
                                                                      null)
                                                                CustomText(
                                                                  text:
                                                                      "${cubit.cartList[index].salePrice.toStringAsFixed(2)} SAR",
                                                                  color: AppUI
                                                                      .iconColor,
                                                                  textDecoration:
                                                                      TextDecoration
                                                                          .lineThrough,
                                                                  fontSize: 12,
                                                                ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
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
                                                                        color: AppUI
                                                                            .blackColor,
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
                                                                        color: AppUI
                                                                            .iconColor,
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
                                                                        color: AppUI
                                                                            .blackColor,
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
                                                                        color: AppUI
                                                                            .iconColor,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ],
                                                                  ),
                                                              ],
                                                            ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          // if (cubit
                                                          //         .cartList[
                                                          //             index]
                                                          //         .attributes!
                                                          //         .isNotEmpty &&
                                                          //     cubit
                                                          //             .cartList[
                                                          //                 index]
                                                          //             .attributes![
                                                          //                 0]
                                                          //             .option !=
                                                          //         null)
                                                          // Row(
                                                          //   children: [
                                                          //     CustomText(
                                                          //       text: cubit
                                                          //           .cartList[
                                                          //               index]
                                                          //           .attributes![
                                                          //               0]
                                                          //           .name,
                                                          //       color: AppUI
                                                          //           .iconColor,
                                                          //     ),
                                                          //     const SizedBox(
                                                          //       width: 10,
                                                          //     ),
                                                          //     CustomText(
                                                          //       text: cubit
                                                          //           .cartList[
                                                          //               index]
                                                          //           .attributes![
                                                          //               0]
                                                          //           .option,
                                                          //       color: AppUI
                                                          //           .blackColor,
                                                          //     ),
                                                          //   ],
                                                          // ),

                                                          Row(
                                                            children: [
                                                              InkWell(
                                                                onTap:
                                                                    () async {
                                                                  if (cubit.qty[
                                                                          index] !=
                                                                      1) {
                                                                    cubit.changeQuantity(
                                                                        cubit.cartList[index].mainProductId !=
                                                                                null
                                                                            ? cubit.cartList[index].mainProductId
                                                                            : cubit.cartList[index].id.toString(),
                                                                        --cubit.qty[index],
                                                                        "decrement",
                                                                        context);
                                                                    if (cubit
                                                                            .selectedState !=
                                                                        AppUtil
                                                                            .ksa) {
                                                                      await getTotal(
                                                                          cubit);
                                                                    }
                                                                  }
                                                                },
                                                                child:
                                                                    CircleAvatar(
                                                                        radius:
                                                                            11,
                                                                        backgroundColor:
                                                                            AppUI
                                                                                .greyColor,
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              1.0),
                                                                          child: CircleAvatar(
                                                                              backgroundColor: AppUI.whiteColor,
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.all(1.5),
                                                                                child: Icon(
                                                                                  Icons.remove,
                                                                                  color: Colors.black,
                                                                                  size: 17,
                                                                                ),
                                                                              )),
                                                                        )),
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top: 3),
                                                                child:
                                                                    CustomText(
                                                                  text:
                                                                      "${cubit.qty[index]}",
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              InkWell(
                                                                onTap:
                                                                    () async {
                                                                  cubit.changeQuantity(
                                                                      cubit.cartList[index].mainProductId !=
                                                                              null
                                                                          ? cubit
                                                                              .cartList[
                                                                                  index]
                                                                              .mainProductId
                                                                          : cubit
                                                                              .cartList[
                                                                                  index]
                                                                              .id
                                                                              .toString(),
                                                                      ++cubit.qty[
                                                                          index],
                                                                      "increment",
                                                                      context);
                                                                  if (cubit
                                                                          .selectedState !=
                                                                      AppUtil
                                                                          .ksa) {
                                                                    await getTotal(
                                                                        cubit);
                                                                  }
                                                                },
                                                                child:
                                                                    CircleAvatar(
                                                                        radius:
                                                                            11,
                                                                        backgroundColor:
                                                                            AppUI
                                                                                .greyColor,
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              1.0),
                                                                          child: CircleAvatar(
                                                                              backgroundColor: AppUI.whiteColor,
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.all(1.5),
                                                                                child: Icon(
                                                                                  Icons.add,
                                                                                  color: Colors.black,
                                                                                  size: 17,
                                                                                ),
                                                                              )),
                                                                        )),
                                                              ),
                                                              // SizedBox(width: AppUtil.responsiveWidth(context)*0.27,),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          // Padding(
                                          //   padding: const EdgeInsets.all(15.0),
                                          //   child: Row(
                                          //     children: [
                                          //       InkWell(
                                          //           onTap: (){
                                          //             cubit.removeCartItemItem(cubit.cartList[index],index,context);
                                          //           },
                                          //           child: const Icon(Icons.delete_outline_rounded , color: Colors.red,)),
                                          //       const Spacer(),
                                          //       BlocBuilder<CategoriesCubit,CategoriesState>(
                                          //           buildWhen: (_,state) => state is ChangeFavState,
                                          //           builder: (context, state) {
                                          //             return InkWell(
                                          //                 onTap: (){
                                          //                   if(!cubit.cartList[index].fav!) {
                                          //                     catCubit
                                          //                         .favProduct(
                                          //                         cubit
                                          //                             .cartList[index],context);
                                          //                   }else{
                                          //                     catCubit.removeFromFav(cubit.cartList[index],context);
                                          //                   }
                                          //                 },
                                          //                 child: Row(
                                          //                   children: [
                                          //                     Icon(cubit.cartList[index].fav!?Icons.favorite:Icons.favorite_outline,color: AppUI.errorColor,),
                                          //                     const SizedBox(width: 10,),
                                          //                     CustomText(text: "addToWishList".tr())
                                          //                   ],
                                          //                 ));
                                          //           }
                                          //       ),
                                          //
                                          //     ],
                                          //   ),
                                          // ),
                                          // const SizedBox(height: 10,)
                                          SizedBox(
                                            height: 0,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              BlocBuilder<CategoriesCubit,
                                                      CategoriesState>(
                                                  buildWhen: (_, state) =>
                                                      state is ChangeFavState,
                                                  builder: (context, state) {
                                                    return Row(
                                                      children: [
                                                        InkWell(
                                                            onTap: () {
                                                              if (!cubit
                                                                  .cartList[
                                                                      index]
                                                                  .fav!) {
                                                                catCubit.favProduct(
                                                                    cubit.cartList[
                                                                        index],
                                                                    context);
                                                              } else {
                                                                catCubit.removeFromFav(
                                                                    cubit.cartList[
                                                                        index],
                                                                    context);
                                                              }
                                                            },
                                                            child: Icon(
                                                              cubit
                                                                      .cartList[
                                                                          index]
                                                                      .fav!
                                                                  ? Icons
                                                                      .favorite
                                                                  : Icons
                                                                      .favorite_outline,
                                                              color: AppUI
                                                                  .orangeColor,
                                                            )),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        CustomText(
                                                            text:
                                                                "AddToFavourite"
                                                                    .tr())
                                                      ],
                                                    );
                                                  }),
                                              const SizedBox(
                                                height: 0,
                                              ),
                                              Row(
                                                children: [
                                                  /*        InkWell(
                                                      onTap: (){
                                                        AppUtil.mainNavigator(context, ProductDetailsScreen(product: cubit.cartList[index]));
                                                      },
                                                      child:  Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Icon(Icons.edit , color: AppUI.greyColor,size: 21,),
                                                      )),*/
                                                  InkWell(
                                                      onTap: () async {
                                                        cubit
                                                            .removeCartItemItem(
                                                                cubit.cartList[
                                                                    index],
                                                                index,
                                                                context);
                                                        //
                                                        catCubit
                                                            .selectedCustomizations
                                                            .remove(cubit
                                                                .cartList[index]
                                                                .mainProductId
                                                                .toString());
                                                        //
                                                        await CashHelper.setSavedString(
                                                            "selectedCustomizations",
                                                            jsonEncode(catCubit
                                                                .selectedCustomizations));
                                                        print(
                                                            'test delete ${catCubit.selectedCustomizations}');
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Icon(
                                                          Icons
                                                              .delete_outline_rounded,
                                                          size: 21,
                                                          color:
                                                              AppUI.greyColor,
                                                        ),
                                                      )),
                                                ],
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                cubit.cartList.length - 1 == index
                                    ? BlocBuilder<CheckoutCubit, CheckoutState>(
                                        buildWhen: (_, state) =>
                                            state is CheckoutChangeState ||
                                            state is ApplyCoupon,
                                        builder: (context, state) {
                                          if (isCouponLoading) {
                                            return const LoadingWidget();
                                          }
                                          return Container(
                                            color: Colors.white,
                                            padding: const EdgeInsets.only(
                                                left: 15, right: 15),
                                            child: Column(
                                              children: [
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                CustomInput(
                                                  readOnly: isCouponActivated,
                                                  controller:
                                                      cubit.couponController,
                                                  hint: "enterCoupon".tr(),
                                                  textInputType:
                                                      TextInputType.text,
                                                  fillColor: cubit
                                                              .couponApplied ||
                                                          isCouponActivated
                                                      ? AppUI.backgroundColor
                                                      : AppUI.whiteColor,
                                                  borderColor: AppUI.greyColor,
                                                  radius: 4,
                                                  suffixIcon: isCouponActivated
                                                      ? null
                                                      : InkWell(
                                                          onTap: () {
                                                            if (!cubit
                                                                .couponApplied) {
                                                              cubit.applyCoupon(
                                                                  context);
                                                            } else {
                                                              cubit
                                                                  .cancelCoupon();
                                                            }
                                                          },
                                                          child: CustomText(
                                                            text: cubit
                                                                    .couponApplied
                                                                ? "cancel".tr()
                                                                : "apply".tr(),
                                                            color:
                                                                AppUI.blueColor,
                                                          )),
                                                ),
                                              ],
                                            ),
                                          );
                                        })
                                    : SizedBox(),
                              ],
                            );
                          }),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      (cubit.selectedState != "" &&
                              cubit.selectedState == AppUtil.ksa)
                          ? Container(
                              color: Colors.white,
                              padding: EdgeInsets.only(
                                  left: 15, right: 15, top: 10, bottom: 10),
                              child: Row(
                                children: [
                                  CustomText(
                                      text: "totalPrice".tr().toUpperCase()),
                                  const Spacer(),
                                  CustomText(
                                    text: "${cubit.total} SAR",
                                    color: AppUI.blackColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  )
                                ],
                              ),
                            )
                          :
                          //? ====== Get Total ======

                          Center(
                              child: BlocBuilder<CheckoutCubit, CheckoutState>(
                                  buildWhen: (_, getTotalState) =>
                                      getTotalState is GetTotalLoadingState ||
                                      getTotalState is GetTotalLoadedState ||
                                      getTotalState is GetTotalErrorState,
                                  builder: (context, getTotalState) {
                                    if (getTotalState is GetTotalErrorState) {
                                      return Container(
                                          color: AppUI.whiteColor,
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text(
                                            getTotalState.error,
                                            style: TextStyle(
                                                color: AppUI.errorColor),
                                          ));
                                    } else if (getTotalState
                                        is GetTotalLoadedState) {
                                      return Container(
                                        color: Colors.white,
                                        padding: EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                            top: 10,
                                            bottom: 10),
                                        child: Row(
                                          children: [
                                            CustomText(
                                                text: "totalPrice"
                                                    .tr()
                                                    .toUpperCase()),
                                            const Spacer(),
                                            CustomText(
                                              text:
                                                  "${getTotalState.amountAramex.amount!.value} ${getTotalState.amountAramex.amount!.currencyCode}",
                                              color: AppUI.blackColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            )
                                          ],
                                        ),
                                      );
                                    }
                                    return Container(
                                      color: AppUI.whiteColor,
                                      padding: const EdgeInsets.all(16.0),
                                      child: const CircularProgressIndicator(),
                                    );
                                  }),
                            ),
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: Column(
                          children: [
                            CustomButton(
                              text: "checkout".tr(),
                              onPressed: () {
                                AppUtil.mainNavigator(
                                    context, const CheckoutScreen());
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomButton(
                              text: "continueShopping".tr(),
                              borderColor: AppUI.mainColor,
                              color: AppUI.whiteColor,
                              textColor: AppUI.mainColor,
                              onPressed: () {
                                BottomNavCubit.get(context).setCurrentIndex(0);
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                }),
          )),
    );
  }

  int connection = 0;
  Future<dynamic> CheckStock(var id, var quantity) async {
    var url =
        "https://alshiaka.com/wp-json/cocart/v2/cart/add-item?id=$id&quantity=$quantity";
    print(url);
    var header = {};
    try {
      final response = await http.post(Uri.parse(url));
      print(response.body);
      print(response.statusCode);
      print("######################################################3333");
      if (response.statusCode == 200) {
        print(response.body);
        setState(() {
          connection = 200;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  refreshPage() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {});
    });
  }
}
