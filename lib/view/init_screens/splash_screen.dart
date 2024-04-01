import 'package:ahshiaka/bloc/layout_cubit/categories_cubit/categories_cubit.dart';
import 'package:ahshiaka/bloc/profile_cubit/profile_cubit.dart';
import 'package:ahshiaka/utilities/app_ui.dart';
import 'package:ahshiaka/view/init_screens/SelectLanguage.dart';
import 'package:ahshiaka/view/init_screens/maintenance_screen.dart';
import 'package:ahshiaka/view/init_screens/version_screen.dart';
import 'package:ahshiaka/view/layout/bottom_nav_screen/bottom_nav_tabs_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_version_checker/flutter_app_version_checker.dart';

import '../../bloc/layout_cubit/checkout_cubit/checkout_cubit.dart';
import '../../shared/cash_helper.dart';
import '../../utilities/app_util.dart';
import 'login_or_signup_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _checker = AppVersionChecker();

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    CategoriesCubit.get(context);
    CheckoutCubit.get(context).fetchCartList(context);
    ProfileCubit.get(context).fetchCustomer();

    Future.delayed(const Duration(milliseconds: 5500), () async {
      String jwt = await CashHelper.getSavedString("jwt", "");
      print('jwt $jwt');
      String lang = await CashHelper.getSavedString("lang", "");
      if (lang == "") {
        if (AppUtil.rtlDirection(context)) {
          CashHelper.setSavedString("lang", "ar");
        } else {
          CashHelper.setSavedString("lang", "en");
        }
      }
      // await HomeCubit.get(context).fetchInsurances();
      CheckoutCubit.get(context).fetchOrders(context);
      await _checker.checkUpdate().then((value) async {
        print(value.canUpdate); //return true if update is available
        print(value.currentVersion); //return current app version
        print(value.newVersion); //return the new app version
        print(value.appURL); //return the app url
        print(value
            .errorMessage); //return error message if found else it will return null
        if (value.canUpdate) {
          AppUtil.removeUntilNavigator(context, VersionScreen(result: value));
        } else {
          AppUtil.removeUntilNavigator(
            context,
            lang == ""
                ? SelectLanguage()
                : jwt == ""
                    ? const LoginOrSignupScreen()
                    : const BottomNavTabsScreen(),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image.asset(
              "${AppUI.imgPath}alshiaka_splash.gif",
              width: double.infinity,
              filterQuality: FilterQuality.high,
            ),
            Container(
              color: const Color(0xffFCFCFC),
              height: 2,
              width: double.infinity,
            )
          ],
        ),
      ),
    );
  }
}
