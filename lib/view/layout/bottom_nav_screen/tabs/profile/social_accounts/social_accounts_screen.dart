import 'package:ahshiaka/shared/components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ahshiaka/shared/CheckNetwork.dart';
import '../../../../../../utilities/app_ui.dart';
class SocialAccountsScreen extends StatefulWidget {
  const SocialAccountsScreen({Key? key}) : super(key: key);

  @override
  _SocialAccountsScreenState createState() => _SocialAccountsScreenState();
}

class _SocialAccountsScreenState extends State<SocialAccountsScreen> {
  @override
  Widget build(BuildContext context) {
    return CheckNetwork(
      child: Scaffold(
        backgroundColor: AppUI.backgroundColor,
        body: Column(
          children: [
            CustomAppBar(title: "socialAccounts".tr()),
            const SizedBox(height: 16,),
            Container(
              color: AppUI.whiteColor,
              padding: const EdgeInsets.all(8),
              child: ListTile(
                onTap: (){
                  // AppUtil.mainNavigator(context, SocialAccountsScreen());
                  launch("https://www.facebook.com/Alshiakaa/");
                },
                leading: SvgPicture.asset("${AppUI.iconPath}face.svg",),
                title: CustomText(text: "Facebook".tr()),
              ),
            ),
            const SizedBox(height: 16,),
            Container(
              color: AppUI.whiteColor,
              padding: const EdgeInsets.all(8),
              child: ListTile(
                onTap: (){
                  // AppUtil.mainNavigator(context, SocialAccountsScreen());
                  launch("https://www.instagram.com/alshiaka/");
                },
                leading: Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset("${AppUI.iconPath}insta.svg",),
                    FaIcon(FontAwesomeIcons.instagram,color: AppUI.whiteColor,)
                  ],
                ),
                title: CustomText(text: "Instagram".tr()),
              ),
            ),

            const SizedBox(height: 16,),
            Container(
              color: AppUI.whiteColor,
              padding: const EdgeInsets.all(8),
              child: ListTile(
                onTap: (){
                  // AppUtil.mainNavigator(context, SocialAccountsScreen());
                  launch("https://twitter.com/alshiaka");
                },
                leading: SvgPicture.asset("${AppUI.iconPath}twitter.svg",),
                title: CustomText(text: "Twitter".tr()),
              ),
            ),

            const SizedBox(height: 16,),
            Container(
              color: AppUI.whiteColor,
              padding: const EdgeInsets.all(8),
              child: ListTile(
                onTap: (){
                  // AppUtil.mainNavigator(context, SocialAccountsScreen());
                  launch("https://www.youtube.com/channel/UC2mRhWAq9Jl5ByZssef3KKA");
                },
                leading: CircleAvatar(
                  backgroundColor: AppUI.backgroundColor,
                    child: SvgPicture.asset("${AppUI.iconPath}youtube.svg",)),
                title: CustomText(text: "youtube".tr()),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
