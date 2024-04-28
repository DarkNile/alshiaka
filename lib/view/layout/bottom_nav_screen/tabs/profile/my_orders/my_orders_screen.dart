import 'package:ahshiaka/bloc/layout_cubit/checkout_cubit/checkout_cubit.dart';
import 'package:ahshiaka/bloc/layout_cubit/checkout_cubit/checkout_state.dart';
import 'package:ahshiaka/bloc/profile_cubit/profile_cubit.dart';
import 'package:ahshiaka/bloc/profile_cubit/profile_states.dart';
import 'package:ahshiaka/shared/components.dart';
import 'package:ahshiaka/utilities/app_ui.dart';
import 'package:ahshiaka/utilities/app_util.dart';
import 'package:ahshiaka/view/layout/bottom_nav_screen/bottom_nav_tabs_screen.dart';
import 'package:ahshiaka/view/layout/bottom_nav_screen/tabs/profile/my_orders/track_order_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ahshiaka/shared/CheckNetwork.dart';
import 'order_details_screen.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({Key? key}) : super(key: key);

  @override
  _MyOrdersScreenState createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    final checkoutCubit = CheckoutCubit.get(context);
    final cubit = ProfileCubit.get(context);
    return CheckNetwork(
      child: WillPopScope(
        onWillPop: () async {
          AppUtil.removeUntilNavigator(context, const BottomNavTabsScreen());
          return true;
        },
        child: Scaffold(
          backgroundColor: AppUI.backgroundColor,
          body: BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, ProfileState state) {
            return Column(
              children: [
                CustomAppBar(
                  title: "myOrders".tr(),
                  onBack: () {
                    AppUtil.removeUntilNavigator(
                        context, const BottomNavTabsScreen());
                  },
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 45),
                  child: CustomCard(
                    height: 70,
                    elevation: 0,
                    padding: 0.0,
                    child: Row(
                      children: [
                        Expanded(
                          flex: cubit.tabState == "current" ? 5 : 4,
                          child: CustomCard(
                            onTap: () {
                              cubit.changeTabState("current");
                            },
                            padding: 0.0,
                            elevation: 0,
                            color: cubit.tabState == "current"
                                ? AppUI.mainColor
                                : AppUI.whiteColor,
                            child: CustomText(
                              text: "currentOrders".tr(),
                              color: cubit.tabState == "current"
                                  ? AppUI.whiteColor
                                  : AppUI.blackColor,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: cubit.tabState == "current" ? 4 : 5,
                          child: CustomCard(
                            onTap: () {
                              cubit.changeTabState("previous");
                            },
                            padding: 0.0,
                            elevation: 0,
                            color: cubit.tabState == "current"
                                ? AppUI.whiteColor
                                : AppUI.mainColor,
                            child: CustomText(
                              text: "previousOrders".tr(),
                              color: cubit.tabState != "current"
                                  ? AppUI.whiteColor
                                  : AppUI.blackColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                BlocBuilder<CheckoutCubit, CheckoutState>(
                    buildWhen: (_, __) => state is CheckoutChangeState,
                    builder: (context, state) {
                      if (cubit.tabState == "current" &&
                          checkoutCubit.pendingOrders.isEmpty) {
                        return _NoOrdersWidget();
                      } else if (cubit.tabState != "current" &&
                          checkoutCubit.otherOrders.isEmpty) {
                        return _NoOrdersWidget();
                      }
                      return Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          children: List.generate(
                              cubit.tabState == "current"
                                  ? checkoutCubit.pendingOrders.length
                                  : checkoutCubit.otherOrders.length, (index) {
                            return InkWell(
                              onTap: () {
                                AppUtil.mainNavigator(
                                    context,
                                    OrderDetailsScreen(
                                        order: cubit.tabState == "current"
                                            ? checkoutCubit.pendingOrders[index]
                                            : checkoutCubit
                                                .otherOrders[index]));
                              },
                              child: Column(
                                children: [
                                  Container(
                                    color: AppUI.whiteColor,
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CustomText(
                                                    text:
                                                        "${"orderId".tr()}:- #${cubit.tabState == "current" ? checkoutCubit.pendingOrders[index].id! : checkoutCubit.otherOrders[index].id!}"),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                CustomText(
                                                    text:
                                                        "${"orderDate".tr()}:- ${cubit.tabState == "current" ? checkoutCubit.pendingOrders[index].dateCreated!.substring(0, 10) : checkoutCubit.otherOrders[index].dateCreated!.substring(0, 10)}"),
                                              ],
                                            ),
                                          ],
                                        ),
                                        if (cubit.tabState == "current"
                                            ? checkoutCubit.pendingOrders[index]
                                                .lineItems!.isNotEmpty
                                            : checkoutCubit.otherOrders[index]
                                                .lineItems!.isNotEmpty)
                                          ProductCard(
                                            type: "order ${cubit.tabState}",
                                            product: cubit.tabState == "current"
                                                ? checkoutCubit
                                                    .pendingOrders[index]
                                                    .lineItems![0]
                                                : checkoutCubit
                                                    .otherOrders[index]
                                                    .lineItems![0],
                                            onDelete: () async {
                                              AppUtil.dialog2(
                                                  context, "", const [
                                                LoadingWidget(),
                                                SizedBox(
                                                  height: 30,
                                                ),
                                              ]);
                                              await checkoutCubit.deleteOrder(
                                                  checkoutCubit
                                                      .pendingOrders[index].id,
                                                  context);
                                              if (!mounted) return;
                                              Navigator.pop(context);
                                              setState(() {});
                                            },
                                            onTap: () {
                                              AppUtil.mainNavigator(
                                                context,
                                                OrderDetailsScreen(
                                                    order: cubit.tabState ==
                                                            "current"
                                                        ? checkoutCubit
                                                                .pendingOrders[
                                                            index]
                                                        : checkoutCubit
                                                                .otherOrders[
                                                            index]),
                                              );
                                            },
                                          ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            CustomText(
                                                text:
                                                    "${"orderTotal".tr()}:- ${cubit.tabState == "current" ? checkoutCubit.pendingOrders[index].total! : checkoutCubit.otherOrders[index].total}"),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        if (cubit.tabState == "current")
                                          CustomButton(
                                            text: "trackYourOrder".tr(),
                                            onPressed: () {
                                              AppUtil.mainNavigator(
                                                  context,
                                                  TrackOrderScreen(
                                                      order: cubit.tabState ==
                                                              "current"
                                                          ? checkoutCubit
                                                                  .pendingOrders[
                                                              index]
                                                          : checkoutCubit
                                                                  .otherOrders[
                                                              index]));
                                            },
                                          )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      );
                    })
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _NoOrdersWidget extends StatelessWidget {
  const _NoOrdersWidget();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: CustomText(
          text: "noOrders".tr(),
          color: AppUI.mainColor,
          fontSize: 30,
        ),
      ),
    );
  }
}
