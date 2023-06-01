import 'package:ahshiaka/shared/cash_helper.dart';

class ShippingModel {
  Shipping? shipping;

  ShippingModel({this.shipping});

  ShippingModel.fromJson(Map<String, dynamic> json) {
    shipping = json["shipping"] == null ? null : Shipping.fromJson(json["shipping"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if(shipping != null) {
      data["shipping"] = shipping?.toJson();
    }
    return data;
  }
}

class Shipping {
  List<Address0>? address0 = [];
  List<String>? addressesKey;
  Shipping({this.address0,this.addressesKey});

  Shipping.fromJson(Map<String, dynamic> json) {
    int i = 0;
    addressesKey= [];
    json.forEach((key, value) {
      addressesKey!.add(key);
      address0!.add(Address0.fromJson(json[key])) ;
      i++;
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    int i = 0;
    data.forEach((key, value) {
      data["address_$i"] = address0![i].toJson();
      i++;
    });

    return data;
  }
}

class Address0 {
  String? shippingFirstName;
  String? shippingLastName;
  String? shippingCountry;
  String? shippingAddress1;
  String? shippingCity;
  String? shippingCompany;
  String? shippingAddress2;
  String? shippingState;
  String? shippingPostcode;
  String? shippingPhone;
  String? shippingEmail;

  Address0({this.shippingFirstName, this.shippingLastName, this.shippingCountry, this.shippingAddress1, this.shippingCity, this.shippingCompany, this.shippingAddress2, this.shippingState, this.shippingPostcode, this.shippingPhone, this.shippingEmail});

  Address0.fromJson(Map<String, dynamic> json) {
    shippingFirstName = json["shipping_first_name"];
    shippingLastName = json["shipping_last_name"];
    shippingCountry = json["shipping_country"];
    shippingAddress1 = json["shipping_address_1"];
    shippingCity = json["shipping_city"];
    shippingCompany = json["shipping_company"];
    shippingAddress2 = json["shipping_address_2"];
    shippingState = json["shipping_state"];
    shippingPostcode = json["shipping_postcode"];
    shippingPhone = json["shipping_phone"];
    shippingEmail = json["shipping_email"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["shipping_first_name"] = shippingFirstName;
    data["shipping_last_name"] = shippingLastName;
    data["shipping_country"] = shippingCountry;
    data["shipping_address_1"] = shippingAddress1;
    data["shipping_city"] = shippingCity;
    data["shipping_company"] = shippingCompany;
    data["shipping_address_2"] = shippingAddress2;
    data["shipping_state"] = shippingState;
    data["shipping_postcode"] = shippingPostcode;
    data["shipping_phone"] = shippingPhone;
    data["shipping_email"] = shippingEmail;
    return data;
  }
}