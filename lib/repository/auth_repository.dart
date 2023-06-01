
import '../shared/network_helper.dart';

class AuthRepositories{

  static Future<Map<String , dynamic>> register(Map<String,dynamic>formData) async {
    return await NetworkHelper.repo("wp-json/wc/v3/customers?","post",formData: formData,headerState: false);
  }

  static Future<Map<String,dynamic>> login(formData) async {
    return await NetworkHelper.repo("wp-json/jwt-auth/v1/token?","post",formData: formData,headerState: false);
  }

  static Future<Map<String,dynamic>> sendCode(email) async {
    return await NetworkHelper.repo("wp-json/bdpwr/v1/reset-password?email=$email&","post",headerState: false,key: false);
  }

  static Future<Map<String,dynamic>> validateCode(email,code) async {
    return await NetworkHelper.repo("wp-json/bdpwr/v1/validate-code?email=$email&code=$code&","post",headerState: false,key: false);
  }

  static Future<Map<String,dynamic>> resetPassword(email,password,code) async {
    return await NetworkHelper.repo("wp-json/bdpwr/v1/set-password?email=$email&password=$password&code=$code&","post",headerState: false,key: false);
  }

  // static Future<Map<String , dynamic>> checkVerificationCode(formData) async {
  //   return await NetworkHelper.repo("check_code","post",formData: formData);
  // }
  //
  // static Future<Map<String , dynamic>> changePass(formData) async {
  //   return await NetworkHelper.repo("change_password","post",formData: formData);
  // }


}