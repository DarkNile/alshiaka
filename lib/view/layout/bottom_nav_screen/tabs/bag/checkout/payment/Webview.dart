import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../../../../bloc/layout_cubit/checkout_cubit/checkout_cubit.dart';
import '../../../../../../../bloc/layout_cubit/checkout_cubit/checkout_state.dart';
import '../../../../../../../shared/components.dart';
import '../../../../../../../utilities/app_util.dart';
import '../../../../bottom_nav_tabs_screen.dart';

class CustomWebview extends StatefulWidget {
  String url;
  String type;
  String orderId;

  CustomWebview({
    required this.url,
    required this.type,
    required this.orderId,
  });
  @override
  State<StatefulWidget> createState() {
    return _state();
  }
}

class _state extends State<CustomWebview> {
  @override
  void initState() {
    super.initState();
    print(widget.url);
    print("----------------------------------");
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    log("CustomWebview");
    final cubit = CheckoutCubit.get(context);
    // TODO: implement build
    return WillPopScope(
      onWillPop: () async {
        AppUtil.removeUntilNavigator(context, const BottomNavTabsScreen());
        return true;
      },
      child: Scaffold(
        body: Container(
            child: Column(
          children: [
            CustomAppBar(
                title: "checkout".tr(),
                onBack: () {
                  AppUtil.removeUntilNavigator(
                      context, const BottomNavTabsScreen());
                }),
            Expanded(
              child: WebView(
                navigationDelegate: (NavigationRequest request) async {
                  print('allowing navigation to $request');
                  if (request.url.contains("order-received")) {
                    cubit.sendEmail(widget.orderId);
                  }

                  if (widget.type == "taby") {
                    if (request.url.contains("tap_id=")) {
                      cubit.fetchCartList(context);
                      AppUtil.removeUntilNavigator(
                          context, const BottomNavTabsScreen());
                    }
                  }
                  return NavigationDecision.navigate;
                },
                gestureNavigationEnabled: true,
                javascriptMode: JavascriptMode.unrestricted,
                initialUrl: Uri.parse(widget.url).toString(),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
