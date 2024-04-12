import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:ahshiaka/bloc/layout_cubit/checkout_cubit/checkout_cubit.dart';
import 'package:ahshiaka/bloc/layout_cubit/checkout_cubit/checkout_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../../../shared/components.dart';
import '../../../../../../../../../utilities/app_ui.dart';
import '../../../../../../../../../utilities/app_util.dart';

class AddressInformationWidget extends StatelessWidget {
  final CheckoutCubit cubit;
  const AddressInformationWidget({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          children: [
            CustomText(
              text: "addressInformation".tr(),
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
      BlocBuilder<CheckoutCubit, CheckoutState>(
        buildWhen: (context, state) =>
            state is CheckoutChangeState ||
            state is GetCountriesLoadingState ||
            state is GetCountriesLoadedState ||
            state is GetCountriesErrorState,
        builder: (context, state) {
          if (state is GetCountriesErrorState) {
            return Container(
              color: AppUI.whiteColor,
              padding: const EdgeInsets.all(16),
              child: CustomText(
                text: state.error,
                color: AppUI.errorColor,
              ),
            );
          }
          if (state is GetCountriesLoadingState) {
            return Container(
              color: AppUI.whiteColor,
              padding: const EdgeInsets.all(16),
              child: const CircularProgressIndicator(),
            );
          }

          return Container(
            color: AppUI.whiteColor,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: "email".tr(),
                  color: AppUI.greyColor,
                ),
                CustomInput(
                  controller: cubit.emailController2,
                  textInputType: TextInputType.emailAddress,
                  hint: "email".tr(),
                ),
                const SizedBox(
                  height: 10,
                ),
                // State Like KSA
                CustomText(
                  text: "state".tr(),
                  color: AppUI.greyColor,
                ),
                CustomInput(
                  // hint: "state".tr(),
                  controller: cubit.stateController,
                  textInputType: TextInputType.text,
                  suffixIcon: const Icon(Icons.keyboard_arrow_down),
                  readOnly: true,
                  onTap: () {
                    AppUtil.dialog2(
                        context,
                        "state".tr(),
                        List.generate(cubit.countries.length, (index) {
                          return Column(
                            children: [
                              InkWell(
                                  onTap: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                    cubit.selectedCountry =
                                        cubit.countries[index];
                                    cubit.stateController.text =
                                        cubit.countries[index].name;

                                    cubit.selectedState =
                                        cubit.countries[index].name;
                                    cubit.selectedStateIndex = index;
                                    print(cubit.selectedState);
                                    log(" cubit.selectedState ${cubit.selectedState}");
                                    if (cubit.selectedState != AppUtil.ksa &&
                                        cubit.selectedState != "") {
                                      cubit.countryController.text =
                                          cubit.countries[index].name;
                                      cubit.selectedRegion =
                                          cubit.selectedState;
                                      cubit.selectedCity = '';
                                      cubit.cityController.clear();
                                      cubit.addressController.clear();
                                      cubit.address2Controller.clear();
                                    } else {
                                      cubit.selectedCity = '';
                                      cubit.selectedRegion = '';
                                      cubit.countryController.clear();
                                      cubit.cityController.clear();
                                      cubit.addressController.clear();
                                      cubit.address2Controller.clear();
                                    }
                                    cubit.updateState();
                                  },
                                  child: Row(
                                    children: [
                                      CustomText(
                                        text: cubit.countries[index].name,
                                      ),
                                    ],
                                  )),
                              const Divider(),
                            ],
                          );
                        }));
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                (cubit.selectedState != "" &&
                        cubit.selectedState == AppUtil.ksa)
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: "region".tr(),
                            color: AppUI.greyColor,
                          ),
                          CustomInput(
                            hint: "region".tr(),
                            controller: cubit.countryController,
                            textInputType: TextInputType.text,
                            suffixIcon: const Icon(Icons.keyboard_arrow_down),
                            readOnly: true,
                            onTap: () {
                              AppUtil.dialog2(
                                  context,
                                  "region".tr(),
                                  List.generate(cubit.regions.length, (index) {
                                    return Column(
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop();
                                              cubit.countryController.text =
                                                  AppUtil.rtlDirection(context)
                                                      ? cubit.regionsAr[index]
                                                      : cubit.regions[index];
                                              cubit.selectedRegion =
                                                  cubit.regions[index];
                                              cubit.selectedRegionIndex = index;
                                              print(cubit.selectedRegion);
                                            },
                                            child: Row(
                                              children: [
                                                CustomText(
                                                    text: AppUtil.rtlDirection(
                                                            context)
                                                        ? cubit.regionsAr[index]
                                                        : cubit.regions[index]),
                                              ],
                                            )),
                                        const Divider(),
                                      ],
                                    );
                                  }));
                            },
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: "city".tr(),
                            color: AppUI.greyColor,
                          ),
                          CustomInput(
                            hint: "city".tr(),
                            controller: cubit.cityController,
                            onChange: (city) {
                              cubit.selectedCity = city;
                            },
                            textInputType: TextInputType.text,
                          ),
                        ],
                      ),

                // ? If State Is KSA
                if (cubit.selectedState != "" &&
                    cubit.selectedState == AppUtil.ksa) ...[
                  CustomText(
                    text: "city".tr(),
                    color: AppUI.greyColor,
                  ),
                  CustomInput(
                    hint: "city".tr(),
                    controller: cubit.cityController,
                    textInputType: TextInputType.text,
                    onChange: (city) {
                      cubit.selectedCity = city;
                    },
                    suffixIcon: const Icon(Icons.keyboard_arrow_down),
                    readOnly: true,
                    onTap: () {
                      AppUtil.dialog2(context, "city".tr(), [
                        SizedBox(
                          height: AppUtil.responsiveHeight(context) * 0.7,
                          child: SingleChildScrollView(
                            child: Column(
                              children: List.generate(
                                  cubit.cities[cubit.selectedRegionIndex]
                                      .length, (index) {
                                return Column(
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                          cubit.cityController.text =
                                              AppUtil.rtlDirection(context)
                                                  ? cubit.citiesAr[cubit
                                                          .selectedRegionIndex]
                                                      [index]
                                                  : cubit.cities[cubit
                                                          .selectedRegionIndex]
                                                      [index];
                                          cubit.selectedCity = cubit.cities[
                                              cubit.selectedRegionIndex][index];
                                          print(cubit.selectedCity);
                                        },
                                        child: Row(
                                          children: [
                                            CustomText(
                                                text: AppUtil.rtlDirection(
                                                        context)
                                                    ? cubit.citiesAr[cubit
                                                            .selectedRegionIndex]
                                                        [index]
                                                    : cubit.cities[cubit
                                                            .selectedRegionIndex]
                                                        [index]),
                                          ],
                                        )),
                                    const Divider(),
                                  ],
                                );
                              }),
                            ),
                          ),
                        )
                      ]);
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomText(
                    text: "address".tr(),
                    color: AppUI.greyColor,
                  ),
                  CustomInput(
                    controller: cubit.addressController,
                    textInputType: TextInputType.text,
                    hint: "address".tr(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
                const SizedBox(
                  height: 10,
                ),
                CustomText(
                  text: "postCode".tr(),
                  color: AppUI.greyColor,
                ),
                CustomInput(
                  controller: cubit.postCodeController,
                  textInputType: TextInputType.text,
                  hint: "postCode".tr(),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        },
      )
    ]);
  }
}
