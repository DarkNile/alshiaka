import 'dart:developer';
import 'package:ahshiaka/bloc/layout_cubit/checkout_cubit/checkout_cubit.dart';
import 'package:ahshiaka/bloc/layout_cubit/checkout_cubit/checkout_state.dart';
import 'package:ahshiaka/view/layout/bottom_nav_screen/tabs/bag/checkout/address/addresses_screen/widgets/address_from_internet_widget.dart';
import 'package:ahshiaka/view/layout/bottom_nav_screen/tabs/bag/checkout/address/addresses_screen/widgets/address_is_quest_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../../shared/components.dart';
import '../../../../../../../../utilities/app_ui.dart';
import '../../../../../../../../utilities/app_util.dart';
import 'package:ahshiaka/shared/CheckNetwork.dart';

// ignore: must_be_immutable
class AddressesScreen extends StatefulWidget {
  bool isQuest;

  final bool isFromProfile;
  AddressesScreen({
    Key? key,
    required this.isQuest,
    this.isFromProfile = false,
  }) : super(key: key);

  @override
  _AddressesScreenState createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() {
    final cubit = CheckoutCubit.get(context);
    log("isQuest ::: ::: ::: " + widget.isQuest.toString());

    if (widget.isQuest) {
      log("Quest");
      cubit.loadAddressLocal();
    } else {
      cubit.fetchAddresses();
    }
  }

  getTaxAramex(CheckoutCubit cubit, BuildContext context) async {
    await cubit.getTaxAramex(context: context);
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

  @override
  Widget build(BuildContext context) {
    log("Addresses _Screeend");
    final cubit = CheckoutCubit.get(context);
    return CheckNetwork(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            CustomAppBar(
              title: "addresses".tr(),
              onBack: () {
                log("Back");
                Navigator.of(context).pop();
              },
            ),
            BlocBuilder<CheckoutCubit, CheckoutState>(
                buildWhen: (_, state) =>
                    state is AddressesState ||
                    state is GetTotalLoadingState ||
                    state is GetTotalLoadedState ||
                    state is GetTotalErrorState,
                builder: (context, state) {
                  if (state is GetTotalLoadingState) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: AppUtil.responsiveHeight(context) * .3),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (state is GetTotalErrorState) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: AppUtil.responsiveHeight(context) * .3),
                        child: CustomText(
                          text: state.error,
                          color: AppUI.errorColor,
                        ),
                      ),
                    );
                  }

                  return widget.isQuest
                      ? AddressIsQuestWidget(
                          cubit: cubit,
                          isFromProfile: widget.isFromProfile,
                          isQuest: widget.isQuest,
                        )
                      : AddressFromInternetWidget(
                          cubit: cubit,
                          isFromProfile: widget.isFromProfile,
                          isQuest: widget.isQuest,
                        );
                }),
          ],
        ),
      ),
    );
  }
}
