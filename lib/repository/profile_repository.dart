import '../shared/network_helper.dart';

class ProfileRepository{
  static Future fetchCustomer(email) async {
    return await NetworkHelper.repo("wp-json/wc/v3/customers?email=$email&","get",headerState: false);
  }

  static Future editCustomer(id,data) async {
    return await NetworkHelper.repo("wp-json/wc/v3/customers/$id?","put",formData: data,headerState: true);
  }

  static Future changePass(data) async {
    return await NetworkHelper.repo("wp-json/customer/update/password?","post",formData: data,headerState: false);
  }

  static Future contactUs(data) async {
    return await NetworkHelper.repo("wp-json/contact/mobileapp/send?","post",formData: data,headerState: false);
  }

  static Future terms(data) async {
    return await NetworkHelper.repo("wp-json/settings/page/terms?","get",headerState: false);
  }

  static Future track(orderId) async {
    return await NetworkHelper.repo("wp-json/order/shipment/tracking?order_id=$orderId&","get",headerState: false);
  }

  static Future getPhone (email) async {
    return await NetworkHelper.repo("wp-json/customer/phone/get?email=$email&","get",headerState: false);
  }

  static Future updatePhone (email,phone) async {
    return await NetworkHelper.repo("wp-json/customer/phone/update?email=$email&phone=$phone&","post",headerState: false);
  }

}