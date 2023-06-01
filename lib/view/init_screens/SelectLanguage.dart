import 'package:ahshiaka/main.dart';
import 'package:ahshiaka/view/layout/bottom_nav_screen/bottom_nav_tabs_screen.dart';
import 'package:flutter/material.dart';

import '../../shared/cash_helper.dart';
import '../../shared/components.dart';
import '../../utilities/app_ui.dart';
import '../../utilities/app_util.dart';
import '../../utilities/size_config.dart';
import 'package:easy_localization/easy_localization.dart';

import 'login_or_signup_screen.dart';

class SelectLanguage extends StatefulWidget {
  @override
  _SelectLanguageState createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * .05,
            right: MediaQuery.of(context).size.width * .05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 75,
            ),
            Image.asset(
              "${AppUI.imgPath}logo.png",
              //height: 33,
              height: MediaQuery.of(context).size.height * .085,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 250,
            ),
            CustomButton(
              width: MediaQuery.of(context).size.width * .7,
              text: "العربية",
              onPressed: () async {
                String jwt = await CashHelper.getSavedString("jwt", "");
                await CashHelper.setSavedString("lang", "ar");
                if (!mounted) return;
                await context.setLocale(const Locale("ar"));
                if (!mounted) return;
                // AppUtil.removeUntilNavigator(
                //     context,
                //     jwt == ""
                //         ? const LoginOrSignupScreen()
                //         : const BottomNavTabsScreen());
                AppUtil.removeUntilNavigator(context, const MyApp());
              },
            ),
            SizedBox(
              height: 15,
            ),
            CustomButton(
              width: MediaQuery.of(context).size.width * .7,
              text: "English",
              onPressed: () async {
                String jwt = await CashHelper.getSavedString("jwt", "");
                await CashHelper.setSavedString("lang", "en");
                if (!mounted) return;
                await context.setLocale(const Locale("en"));
                if (!mounted) return;
                // AppUtil.removeUntilNavigator(
                //     context,
                //     jwt == ""
                //         ? const LoginOrSignupScreen()
                //         : const BottomNavTabsScreen());
                AppUtil.removeUntilNavigator(context, const MyApp());
              },
            )
          ],
        ),
      ),
    );
  }
}
