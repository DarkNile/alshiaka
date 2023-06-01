class CouponsModel {
  int? id;
  String? code;
  String? amount;
  String? status;
  String? dateCreated;
  String? dateCreatedGmt;
  String? dateModified;
  String? dateModifiedGmt;
  String? discountType;
  String? description;
  int? usageCount;
  bool? individualUse;
  List<dynamic>? productIds;
  List<dynamic>? excludedProductIds;
  bool? freeShipping;
  List<dynamic>? productCategories;
  List<dynamic>? excludedProductCategories;
  bool? excludeSaleItems;
  String? minimumAmount;
  String? maximumAmount;
  List<dynamic>? emailRestrictions;
  List<String>? usedBy;
  List<MetaData>? metaData;
  Links? links;
  String? dateExpires;
  String? dateExpiresGmt;
  int? usageLimit;

  CouponsModel({this.id, this.code, this.amount, this.status, this.dateCreated, this.dateCreatedGmt, this.dateModified, this.dateModifiedGmt, this.discountType, this.description, this.usageCount, this.individualUse, this.productIds, this.excludedProductIds, this.freeShipping, this.productCategories, this.excludedProductCategories, this.excludeSaleItems, this.minimumAmount, this.maximumAmount, this.emailRestrictions, this.usedBy, this.metaData, this.links, this.dateExpires, this.dateExpiresGmt, this.usageLimit});

  CouponsModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    code = json["code"];
    amount = json["amount"];
    status = json["status"];
    dateCreated = json["date_created"];
    dateCreatedGmt = json["date_created_gmt"];
    dateModified = json["date_modified"];
    dateModifiedGmt = json["date_modified_gmt"];
    discountType = json["discount_type"];
    description = json["description"];
    usageCount = json["usage_count"];
    individualUse = json["individual_use"];
    productIds = json["product_ids"] ?? [];
    excludedProductIds = json["excluded_product_ids"] ?? [];
    freeShipping = json["free_shipping"];
    productCategories = json["product_categories"] ?? [];
    excludedProductCategories = json["excluded_product_categories"] ?? [];
    excludeSaleItems = json["exclude_sale_items"];
    minimumAmount = json["minimum_amount"];
    maximumAmount = json["maximum_amount"];
    emailRestrictions = json["email_restrictions"] ?? [];
    usedBy = json["used_by"]==null ? null : List<String>.from(json["used_by"]);
    metaData = json["meta_data"]==null ? null : (json["meta_data"] as List).map((e)=>MetaData.fromJson(e)).toList();
    links = json["_links"] == null ? null : Links.fromJson(json["_links"]);
    dateExpires = json["date_expires"];
    dateExpiresGmt = json["date_expires_gmt"];
    usageLimit = json["usage_limit"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["code"] = code;
    data["amount"] = amount;
    data["status"] = status;
    data["date_created"] = dateCreated;
    data["date_created_gmt"] = dateCreatedGmt;
    data["date_modified"] = dateModified;
    data["date_modified_gmt"] = dateModifiedGmt;
    data["discount_type"] = discountType;
    data["description"] = description;
    data["usage_count"] = usageCount;
    data["individual_use"] = individualUse;
    if(productIds != null) {
      data["product_ids"] = productIds;
    }
    if(excludedProductIds != null) {
      data["excluded_product_ids"] = excludedProductIds;
    }
    data["free_shipping"] = freeShipping;
    if(productCategories != null) {
      data["product_categories"] = productCategories;
    }
    if(excludedProductCategories != null) {
      data["excluded_product_categories"] = excludedProductCategories;
    }
    data["exclude_sale_items"] = excludeSaleItems;
    data["minimum_amount"] = minimumAmount;
    data["maximum_amount"] = maximumAmount;
    if(emailRestrictions != null) {
      data["email_restrictions"] = emailRestrictions;
    }
    if(usedBy != null) {
      data["used_by"] = usedBy;
    }
    if(metaData != null) {
      data["meta_data"] = metaData?.map((e)=>e.toJson()).toList();
    }
    if(links != null) {
      data["_links"] = links?.toJson();
    }
    data["date_expires"] = dateExpires;
    data["date_expires_gmt"] = dateExpiresGmt;
    data["usage_limit"] = usageLimit;
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

class MetaData {
  int? id;
  String? key;
  dynamic value;

  MetaData({this.id, this.key, this.value});

  MetaData.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    key = json["key"];
    value = json["value"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["key"] = key;
    data["value"] = value;
    return data;
  }
}