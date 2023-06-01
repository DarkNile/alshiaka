import 'dart:io';

import 'package:ahshiaka/shared/cash_helper.dart';
import 'package:ahshiaka/shared/components.dart';
import 'package:ahshiaka/utilities/app_ui.dart';
import 'package:ahshiaka/utilities/app_util.dart';
import 'package:ahshiaka/view/auth/auth_screen.dart';
import 'package:ahshiaka/view/layout/bottom_nav_screen/tabs/profile/settings/setting_screen.dart';
import 'package:ahshiaka/view/layout/bottom_nav_screen/tabs/profile/social_accounts/social_accounts_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import '../../../../../bloc/profile_cubit/profile_cubit.dart';
import '../bag/checkout/address/addresses_screen.dart';
import 'change_password/change_password_screen.dart';
import 'edit_profile/edit_profile_screen.dart';
import 'my_orders/my_orders_screen.dart';
import 'package:ahshiaka/shared/CheckNetwork.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String email = "";
  bool loading = true;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    getEmail();
  }

  @override
  Widget build(BuildContext context) {
    return CheckNetwork(
      child: Scaffold(
        backgroundColor: AppUI.backgroundColor,
        body: loading
            ? Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: AppUI.whiteColor,
                      child: Stack(
                        alignment: AppUtil.rtlDirection(context)
                            ? Alignment.topLeft
                            : Alignment.topRight,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).padding.top,
                              ),
                              ListTile(
                                leading: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10000),
                                    color: AppUI.mainColor,
                                  ),
                                  padding: EdgeInsets.only(top: 3),
                                  alignment: Alignment.center,
                                  height: 38,
                                  width: 38,
                                  child: CustomText(
                                    text: "ME",
                                    color: AppUI.whiteColor,
                                    height: 1.2,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                title: CustomText(
                                  text: "hi".tr(),
                                  fontSize: 12,
                                  color: AppUI.greyColor,
                                ),
                                subtitle: email == ""
                                    ? null
                                    : CustomText(text: email),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: InkWell(
                              onTap: () {
                                AppUtil.mainNavigator(context, SettingScreen());
                              },
                              child: CircleAvatar(
                                backgroundColor: AppUI.backgroundColor,
                                radius: 20,
                                child: Icon(
                                  Icons.settings_outlined,
                                  color: AppUI.blackColor,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      color: AppUI.whiteColor,
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, top: 7, bottom: 7),
                      child: Column(
                        children: [
                          ListTile(
                            onTap: () {
                              if (email != "") {
                                AppUtil.mainNavigator(
                                    context, const EditProfileScreen());
                              } else {
                                AppUtil.errorToast(
                                    context, "youMustLoginFirst".tr(),
                                    type: "login");
                              }
                            },
                            leading: SvgPicture.asset(
                                "${AppUI.iconPath}profile.svg"),
                            title: CustomText(text: "profile".tr()),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: AppUI.blackColor,
                              size: 16,
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            onTap: () {
                              if (email == "") {
                                AppUtil.errorToast(
                                    context, "youMustLoginFirst".tr(),
                                    type: "login");
                              } else {
                                AppUtil.mainNavigator(
                                    context, const MyOrdersScreen());
                              }
                            },
                            leading:
                                SvgPicture.asset("${AppUI.iconPath}order.svg"),
                            title: CustomText(text: "myOrders".tr()),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: AppUI.blackColor,
                              size: 16,
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            onTap: () {
                              if (email != "") {
                                AppUtil.mainNavigator(
                                    context, const ChangePasswordScreen());
                              } else {
                                AppUtil.errorToast(
                                    context, "youMustLoginFirst".tr(),
                                    type: "login");
                              }
                            },
                            leading:
                                SvgPicture.asset("${AppUI.iconPath}pass.svg"),
                            title: CustomText(text: "changePass".tr()),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: AppUI.blackColor,
                              size: 16,
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            onTap: () {
                              AppUtil.mainNavigator(
                                  context,
                                  AddressesScreen(
                                    isquest: email == "",
                                  ));
                            },
                            leading: SvgPicture.asset(
                              "${AppUI.iconPath}location.svg",
                              color: AppUI.blackColor,
                              height: 20,
                            ),
                            title: CustomText(text: "addressBook".tr()),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: AppUI.blackColor,
                              size: 16,
                            ),
                          ),
                          // const Divider(),
                          // ListTile(
                          //   leading: SvgPicture.asset("${AppUI.iconPath}credit.svg",color: AppUI.blackColor,),
                          //   title: CustomText(text: "paymentMethod".tr()),
                          //   trailing: Icon(AppUtil.rtlDirection(context)?Icons.arrow_back_ios:Icons.arrow_forward_ios,color: AppUI.blackColor,size: 16,),
                          // ),
                          const Divider(),
                          ListTile(
                            onTap: () {
                              AppUtil.mainNavigator(
                                  context, const SocialAccountsScreen());
                            },
                            leading: SvgPicture.asset(
                              "${AppUI.iconPath}social.svg",
                              color: AppUI.blackColor,
                            ),
                            title: CustomText(text: "socialAccounts".tr()),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: AppUI.blackColor,
                              size: 16,
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            onTap: () {
                              launchUrlString('tel:+966920009806');
                            },
                            leading: Icon(
                              Icons.phone,
                            ),
                            title: CustomText(text: "customerService".tr()),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: AppUI.blackColor,
                              size: 16,
                            ),
                          ),
                          email == ""
                              ? SizedBox()
                              : Column(
                                  children: [
                                    const Divider(),
                                    ListTile(
                                      onTap: () {
                                        AppUtil.dialog2(
                                            context, "delete".tr(), [
                                          CustomText(
                                            text: "deleteAccount".tr(),
                                            color: AppUI.greyColor,
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              CustomButton(
                                                text: "submit".tr(),
                                                width: AppUtil.responsiveWidth(
                                                        context) *
                                                    0.3,
                                                onPressed: () {
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .pop();
                                                  deleteAccount();
                                                },
                                              ),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              CustomButton(
                                                text: "cancel".tr(),
                                                width: AppUtil.responsiveWidth(
                                                        context) *
                                                    0.3,
                                                borderColor: AppUI.greyColor,
                                                color: AppUI.whiteColor,
                                                textColor: AppUI.errorColor,
                                                onPressed: () {
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .pop();
                                                },
                                              ),
                                            ],
                                          )
                                        ]);
                                      },
                                      leading: Icon(Icons.delete_outline),
                                      title: CustomText(text: "delete".tr()),
                                      trailing: Icon(
                                        Icons.arrow_forward_ios,
                                        color: AppUI.blackColor,
                                        size: 16,
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      color: AppUI.whiteColor,
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, top: 7, bottom: 7),
                      child: ListTile(
                        onTap: () {
                          print(email);
                          print(
                              "emailllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllll");
                          if (email == "") {
                            AppUtil.mainNavigator(context, const AuthScreen());
                          } else {
                            AppUtil.dialog2(context, "logout".tr(), [
                              CustomText(
                                text: "areYouSureToLogoutFromThisAccount".tr(),
                                color: AppUI.greyColor,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  CustomButton(
                                    text: "submit".tr(),
                                    width:
                                        AppUtil.responsiveWidth(context) * 0.3,
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                      CashHelper.logOut(context);
                                    },
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  CustomButton(
                                    text: "cancel".tr(),
                                    width:
                                        AppUtil.responsiveWidth(context) * 0.3,
                                    borderColor: AppUI.greyColor,
                                    color: AppUI.whiteColor,
                                    textColor: AppUI.errorColor,
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                    },
                                  ),
                                ],
                              )
                            ]);
                          }
                        },
                        leading: SvgPicture.asset(
                          "${AppUI.iconPath}logout.svg",
                          color: AppUI.blackColor,
                        ),
                        title: CustomText(
                            text: email == "" ? "signin".tr() : "logout".tr()),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: AppUI.blackColor,
                          size: 16,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  var id;
  getEmail() async {
    await ProfileCubit.get(context).fetchCustomer();
    email = ProfileCubit.get(context).email.text;
    id = ProfileCubit.get(context).id;
    print(id);
    print(
        "idddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd");
    loading = false;
    setState(() {});
  }

  var connection = 0;
  deleteAccount() async {
    var url =
        "https://alshiaka.com/wp-json/wc/v3/customers/$id/?force=true&consumer_key=ck_0aa636e54b329a08b5328b7d32ffe86f3efd8cbe&consumer_secret=cs_7e2c98933686d9859a318365364d0c7c085e557b&lang=en";
    print(url);
    var header = {};
    try {
      final response = await http.delete(Uri.parse(url));
      print(response.body);
      print(response.statusCode);
      print("######################################################3333");
      if (response.statusCode == 200 && response.body != null) {
        print("ssssssssssssssssssssssss");
        print(response.body);
        //Navigator.of(context, rootNavigator: true).pop();
        CashHelper.logOut(context);
        setState(() {
          connection = 200;
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
