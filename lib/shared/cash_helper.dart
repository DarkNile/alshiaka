import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../utilities/app_util.dart';


class CashHelper{
  // Retrieve string data stored
  static Future<String> getSavedString(String value,String defaultVal) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String savedValue = _prefs.getString(value) ?? defaultVal;
    return savedValue;
  }

// Store String data
  static Future<bool> setSavedString(String key,String value) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    bool savedValue =await _prefs.setString(key,value);
    return savedValue;
  }

// remove String data
  static Future removeSavedString(String key) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
      await _prefs.remove(key);
  }

  static logOut(context) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.remove("jwt");
    await _prefs.remove("user");
    await _prefs.remove("email");
    AppUtil.replacementNavigator(context, const MyApp());
  }

}