class CartModel {
  String? cartHash;
  String? cartKey;
  Currency? currency;
  Customer? customer;
  List<Items>? items;
  int? itemCount;
  int? itemsWeight;
  List<dynamic>? coupons;
  bool? needsPayment;
  bool? needsShipping;
  Shipping? shipping;
  List<dynamic>? fees;
  dynamic taxes;
  Totals1? totals;
  List<dynamic>? removedItems;
  List<CrossSells>? crossSells;
  dynamic notices;

  CartModel({this.cartHash, this.cartKey, this.currency, this.customer, this.items, this.itemCount, this.itemsWeight, this.coupons, this.needsPayment, this.needsShipping, this.shipping, this.fees, this.taxes, this.totals, this.removedItems, this.crossSells, this.notices});

  CartModel.fromJson(Map<String, dynamic> json) {
    cartHash = json["cart_hash"];
    cartKey = json["cart_key"];
    currency = json["currency"] == null ? null : Currency.fromJson(json["currency"]);
    customer = json["customer"] == null ? null : Customer.fromJson(json["customer"]);
    items = json["items"]==null ? null : (json["items"] as List).map((e)=>Items.fromJson(e)).toList();
    itemCount = json["item_count"];
    itemsWeight = json["items_weight"];
    coupons = json["coupons"] ?? [];
    needsPayment = json["needs_payment"];
    needsShipping = json["needs_shipping"];
    shipping = json["shipping"] == null ? null : Shipping.fromJson(json["shipping"]);
    fees = json["fees"] ?? [];
    taxes = json["taxes"] ?? [];
    totals = json["totals"] == null ? null : Totals1.fromJson(json["totals"]);
    removedItems = json["removed_items"] ?? [];
    crossSells = json["cross_sells"]==null ? null : (json["cross_sells"] as List).map((e)=>CrossSells.fromJson(e)).toList();
    notices = json["notices"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["cart_hash"] = cartHash;
    data["cart_key"] = cartKey;
    if(currency != null) {
      data["currency"] = currency?.toJson();
    }
    if(customer != null) {
      data["customer"] = customer?.toJson();
    }
    if(items != null) {
      data["items"] = items?.map((e)=>e.toJson()).toList();
    }
    data["item_count"] = itemCount;
    data["items_weight"] = itemsWeight;
    if(coupons != null) {
      data["coupons"] = coupons;
    }
    data["needs_payment"] = needsPayment;
    data["needs_shipping"] = needsShipping;
    if(shipping != null) {
      data["shipping"] = shipping?.toJson();
    }
    if(fees != null) {
      data["fees"] = fees;
    }
    if(taxes != null) {
      data["taxes"] = taxes;
    }
    if(totals != null) {
      data["totals"] = totals?.toJson();
    }
    if(removedItems != null) {
      data["removed_items"] = removedItems;
    }
    if(crossSells != null) {
      data["cross_sells"] = crossSells?.map((e)=>e.toJson()).toList();
    }
    if(notices != null) {
      data["notices"] = notices?.toJson();
    }
    return data;
  }
}

class Notices {
  List<String>? success;

  Notices({this.success});

