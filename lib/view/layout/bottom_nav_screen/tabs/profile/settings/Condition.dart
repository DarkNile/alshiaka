import 'dart:convert';

import 'package:ahshiaka/bloc/profile_cubit/profile_cubit.dart';
import 'package:ahshiaka/shared/components.dart';
import 'package:ahshiaka/utilities/app_util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ahshiaka/shared/CheckNetwork.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class Condition extends StatefulWidget {
  @override
  _ConditionState createState() => _ConditionState();
}

class _ConditionState extends State<Condition> {
  bool loading = true;
  Map<String, dynamic> data = {};
  loadData() async {
    data = await getData();
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return CheckNetwork(
      child: Scaffold(
          appBar: customAppBar(title: "condition".tr(), elevation: 0),
          body: loading
              ? Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 15, right: 15, top: 20),
                  child: Text(
                    AppUtil.rtlDirection(context)
                        ? data["order_terms_ar"]!
                        : data["order_terms_en"]!,
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 13),
                  ))),
    );
  }

  Future<Map<String, dynamic>> getData() async {
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
    print(json.decode(response.body));
    print(
        "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    return json.decode(response.body);
  }
}
