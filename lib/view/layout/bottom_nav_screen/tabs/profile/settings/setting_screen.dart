import 'dart:developer';
import 'package:ahshiaka/main.dart';
import 'package:ahshiaka/shared/cash_helper.dart';
import 'package:ahshiaka/utilities/cache_helper.dart';
import 'package:ahshiaka/view/layout/bottom_nav_screen/tabs/profile/settings/Condition.dart';
import 'package:dash_flags/dash_flags.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ahshiaka/shared/CheckNetwork.dart';
import '../../../../../../shared/components.dart';
import '../../../../../../utilities/app_ui.dart';
import '../../../../../../utilities/app_util.dart';
import 'contact_us.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String countryCode = '';
  @override
  void initState() {
    countryCode = CacheHelper.read("Country Code") ?? "SA";
    log("countryCode ${countryCode}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CheckNetwork(
      child: Scaffold(
        backgroundColor: AppUI.backgroundColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              CustomAppBar(title: "settings".tr()),
              const SizedBox(
                height: 20,
              ),
              Container(
                color: AppUI.whiteColor,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ListTile(
                      onTap: () {
                        // AppUtil.mainNavigator(context, EditProfileScreen());
                      },
                      leading: CountryFlag(
                        country: Country.fromCode(countryCode),
                        height: 25,
                      ), //  Image.asset(
                      //   "${AppUI.iconPath}flag.png",
                      //   width: 25,
                      // ),
                      title: CustomText(text: "country".tr()),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CustomText(
                                text: countryCode.toLowerCase() == "sa"
                                    ? "Saudi"
                                    : "Country",
                                fontWeight: FontWeight.w100,
                                color: AppUI.greyColor),
                            const SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: AppUI.blackColor,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      onTap: () {
                        // AppUtil.mainNavigator(context, MyOrdersScreen());
                      },
                      leading: Stack(
                        alignment: Alignment.center,
                        children: [
                          SvgPicture.asset("${AppUI.iconPath}currency.svg"),
                          SvgPicture.asset("${AppUI.iconPath}dolar.svg"),
                        ],
                      ),
                      title: CustomText(text: "currency".tr()),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CustomText(
                              text: "SAR",
                              fontWeight: FontWeight.w100,
                              color: AppUI.greyColor,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: AppUI.blackColor,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      onTap: () async {
                        // AppUtil.mainNavigator(context, ChangePasswordScreen());
                        int i = 0;
                        await AppUtil.dialog2(context, "language".tr(), [
                          InkWell(
                              onTap: () async {
                                i = 1;
                                await CashHelper.setSavedString("lang", "en");
                                if (!mounted) return;
                                await context.setLocale(const Locale("en"));
                                if (!mounted) return;
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                              child: const CustomText(text: "English")),
                          const Divider(),
                          InkWell(
                              onTap: () async {
                                i = 1;
                                await CashHelper.setSavedString("lang", "ar");
                                if (!mounted) return;
                                await context.setLocale(const Locale("ar"));
                                if (!mounted) return;
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                              child: const CustomText(text: "العربية")),
                        ]);
                        if (!mounted) return;
                        if (i == 1) {
                          AppUtil.removeUntilNavigator(context, const MyApp());
                        }
                      },
                      leading: SvgPicture.asset("${AppUI.iconPath}lang.svg"),
                      title: CustomText(text: "language".tr()),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CustomText(
                              text: AppUtil.rtlDirection(context)
                                  ? "العربية"
                                  : "English",
                              fontWeight: FontWeight.w100,
                              color: AppUI.greyColor,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: AppUI.blackColor,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // const Divider(),
                    // ListTile(
                    //   onTap: (){
                    //     // AppUtil.mainNavigator(context, AddressesScreen());
                    //   },
                    //   leading: SvgPicture.asset("${AppUI.iconPath}terms.svg",color: AppUI.blackColor,height: 20,),
                    //   title: CustomText(text: "terms".tr()),
                    //   trailing: Icon(AppUtil.rtlDirection(context)?Icons.arrow_back_ios:Icons.arrow_forward_ios,color: AppUI.blackColor,size: 16,),
                    // ),
                    // const Divider(),
                    // ListTile(
                    //   leading: SvgPicture.asset("${AppUI.iconPath}credit.svg",color: AppUI.blackColor,),
                    //   title: CustomText(text: "paymentMethod".tr()),
                    //   trailing: Icon(AppUtil.rtlDirection(context)?Icons.arrow_back_ios:Icons.arrow_forward_ios,color: AppUI.blackColor,size: 16,),
                    // ),
                    // const Divider(),
                    // ListTile(
                    //   onTap: (){
                    //     // AppUtil.mainNavigator(context, SocialAccountsScreen());
                    //   },
                    //   leading: SvgPicture.asset("${AppUI.iconPath}social.svg",color: AppUI.blackColor,),
                    //   title: CustomText(text: "socialAccounts".tr()),
                    //   trailing: Icon(AppUtil.rtlDirection(context)?Icons.arrow_back_ios:Icons.arrow_forward_ios,color: AppUI.blackColor,size: 16,),
                    // ),
                    const Divider(),
                    ListTile(
                      onTap: () {
                        AppUtil.mainNavigator(context, ContactUs());
                      },
                      leading: SvgPicture.asset(
                        "${AppUI.iconPath}contact.svg",
                        color: AppUI.blackColor,
                      ),
                      title: CustomText(text: "help".tr()),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: AppUI.blackColor,
                        size: 16,
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      onTap: () {
                        AppUtil.mainNavigator(context, Condition());
                      },
                      leading: SvgPicture.asset(
                        "${AppUI.iconPath}terms.svg",
                        color: AppUI.blackColor,
                      ),
                      title: CustomText(text: "condition".tr()),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: AppUI.blackColor,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
