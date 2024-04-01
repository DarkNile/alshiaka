import 'dart:convert';

import 'package:ahshiaka/view/layout/bottom_nav_screen/tabs/bag/bag_screen.dart';
import 'package:ahshiaka/view/layout/bottom_nav_screen/tabs/categories/categories_screen.dart';
import 'package:ahshiaka/view/layout/bottom_nav_screen/tabs/categories/products_screen.dart';
import 'package:ahshiaka/view/layout/bottom_nav_screen/tabs/home/home_screen.dart';
import 'package:ahshiaka/view/layout/bottom_nav_screen/tabs/profile/profile_screen.dart';
import 'package:ahshiaka/view/layout/bottom_nav_screen/tabs/wish_list_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_version_checker/flutter_app_version_checker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../bloc/layout_cubit/bottom_nav_cubit.dart';
import '../../../bloc/layout_cubit/bottom_nav_states.dart';
import '../../../shared/CheckNetwork.dart';
import '../../../shared/components.dart';
import '../../../utilities/app_ui.dart';
import '../../../utilities/app_util.dart';
import 'bottom_nav_widget.dart';
import 'package:http/http.dart' as http;

class BottomNavTabsScreen extends StatefulWidget {
  const BottomNavTabsScreen({Key? key}) : super(key: key);

  @override
  _BottomNavTabsScreenState createState() => _BottomNavTabsScreenState();
}

class _BottomNavTabsScreenState extends State<BottomNavTabsScreen> {
  final _checker = AppVersionChecker();

  @override
  void initState() {
    super.initState();
    // checkAppVersion();
  }

  // Future<void> checkAppVersion() async {
  //   await _checker.checkUpdate().then((value) async {
  //     print(value.canUpdate); //return true if update is available
  //     print(value.currentVersion); //return current app version
  //     print(value.newVersion); //return the new app version
  //     print(value.appURL); //return the app url
  //     print(value
  //         .errorMessage); //return error message if found else it will return null
  //     if (value.canUpdate) {
  //       return await AppUtil.dialog2(
  //         context,
  //         "versionTitle".tr(),
  //         [
  //           ElevatedButton(
  //             onPressed: () async {
  //               await launchUrlString(
  //                 value.appURL!,
  //               );
  //             },
  //             child: CustomText(
  //               text: "updateNow".tr(),
  //               textAlign: TextAlign.center,
  //               color: Colors.white,
  //             ),
  //           ),
  //         ],
  //         barrierDismissible: false,
  //         showClose: false,
  //       );
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return CheckNetwork(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: context.watch<BottomNavCubit>().currentIndex == 0
            ? customAppBar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 25,
                    ),
                    Image.asset(
                      "${AppUI.imgPath}logo.png",
                      width: 120,
                    ),
                    GestureDetector(
                      onTap: () {
                        AppUtil.mainNavigator(
                            context,
                            const ProductsScreen(
                                catId: 0, catName: 'products'));
                      },
                      child: Icon(
                        Icons.search,
                        size: 25,
                      ),
                    )
                  ],
                ),
                backgroundColor: AppUI.whiteColor,
                elevation: 0)
            : null,
        body: BottomNavCubit.get(context).currentIndex == 0
            ? const HomeScreen()
            : BottomNavCubit.get(context).currentIndex == 1
                ? const CategoriesScreen()
                : BottomNavCubit.get(context).currentIndex == 2
                    ? const BagScreen()
                    : BottomNavCubit.get(context).currentIndex == 3
                        ? const WishListScreen()
                        : ProfileScreen(),
        bottomNavigationBar: BlocConsumer<BottomNavCubit, BottomNavState>(
            listener: (context, index) {},
            builder: (
              context,
              state,
            ) {
              var bottomNavProvider = BottomNavCubit.get(context);
              return Container(
                padding: EdgeInsets.only(top: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),
                child: BottomNavBar(
                  currentIndex: bottomNavProvider.currentIndex,
                  onTap0: () {
                    bottomNavProvider.setCurrentIndex(0);
                  },
                  onTap1: () {
                    bottomNavProvider.setCurrentIndex(1);
                  },
                  onTap2: () {
                    bottomNavProvider.setCurrentIndex(2);
                  },
                  onTap3: () {
                    bottomNavProvider.setCurrentIndex(3);
                  },
                  onTap4: () {
                    bottomNavProvider.setCurrentIndex(4);
                  },
                ),
              );
            }),
      ),
    );
  }
}
