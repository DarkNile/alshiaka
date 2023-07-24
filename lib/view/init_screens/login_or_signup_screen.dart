import 'dart:convert';

import 'package:ahshiaka/shared/CheckNetwork.dart';
import 'package:ahshiaka/shared/components.dart';
import 'package:ahshiaka/utilities/app_ui.dart';
import 'package:ahshiaka/utilities/app_util.dart';
import 'package:ahshiaka/utilities/size_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../auth/auth_screen.dart';
import '../layout/bottom_nav_screen/bottom_nav_tabs_screen.dart';
import 'package:http/http.dart' as http;

class LoginOrSignupScreen extends StatefulWidget {
  const LoginOrSignupScreen({Key? key}) : super(key: key);

  @override
  _LoginOrSignupScreenState createState() => _LoginOrSignupScreenState();
}

class _LoginOrSignupScreenState extends State<LoginOrSignupScreen> {
  String image = "";
  bool loading = true;
  loadData() async {
    image = await getImage();
    setState(() {
      loading = false;
    });
    print(
        "imagessssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    print(height * 0.7);
    SizeConfig().init(context);
    return CheckNetwork(
      child: Scaffold(
        body: loading
            ? Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Image.network(
                      image,
                      height: height * 0.7,
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(SizeConfig.padding),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: "welcomeToAlshiaka".tr(),
                              fontWeight: FontWeight.w700,
                              fontSize: SizeConfig.titleFontSize * 1.3,
                            ),
                            // SizedBox(
                            //   height: SizeConfig.padding / 2,
                            // ),
                            // CustomText(
                            //   text: "welcomeToAlshiaka".tr(),
                            //   fontSize: SizeConfig.textFontSize,
                            //   color: AppUI.shimmerColor,
                            // ),
                            /*SizedBox(
                        height: SizeConfig.padding,
                      ),
                      CustomButton(
                        text: "signup".tr(),
                        onPressed: () {
                          AppUtil.mainNavigator(
                              context, const AuthScreen(initialIndex: 0));
                        },
                      ),*/
                            SizedBox(
                              height: SizeConfig.padding,
                            ),
                            CustomButton(
                              text: "signin".tr(),
                              borderColor: AppUI.mainColor,
                              color: AppUI.mainColor,
                              textColor: AppUI.whiteColor,
                              onPressed: () {
                                AppUtil.mainNavigator(
                                    context, const AuthScreen());
                              },
                            ),
                            SizedBox(
                              height: SizeConfig.padding,
                            ),
                            InkWell(
                                onTap: () {
                                  AppUtil.removeUntilNavigator(
                                      context, const BottomNavTabsScreen());
                                },
                                child: CustomText(
                                  text: "continueAsGuest".tr(),
                                )),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
      ),
    );
  }

  Future<String> getImage() async {
    var url =
        "https://alshiaka.com/wp-json/settings/addon/shiaka_addon?consumer_key=ck_0aa636e54b329a08b5328b7d32ffe86f3efd8cbe&consumer_secret=cs_7e2c98933686d9859a318365364d0c7c085e557b";
    print(url);
    var header = {};
    var response;
    try {
      response = await http.get(Uri.parse(url));
      print(response.body);
      print(response.statusCode);
      print("######################################################3333");
      if (response.statusCode == 200 && response.body != null) {
        print(response.body);
        print(
            "*********************************************************************************************");
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
    print(json.decode(response.body)["sh_intro_image_apis_app"]);
    print(
        "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    return json.decode(response.body)["sh_intro_image_apis_app"];
  }
}
