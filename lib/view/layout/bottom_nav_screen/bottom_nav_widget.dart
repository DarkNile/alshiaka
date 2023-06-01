import 'package:ahshiaka/bloc/layout_cubit/categories_cubit/categories_cubit.dart';
import 'package:ahshiaka/bloc/layout_cubit/categories_cubit/categories_states.dart';
import 'package:ahshiaka/bloc/layout_cubit/checkout_cubit/checkout_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../bloc/layout_cubit/checkout_cubit/checkout_state.dart';
import '../../../shared/components.dart';
import '../../../utilities/app_ui.dart';

class BottomNavBar extends StatelessWidget {
  final Function() onTap0, onTap1, onTap2, onTap3, onTap4;
  final int currentIndex;
  const BottomNavBar(
      {Key? key,
      required this.currentIndex,
      required this.onTap0,
      required this.onTap1,
      required this.onTap2,
      required this.onTap3,
      required this.onTap4})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: AppUI.whiteColor,
          width: double.infinity,
          height: 62,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: onTap0,
                  child: Container(
                    width: MediaQuery.of(context).size.width * .2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Image.asset(
                          "${AppUI.imgPath}home.png",
                          height: 23,
                          width: 23,
                          color: currentIndex == 0
                              ? AppUI.mainColor
                              : Colors.grey[400]!,
                          fit: BoxFit.fill,
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        CustomText(
                          text: "home".tr(),
                          textAlign: TextAlign.center,
                          color: currentIndex == 0
                              ? AppUI.mainColor
                              : Colors.grey[400]!.withOpacity(0.8),
                          fontSize: 11.9,
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: onTap1,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * .2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Image.asset(
                          "${AppUI.imgPath}cat.png",
                          height: 23,
                          width: 23,
                          color: currentIndex == 1
                              ? AppUI.mainColor
                              : Colors.grey[400]!,
                          fit: BoxFit.fill,
                        ),
                        CustomText(
                          text: "categories".tr(),
                          textAlign: TextAlign.center,
                          color: currentIndex == 1
                              ? AppUI.mainColor
                              : Colors.grey[400]!,
                          fontSize: 11.9,
                        )
                      ],
                    ),
                  ),
                ),
                BlocBuilder<CheckoutCubit, CheckoutState>(
                    buildWhen: (_, state) =>
                        state is CartLoadedState ||
                        state is CheckoutChangeState,
                    builder: (context, state) {
                      final cubit = CheckoutCubit.get(context);
                      return InkWell(
                        onTap: onTap2,
                        child: Container(
                          width: MediaQuery.of(context).size.width * .2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  SizedBox(
                                      child: Container(
                                          alignment: Alignment.center,
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Image.asset(
                                                "${AppUI.imgPath}bag.png",
                                                height: 23,
                                                width: 23,
                                                color: currentIndex == 2
                                                    ? AppUI.mainColor
                                                    : Colors.grey[400]!,
                                                fit: BoxFit.fill,
                                              ),
                                              CustomText(
                                                text: "bag".tr(),
                                                textAlign: TextAlign.center,
                                                color: currentIndex == 2
                                                    ? AppUI.mainColor
                                                    : Colors.grey[400]!,
                                                fontSize: 11.9,
                                              )
                                            ],
                                          ))),
                                  if (cubit.cartList.isNotEmpty)
                                    Positioned(
                                      left: MediaQuery.of(context).size.width *
                                          .11,
                                      top: 5,
                                      child: CircleAvatar(
                                        backgroundColor: AppUI.activeColor,
                                        radius: 9,
                                        child: CustomText(
                                          text:
                                              cubit.cartList.length.toString(),
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.bold,
                                          color: AppUI.whiteColor,
                                        ),
                                      ),
                                    )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                BlocBuilder<CategoriesCubit, CategoriesState>(
                    buildWhen: (_, state) =>
                        state is FavLoadedState || state is ChangeFavState,
                    builder: (context, state) {
                      final cubit = CategoriesCubit.get(context);
                      return InkWell(
                        onTap: onTap3,
                        child: Container(
                          width: MediaQuery.of(context).size.width * .2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          .2,
                                      child: Container(
                                          alignment: Alignment.center,
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Image.asset(
                                                "${AppUI.imgPath}fav.png",
                                                height: 23,
                                                width: 23,
                                                color: currentIndex == 3
                                                    ? AppUI.mainColor
                                                    : Colors.grey[400]!,
                                                fit: BoxFit.fill,
                                              ),
                                              CustomText(
                                                text: "wishList".tr(),
                                                textAlign: TextAlign.center,
                                                color: currentIndex == 3
                                                    ? AppUI.mainColor
                                                    : Colors.grey[400]!,
                                                fontSize: 11.9,
                                              )
                                            ],
                                          ))),
                                  if (cubit.favProducts.isNotEmpty)
                                    Positioned(
                                      left: MediaQuery.of(context).size.width *
                                          .11,
                                      top: 5,
                                      child: CircleAvatar(
                                        backgroundColor: AppUI.activeColor,
                                        radius: 9,
                                        child: CustomText(
                                          text: cubit.favProducts.length
                                              .toString(),
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.bold,
                                          color: AppUI.whiteColor,
                                        ),
                                      ),
                                    )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                InkWell(
                  onTap: onTap4,
                  child: Container(
                    width: MediaQuery.of(context).size.width * .2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Image.asset("${AppUI.imgPath}profile.png",
                            height: 23,
                            width: 23,
                            color: currentIndex == 4
                                ? AppUI.mainColor
                                : Colors.grey[400]!.withOpacity(0.8),
                            fit: BoxFit.fill),
                        const SizedBox(
                          height: 3,
                        ),
                        CustomText(
                          text: "profile".tr(),
                          textAlign: TextAlign.center,
                          color: currentIndex == 4
                              ? AppUI.mainColor
                              : Colors.grey[400]!,
                          fontSize: 11.9,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
