class UserModel {
  int? id;
  String? dateCreated;
  String? dateCreatedGmt;
  String? dateModified;
  String? dateModifiedGmt;
  String? email;
  String? firstName;
  String? lastName;
  String? role;
  String? username;
  Billing? billing;
  Shipping? shipping;
  bool? isPayingCustomer;
  String? avatarUrl;
  List<dynamic>? metaData;
  Links? links;

  UserModel({this.id, this.dateCreated, this.dateCreatedGmt, this.dateModified, this.dateModifiedGmt, this.email, this.firstName, this.lastName, this.role, this.username, this.billing, this.shipping, this.isPayingCustomer, this.avatarUrl, this.metaData, this.links});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    dateCreated = json["date_created"];
    dateCreatedGmt = json["date_created_gmt"];
    dateModified = json["date_modified"];
    dateModifiedGmt = json["date_modified_gmt"];
    email = json["email"];
    firstName = json["first_name"];
    lastName = json["last_name"];
    role = json["role"];
    username = json["username"];
    billing = json["billing"] == null ? null : Billing.fromJson(json["billing"]);
    shipping = json["shipping"] == null ? null : Shipping.fromJson(json["shipping"]);
    isPayingCustomer = json["is_paying_customer"];
    avatarUrl = json["avatar_url"];
    metaData = json["meta_data"] ?? [];
    links = json["_links"] == null ? null : Links.fromJson(json["_links"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["date_created"] = dateCreated;
    data["date_created_gmt"] = dateCreatedGmt;
    data["date_modified"] = dateModified;
    data["date_modified_gmt"] = dateModifiedGmt;
    data["email"] = email;
    data["first_name"] = firstName;
    data["last_name"] = lastName;
    data["role"] = role;
    data["username"] = username;
    if(billing != null) {
      data["billing"] = billing?.toJson();
    }
    if(shipping != null) {
      data["shipping"] = shipping?.toJson();
    }
    data["is_paying_customer"] = isPayingCustomer;
    data["avatar_url"] = avatarUrl;
    if(metaData != null) {
      data["meta_data"] = metaData;
    }
    if(links != null) {
      data["_links"] = links?.toJson();
    }
    return data;
  }
}

class Links {
  List<Self>? self;
  List<Collection>? collection;

  Links({this.self, this.collection});

  Links.fromJson(Map<String, dynamic> json) {
    self = json["self"]==null ? null : (json["self"] as List).map((e)=>Self.fromJson(e)).toList();
    collection = json["collection"]==null ? null : (json["collection"] as List).map((e)=>Collection.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if(self != null) {
      data["self"] = self?.map((e)=>e.toJson()).toList();
    }
    if(collection != null) {
      data["collection"] = collection?.map((e)=>e.toJson()).toList();
    }
    return data;
  }
}

class Collection {
  String? href;

  Collection({this.href});

  Collection.fromJson(Map<String, dynamic> json) {
    href = json["href"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["href"] = href;
    return data;
  }
}

class Self {
  String? href;

  Self({this.href});

  Self.fromJson(Map<String, dynamic> json) {
    href = json["href"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["href"] = href;
    return data;
  }
}

class Shipping {
  String? firstName;
  String? lastName;
  String? company;
  String? address1;
  String? address2;
  String? city;
  String? state;
  String? postcode;
  String? country;

  Shipping({this.firstName, this.lastName, this.company, this.address1, this.address2, this.city, this.state, this.postcode, this.country});

  Shipping.fromJson(Map<String, dynamic> json) {
    firstName = json["first_name"];
    lastName = json["last_name"];
    company = json["company"];
    address1 = json["address_1"];
    address2 = json["address_2"];
    city = json["city"];
    state = json["state"];
    postcode = json["postcode"];
    country = json["country"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["first_name"] = firstName;
    data["last_name"] = lastName;
    data["company"] = company;
    data["address_1"] = address1;
    data["address_2"] = address2;
    data["city"] = city;
    data["state"] = state;
    data["postcode"] = postcode;
    data["country"] = country;
    return data;
  }
}

class Billing {
  String? firstName;
  String? lastName;
  String? company;
  String? address1;
  String? address2;
  String? city;
  String? state;
  String? postcode;
  String? country;
  String? email;
  String? phone;

  Billing({this.firstName, this.lastName, this.company, this.address1, this.address2, this.city, this.state, this.postcode, this.country, this.email, this.phone});

  Billing.fromJson(Map<String, dynamic> json) {
    firstName = json["first_name"];
    lastName = json["last_name"];
    company = json["company"];
    address1 = json["address_1"];
    address2 = json["address_2"];
    city = json["city"];
    state = json["state"];
    postcode = json["postcode"];
    country = json["country"];
    email = json["email"];
    phone = json["phone"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["first_name"] = firstName;
    data["last_name"] = lastName;
    data["company"] = company;
    data["address_1"] = address1;
    data["address_2"] = address2;
    data["city"] = city;
    data["state"] = state;
    data["postcode"] = postcode;
    data["country"] = country;
    data["email"] = email;
    data["phone"] = phone;
    return data;
  }
}