  Notices.fromJson(Map<String, dynamic> json) {
    success = json["success"]==null ? null : List<String>.from(json["success"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if(success != null) {
      data["success"] = success;
    }
    return data;
  }
}

class CrossSells {
  int? id;
  String? name;
  String? title;
  String? slug;
  String? price;
  String? regularPrice;
  String? salePrice;
  String? image;
  String? averageRating;
  bool? onSale;
  String? type;

  CrossSells({this.id, this.name, this.title, this.slug, this.price, this.regularPrice, this.salePrice, this.image, this.averageRating, this.onSale, this.type});

  CrossSells.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    title = json["title"];
    slug = json["slug"];
    price = json["price"];
    regularPrice = json["regular_price"];
    salePrice = json["sale_price"];
    image = json["image"];
    averageRating = json["average_rating"];
    onSale = json["on_sale"];
    type = json["type"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["name"] = name;
    data["title"] = title;
    data["slug"] = slug;
    data["price"] = price;
    data["regular_price"] = regularPrice;
    data["sale_price"] = salePrice;
    data["image"] = image;
    data["average_rating"] = averageRating;
    data["on_sale"] = onSale;
    data["type"] = type;
    return data;
  }
}

class Totals1 {
  String? subtotal;
  String? subtotalTax;
  String? feeTotal;
  String? feeTax;
  String? discountTotal;
  String? discountTax;
  String? shippingTotal;
  String? shippingTax;
  String? total;
  String? totalTax;

  Totals1({this.subtotal, this.subtotalTax, this.feeTotal, this.feeTax, this.discountTotal, this.discountTax, this.shippingTotal, this.shippingTax, this.total, this.totalTax});

  Totals1.fromJson(Map<String, dynamic> json) {
    subtotal = json["subtotal"];
    subtotalTax = json["subtotal_tax"];
    feeTotal = json["fee_total"];
    feeTax = json["fee_tax"];
    discountTotal = json["discount_total"];
    discountTax = json["discount_tax"];
    shippingTotal = json["shipping_total"];
    shippingTax = json["shipping_tax"];
    total = json["total"];
    totalTax = json["total_tax"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["subtotal"] = subtotal;
    data["subtotal_tax"] = subtotalTax;
    data["fee_total"] = feeTotal;
    data["fee_tax"] = feeTax;
    data["discount_total"] = discountTotal;
    data["discount_tax"] = discountTax;
    data["shipping_total"] = shippingTotal;
    data["shipping_tax"] = shippingTax;
    data["total"] = total;
    data["total_tax"] = totalTax;
    return data;
  }
}

class Shipping {
  int? totalPackages;
  bool? showPackageDetails;
  bool? hasCalculatedShipping;
  Packages? packages;

  Shipping({this.totalPackages, this.showPackageDetails, this.hasCalculatedShipping, this.packages});

  Shipping.fromJson(Map<String, dynamic> json) {
    totalPackages = json["total_packages"];
    showPackageDetails = json["show_package_details"];
    hasCalculatedShipping = json["has_calculated_shipping"];
    // packages = json["packages"] == null ? null : Packages.fromJson(json["packages"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["total_packages"] = totalPackages;
    data["show_package_details"] = showPackageDetails;
    data["has_calculated_shipping"] = hasCalculatedShipping;
    if(packages != null) {
      data["packages"] = packages?.toJson();
    }
    return data;
  }
}

class Packages {
  Default? defaultt;

  Packages({this.defaultt});

  Packages.fromJson(Map<String, dynamic> json) {
    defaultt = json["default"] == null ? null : Default.fromJson(json["default"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if(defaultt != null) {
      data["default"] = defaultt?.toJson();
    }
    return data;
    }
}

class Default {
  String? packageName;
  Rates? rates;
  String? packageDetails;
  int? index;
  String? chosenMethod;
  String? formattedDestination;

  Default({this.packageName, this.rates, this.packageDetails, this.index, this.chosenMethod, this.formattedDestination});

  Default.fromJson(Map<String, dynamic> json) {
    packageName = json["package_name"];
    rates = json["rates"] == null ? null : Rates.fromJson(json["rates"]);
    packageDetails = json["package_details"];
    index = json["index"];
    chosenMethod = json["chosen_method"];
    formattedDestination = json["formatted_destination"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["package_name"] = packageName;
    if(rates != null) {
      data["rates"] = rates?.toJson();
    }
    data["package_details"] = packageDetails;
    data["index"] = index;
    data["chosen_method"] = chosenMethod;
    data["formatted_destination"] = formattedDestination;
    return data;
  }
}

class Rates {
  FlatRate? flatRate;

  Rates({this.flatRate});

  Rates.fromJson(Map<String, dynamic> json) {
    flatRate = json["flat_rate:3"] == null ? null : FlatRate.fromJson(json["flat_rate:3"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if(flatRate != null) {
      data["flat_rate:3"] = flatRate?.toJson();
    }
    return data;
    }
}

class FlatRate {
String? key;
String? methodId;
int? instanceId;
String? label;
String? cost;
String? html;
String? taxes;
bool? chosenMethod;
MetaData? metaData;

FlatRate({this.key, this.methodId, this.instanceId, this.label, this.cost, this.html, this.taxes, this.chosenMethod, this.metaData});

FlatRate.fromJson(Map<String, dynamic> json) {
key = json["key"];
methodId = json["method_id"];
instanceId = json["instance_id"];
label = json["label"];
cost = json["cost"];
html = json["html"];
taxes = json["taxes"];
chosenMethod = json["chosen_method"];
metaData = json["meta_data"] == null ? null : MetaData.fromJson(json["meta_data"]);
}

Map<String, dynamic> toJson() {
final Map<String, dynamic> data = <String, dynamic>{};
data["key"] = key;
data["method_id"] = methodId;
data["instance_id"] = instanceId;
data["label"] = label;
data["cost"] = cost;
data["html"] = html;
data["taxes"] = taxes;
data["chosen_method"] = chosenMethod;
if(metaData != null) {
  data["meta_data"] = metaData?.toJson();
}
return data;
}
}

class MetaData {
  String? items;

  MetaData({this.items});

  MetaData.fromJson(Map<String, dynamic> json) {
    items = json["items"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["items"] = items;
    return data;
  }
}

class Items {
  String? itemKey;
  int? id;
  String? name;
  String? title;
  String? price;
  Quantity? quantity;
  Totals? totals;
  String? slug;
  Meta? meta;
  String? backorders;
  List<dynamic>? cartItemData;
  String? featuredImage;

  Items({this.itemKey, this.id, this.name, this.title, this.price, this.quantity, this.totals, this.slug, this.meta, this.backorders, this.cartItemData, this.featuredImage});

  Items.fromJson(Map<String, dynamic> json) {
    itemKey = json["item_key"];
    id = json["id"];
    name = json["name"];
    title = json["title"];
    price = json["price"];
    quantity = json["quantity"] == null ? null : Quantity.fromJson(json["quantity"]);
    totals = json["totals"] == null ? null : Totals.fromJson(json["totals"]);
    slug = json["slug"];
    meta = json["meta"] == null ? null : Meta.fromJson(json["meta"]);
    backorders = json["backorders"];
    cartItemData = json["cart_item_data"] ?? [];
    featuredImage = json["featured_image"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["item_key"] = itemKey;
    data["id"] = id;
    data["name"] = name;
    data["title"] = title;
    data["price"] = price;
    if(quantity != null) {
      data["quantity"] = quantity?.toJson();
    }
    if(totals != null) {
      data["totals"] = totals?.toJson();
    }
    data["slug"] = slug;
    if(meta != null) {
      data["meta"] = meta?.toJson();
    }
    data["backorders"] = backorders;
    if(cartItemData != null) {
      data["cart_item_data"] = cartItemData;
    }
    data["featured_image"] = featuredImage;
    return data;
  }
}

class Meta {
  String? productType;
  String? sku;
  Dimensions? dimensions;
  int? weight;
  dynamic variation;

  Meta({this.productType, this.sku, this.dimensions, this.weight, this.variation});

  Meta.fromJson(Map<String, dynamic> json) {
    productType = json["product_type"];
    sku = json["sku"];
    dimensions = json["dimensions"] == null ? null : Dimensions.fromJson(json["dimensions"]);
    weight = json["weight"];
    variation = json["variation"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["product_type"] = productType;
    data["sku"] = sku;
    if(dimensions != null) {
      data["dimensions"] = dimensions?.toJson();
    }
    data["weight"] = weight;
    if(variation != null) {
      data["variation"] = variation?.toJson();
    }
    return data;
  }
}

class Dimensions {
  String? length;
  String? width;
  String? height;
  String? unit;

  Dimensions({this.length, this.width, this.height, this.unit});

  Dimensions.fromJson(Map<String, dynamic> json) {
    length = json["length"];
    width = json["width"];
    height = json["height"];
    unit = json["unit"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["length"] = length;
    data["width"] = width;
    data["height"] = height;
    data["unit"] = unit;
    return data;
  }
}

class Totals {
  String? subtotal;
  dynamic subtotalTax;
  dynamic total;
  dynamic tax;

  Totals({this.subtotal, this.subtotalTax, this.total, this.tax});

  Totals.fromJson(Map<String, dynamic> json) {
    subtotal = json["subtotal"];
    subtotalTax = json["subtotal_tax"];
    total = json["total"];
    tax = json["tax"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["subtotal"] = subtotal;
    data["subtotal_tax"] = subtotalTax;
    data["total"] = total;
    data["tax"] = tax;
    return data;
  }
}

class Quantity {
  int? value;
  int? minPurchase;
  int? maxPurchase;

  Quantity({this.value, this.minPurchase, this.maxPurchase});

  Quantity.fromJson(Map<String, dynamic> json) {
    value = json["value"];
    minPurchase = json["min_purchase"];
    maxPurchase = json["max_purchase"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["value"] = value;
    data["min_purchase"] = minPurchase;
    data["max_purchase"] = maxPurchase;
    return data;
  }
}

class Customer {
  BillingAddress? billingAddress;
  ShippingAddress? shippingAddress;

  Customer({this.billingAddress, this.shippingAddress});

  Customer.fromJson(Map<String, dynamic> json) {
    billingAddress = json["billing_address"] == null ? null : BillingAddress.fromJson(json["billing_address"]);
    shippingAddress = json["shipping_address"] == null ? null : ShippingAddress.fromJson(json["shipping_address"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if(billingAddress != null) {
      data["billing_address"] = billingAddress?.toJson();
    }
    if(shippingAddress != null) {
      data["shipping_address"] = shippingAddress?.toJson();
    }
    return data;
  }
}

class ShippingAddress {
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

  ShippingAddress({this.shippingFirstName, this.shippingLastName, this.shippingCountry, this.shippingAddress1, this.shippingCity, this.shippingCompany, this.shippingAddress2, this.shippingState, this.shippingPostcode, this.shippingPhone, this.shippingEmail});

  ShippingAddress.fromJson(Map<String, dynamic> json) {
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

class BillingAddress {
  String? billingFirstName;
  String? billingLastName;
  String? billingCountry;
  String? billingAddress1;
  String? billingCity;
  String? billingAddress2;
  String? billingEmail;
  String? billingPhone;

  BillingAddress({this.billingFirstName, this.billingLastName, this.billingCountry, this.billingAddress1, this.billingCity, this.billingAddress2, this.billingEmail, this.billingPhone});

  BillingAddress.fromJson(Map<String, dynamic> json) {
    billingFirstName = json["billing_first_name"];
    billingLastName = json["billing_last_name"];
    billingCountry = json["billing_country"];
    billingAddress1 = json["billing_address_1"];
    billingCity = json["billing_city"];
    billingAddress2 = json["billing_address_2"];
    billingEmail = json["billing_email"];
    billingPhone = json["billing_phone"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["billing_first_name"] = billingFirstName;
    data["billing_last_name"] = billingLastName;
    data["billing_country"] = billingCountry;
    data["billing_address_1"] = billingAddress1;
    data["billing_city"] = billingCity;
    data["billing_address_2"] = billingAddress2;
    data["billing_email"] = billingEmail;
    data["billing_phone"] = billingPhone;
    return data;
  }
}

class Currency {
  String? currencyCode;
  String? currencySymbol;
  int? currencyMinorUnit;
  String? currencyDecimalSeparator;
  String? currencyThousandSeparator;
  String? currencyPrefix;
  String? currencySuffix;

  Currency({this.currencyCode, this.currencySymbol, this.currencyMinorUnit, this.currencyDecimalSeparator, this.currencyThousandSeparator, this.currencyPrefix, this.currencySuffix});

  Currency.fromJson(Map<String, dynamic> json) {
    currencyCode = json["currency_code"];
    currencySymbol = json["currency_symbol"];
    currencyMinorUnit = json["currency_minor_unit"];
    currencyDecimalSeparator = json["currency_decimal_separator"];
    currencyThousandSeparator = json["currency_thousand_separator"];
    currencyPrefix = json["currency_prefix"];
    currencySuffix = json["currency_suffix"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["currency_code"] = currencyCode;
    data["currency_symbol"] = currencySymbol;
    data["currency_minor_unit"] = currencyMinorUnit;
    data["currency_decimal_separator"] = currencyDecimalSeparator;
    data["currency_thousand_separator"] = currencyThousandSeparator;
    data["currency_prefix"] = currencyPrefix;
    data["currency_suffix"] = currencySuffix;
    return data;
  }
}