import 'dart:convert';

import '../shared/network_helper.dart';
import 'package:http/http.dart' as http;

class CheckoutRepository {
  static Future fetchCoupons() async {
    return await NetworkHelper.repo("wp-json/wc/v3/coupons?", "get",
        headerState: false);
  }

  static Future fetchShippingMethods() async {
    return await NetworkHelper.repo(
        "wp-json/wc/v3/shipping/zones/1/methods?", "get",
        headerState: false);
  }

  static Future fetchFreeShippingMethods() async {
    return await NetworkHelper.repo(
        "wp-json/shipping/free/active-method?", "get",
        headerState: false);
  }

  static Future fetchPaymentGetaways() async {
    return await NetworkHelper.repo("wp-json/wc/v3/payment_gateways?", "get",
        headerState: false);
  }

  static Future sendPhone(phone) async {
    return await NetworkHelper.repo(
        "wp-json/customer/otp/send?phone=$phone&", "get",
        headerState: false);
  }

  static Future verifyPhone(phone, code) async {
    return await NetworkHelper.repo(
        "wp-json/customer/otp/verify?phone=$phone&code=$code&", "get",
        headerState: false);
  }

  static Future sendEmail(orderId) async {
    return await NetworkHelper.repo(
        "wp-json/order/update/status?order_id=$orderId&", "get",
        headerState: false);
  }

  static Future fetchAddresses(email) async {
    return await NetworkHelper.repo(
        "wp-json/customer/addresses/get?email=$email&", "get",
        headerState: false);
  }

  static Future deleteAddress(addressKey, email) async {
    return await NetworkHelper.repo(
        "wp-json/customer/addresses/delete?email=$email&type=shipping&address_id=$addressKey&",
        "delete",
        headerState: false);
  }

  static Future createOrder(formData, {customer}) async {
    return await NetworkHelper.repo(
        "wp-json/wc/v3/orders/?customer_id=$customer&", "post",
        formData: formData, headerState: true);
  }

  //? ====== Aramex ======
  static Future<http.Response> getTaxAramex(
      {required String country,
      required String city,
      required String numberOfPieces,
      required String actualWeight}) async {
    return await http.get(
      Uri.parse(
        "https://alshiaka.com/wp-json/aramex-shipping-rate/calc/api?consumer_key=ck_0aa636e54b329a08b5328b7d32ffe86f3efd8cbe&consumer_secret=cs_7e2c98933686d9859a318365364d0c7c085e557b&country=$country&city=$city&numberofpieces=$numberOfPieces&actualweight=$actualWeight",
      ),
      headers: {
        "Accept": "application/json",
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

  static Future saveAddress(formData, email, {String? address_id}) async {
    return await NetworkHelper.repo(
        address_id == null
            ? "wp-json/customer/addresses/add?email=$email&type=shipping&"
            : "wp-json/customer/addresses/update?email=$email&type=shipping&address_id=$address_id&",
        address_id == null ? "post" : "put",
        formData: formData,
        headerState: false);
  }

  static Future fetchOrders(email, {customer}) async {
    if (customer != "0") {
      return await NetworkHelper.repo(
          "wp-json/wc/v3/orders?customer=$customer&per_page=100&", "get",
          headerState: false);
    } else {
      return await NetworkHelper.repo(
          "wp-json/wc/v3/orders?search=$email&customer=$customer&per_page=100&",
          "get",
          headerState: false);
    }
  }

  static Future deleteOrder(id) async {
    return await NetworkHelper.repo("wp-json/wc/v3/orders/$id?", "delete",
        headerState: false);
  }

  static Future updateOrder(orderId) async {
    return await NetworkHelper.repo("wp-json/wc/v3/orders/$orderId?", "put",
        formData: {"set_paid": "true"}, headerState: false);
  }

  static Future hasCode(email) async {
    return await NetworkHelper.repo(
        "wp-json/customer/email/coupons?email=$email&", "get",
        headerState: true);
  }

  static Future<int> payWithPayfort(formData) async {
    http.Response response = await http.post(
        Uri.parse("https://sbpaymentservices.payfort.com/FortAPI/paymentApi"),
        body: jsonEncode(formData),
        headers: {"Accept": "application/json"});
    return response.statusCode;
  }

  static Future<Map<String, dynamic>> fetchCountries() async {
    http.Response response = await http.get(
        Uri.parse(
            "https://alshiaka.com/wp-json/woocommerce/countries/fetch?consumer_key=ck_0aa636e54b329a08b5328b7d32ffe86f3efd8cbe&consumer_secret=cs_7e2c98933686d9859a318365364d0c7c085e557b"),
        headers: {"Accept": "application/json"});

    if (response.statusCode != 200) {
      return {
        "error": response.body,
      };
    }

    var data = jsonDecode(response.body);

    return data[0];
  }
}
