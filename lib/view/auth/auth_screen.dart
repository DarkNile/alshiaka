import 'package:ahshiaka/utilities/app_util.dart';
import 'package:ahshiaka/utilities/size_config.dart';
import 'package:ahshiaka/view/auth/tabs/sign_in.dart';
import 'package:ahshiaka/view/auth/tabs/sign_up.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../shared/components.dart';
import '../../utilities/app_ui.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Stack(
      children: [
        Scaffold(
          appBar: customAppBar(
            title: "",
            toolbarHeight: 0.0,
            elevation: 0,
            //bottomChildHeight: 100.0,
            bottomChildHeight: SizeConfig.safeBlockVertical * 20,
            bottomChild: Container(
              alignment: Alignment.center,
              //height: 100,
              height: SizeConfig.safeBlockVertical * 20,
              child: Image.asset(
                "${AppUI.imgPath}logo.png",
                //height: 33,
                height: SizeConfig.safeBlockVertical * 7,
              ),
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: AppUI.whiteColor,
                child: Column(
                  children: [
                    Container(
                      height: 0.5,
                      width: double.infinity,
                      color: AppUI.shimmerColor,
                    ),
                    /*  TabBar(
                          controller: tabBarController,
                          indicatorWeight: 4,
                          indicatorColor: AppUI.mainColor,
                          indicatorPadding: EdgeInsets.symmetric(
                              horizontal: AppUtil.responsiveWidth(context) * 0.15),
                          // isScrollable: true,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          physics: const BouncingScrollPhysics(),
                          tabs: <Widget>[
                            Tab(
                              child: Text("signup".tr(),
                                  style: TextStyle(
                                      color: AppUI.mainColor,
                                      fontSize: SizeConfig.titleFontSize,
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center),
                            ),
                            Tab(
                              child: Text("signin".tr(),
                                  style: TextStyle(
                                      color: AppUI.mainColor,
                                      fontSize: SizeConfig.titleFontSize,
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center),
                            ),
                          ]),*/
                    Container(
                      height: 0.5,
                      width: double.infinity,
                      color: AppUI.shimmerColor,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SignIn(),
              ),
            ],
          ),
        ),
        Positioned(
          top: 60,
          right: 30,
          child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(
                AppUtil.rtlDirection(context)
                    ? Icons.arrow_back
                    : Icons.arrow_forward,
                // Icons.arrow_back,
                size: 30,
              )),
        )
      ],
    );
  }
}
