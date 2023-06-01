import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'cash_helper.dart';

class NetworkHelper {
  static Future<Uri> setApi(String endPoint) async {
    String lang = await CashHelper.getSavedString("lang", "en");
    print('lang $lang');
    return Uri.parse(
        "https://alshiaka.com/${endPoint}consumer_key=ck_0aa636e54b329a08b5328b7d32ffe86f3efd8cbe&consumer_secret=cs_7e2c98933686d9859a318365364d0c7c085e557b&lang=$lang");
  }

  static String url = "https://alshiaka.com";
  static String api = "https://alshiaka.com/wp-json/wc/v3/";

  static Future repo(String endPoint, String type,
      {formData, bool headerState = true, bool key = true}) async {
    String jwt = await CashHelper.getSavedString("jwt", "");
    if (kDebugMode) {
      print(formData);
      print(jwt);
      print(endPoint);
      print(await setApi(endPoint));
    }
    Map<String, String> headers = {
      "Accept": "application/json",
      'Content-Type': 'application/json; charset=UTF-8',
      "Cookie":
          "PHPSESSID=da484818a01beeb067e4fca4df6590a3; wp-wpml_current_admin_language_d41d8cd98f00b204e9800998ecf8427e=en; wp_cocart_session_faa632a0895db538686796a171d3c521=21%7C%7C1662631025%7C%7C1662544625%7C%7C82fd0b3cc52daa5a881b7421bcaec3a6"
    };
    // "Authorization": "Bearer $jwt"
    print(setApi(endPoint));
    print(
        "-----------------------------------------------------------------------------------");
    http.Response response = type.toLowerCase() == "post"
        ? await http.post(await setApi(endPoint),
            headers: headerState ? headers : null, body: formData)
        : type.toLowerCase() == "get"
            ? await http.get(await setApi(endPoint),
                headers: headerState ? headers : null)
            : type.toLowerCase() == "put"
                ? await http.put(await setApi(endPoint),
                    headers: headerState ? headers : null, body: formData)
                : await http.delete(await setApi(endPoint),
                    headers: headerState ? headers : null);
    if (kDebugMode) {
      print(response.body);
    }
    var mapResponse = jsonDecode(response.body);
    return mapResponse;
  }
}
