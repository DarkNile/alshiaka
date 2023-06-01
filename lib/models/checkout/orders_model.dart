class OrdersModel {
  int? id;
  int? parentId;
  String? status;
  String? currency;
  String? version;
  bool? pricesIncludeTax;
  String? dateCreated;
  String? dateModified;
  String? discountTotal;
  String? discountTax;
  String? shippingTotal;
  String? shippingTax;
  String? cartTax;
  String? total;
  String? totalTax;
  int? customerId;
  String? orderKey;
  Billing? billing;
  Shipping? shipping;
  String? paymentMethod;
  String? paymentMethodTitle;
  String? transactionId;
  String? customerIpAddress;
  String? customerUserAgent;
  String? createdVia;
  String? customerNote;
  String? cartHash;
  String? number;
  List<MetaData>? metaData;
  List<LineItems>? lineItems;
  List<dynamic>? taxLines;
  List<ShippingLines>? shippingLines;
  List<dynamic>? feeLines;
  List<dynamic>? couponLines;
  List<dynamic>? refunds;
  String? paymentUrl;
  bool? isEditable;
  bool? needsPayment;
  bool? needsProcessing;
  String? dateCreatedGmt;
  String? dateModifiedGmt;
  String? currencySymbol;
  Links? links;

  OrdersModel({this.id, this.parentId, this.status, this.currency, this.version, this.pricesIncludeTax, this.dateCreated, this.dateModified, this.discountTotal, this.discountTax, this.shippingTotal, this.shippingTax, this.cartTax, this.total, this.totalTax, this.customerId, this.orderKey, this.billing, this.shipping, this.paymentMethod, this.paymentMethodTitle, this.transactionId, this.customerIpAddress, this.customerUserAgent, this.createdVia, this.customerNote, this.cartHash, this.number, this.metaData, this.lineItems, this.taxLines, this.shippingLines, this.feeLines, this.couponLines, this.refunds, this.paymentUrl, this.isEditable, this.needsPayment, this.needsProcessing, this.dateCreatedGmt, this.dateModifiedGmt, this.currencySymbol, this.links});

  OrdersModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    parentId = json["parent_id"];
    status = json["status"];
    currency = json["currency"];
    version = json["version"];
    pricesIncludeTax = json["prices_include_tax"];
    dateCreated = json["date_created"];
    dateModified = json["date_modified"];
    discountTotal = json["discount_total"];
    discountTax = json["discount_tax"];
    shippingTotal = json["shipping_total"];
    shippingTax = json["shipping_tax"];
    cartTax = json["cart_tax"];
    total = json["total"];
    totalTax = json["total_tax"];
    customerId = json["customer_id"];
    orderKey = json["order_key"];
    billing = json["billing"] == null ? null : Billing.fromJson(json["billing"]);
    shipping = json["shipping"] == null ? null : Shipping.fromJson(json["shipping"]);
    paymentMethod = json["payment_method"];
    paymentMethodTitle = json["payment_method_title"];
    transactionId = json["transaction_id"];
    customerIpAddress = json["customer_ip_address"];
    customerUserAgent = json["customer_user_agent"];
    createdVia = json["created_via"];
    customerNote = json["customer_note"];
    cartHash = json["cart_hash"];
    number = json["number"];
    metaData = json["meta_data"]==null ? null : (json["meta_data"] as List).map((e)=>MetaData.fromJson(e)).toList();
    lineItems = json["line_items"]==null ? null : (json["line_items"] as List).map((e)=>LineItems.fromJson(e)).toList();
    taxLines = json["tax_lines"] ?? [];
    shippingLines = json["shipping_lines"]==null ? null : (json["shipping_lines"] as List).map((e)=>ShippingLines.fromJson(e)).toList();
    feeLines = json["fee_lines"] ?? [];
    couponLines = json["coupon_lines"] ?? [];
    refunds = json["refunds"] ?? [];
    paymentUrl = json["payment_url"];
    isEditable = json["is_editable"];
    needsPayment = json["needs_payment"];
    needsProcessing = json["needs_processing"];
    dateCreatedGmt = json["date_created_gmt"];
    dateModifiedGmt = json["date_modified_gmt"];
    currencySymbol = json["currency_symbol"];
    links = json["_links"] == null ? null : Links.fromJson(json["_links"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["parent_id"] = parentId;
    data["status"] = status;
    data["currency"] = currency;
    data["version"] = version;
    data["prices_include_tax"] = pricesIncludeTax;
    data["date_created"] = dateCreated;
    data["date_modified"] = dateModified;
    data["discount_total"] = discountTotal;
    data["discount_tax"] = discountTax;
    data["shipping_total"] = shippingTotal;
    data["shipping_tax"] = shippingTax;
    data["cart_tax"] = cartTax;
    data["total"] = total;
    data["total_tax"] = totalTax;
    data["customer_id"] = customerId;
    data["order_key"] = orderKey;
    if(billing != null) {
      data["billing"] = billing?.toJson();
    }
    if(shipping != null) {
      data["shipping"] = shipping?.toJson();
    }
    data["payment_method"] = paymentMethod;
    data["payment_method_title"] = paymentMethodTitle;
    data["transaction_id"] = transactionId;
    data["customer_ip_address"] = customerIpAddress;
    data["customer_user_agent"] = customerUserAgent;
    data["created_via"] = createdVia;
    data["customer_note"] = customerNote;
    data["cart_hash"] = cartHash;
    data["number"] = number;
    if(metaData != null) {
      data["meta_data"] = metaData?.map((e)=>e.toJson()).toList();
    }
    if(lineItems != null) {
      data["line_items"] = lineItems?.map((e)=>e.toJson()).toList();
    }
    if(taxLines != null) {
      data["tax_lines"] = taxLines;
    }
    if(shippingLines != null) {
      data["shipping_lines"] = shippingLines?.map((e)=>e.toJson()).toList();
    }
    if(feeLines != null) {
      data["fee_lines"] = feeLines;
    }
    if(couponLines != null) {
      data["coupon_lines"] = couponLines;
    }
    if(refunds != null) {
      data["refunds"] = refunds;
    }
    data["payment_url"] = paymentUrl;
    data["is_editable"] = isEditable;
    data["needs_payment"] = needsPayment;
    data["needs_processing"] = needsProcessing;
    data["date_created_gmt"] = dateCreatedGmt;
    data["date_modified_gmt"] = dateModifiedGmt;
    data["currency_symbol"] = currencySymbol;
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

class ShippingLines {
  int? id;
  String? methodTitle;
  String? methodId;
  String? instanceId;
  String? total;
  String? totalTax;
  List<dynamic>? taxes;
  List<MetaData2>? metaData;

  ShippingLines({this.id, this.methodTitle, this.methodId, this.instanceId, this.total, this.totalTax, this.taxes, this.metaData});

  ShippingLines.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    methodTitle = json["method_title"];
    methodId = json["method_id"];
    instanceId = json["instance_id"];
    total = json["total"];
    totalTax = json["total_tax"];
    taxes = json["taxes"] ?? [];
    metaData = json["meta_data"]==null ? null : (json["meta_data"] as List).map((e)=>MetaData2.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["method_title"] = methodTitle;
    data["method_id"] = methodId;
    data["instance_id"] = instanceId;
    data["total"] = total;
    data["total_tax"] = totalTax;
    if(taxes != null) {
      data["taxes"] = taxes;
    }
    if(metaData != null) {
      data["meta_data"] = metaData?.map((e)=>e.toJson()).toList();
    }
    return data;
  }
}

class MetaData2 {
  int? id;
  String? key;
  String? value;
  String? displayKey;
  String? displayValue;

  MetaData2({this.id, this.key, this.value, this.displayKey, this.displayValue});

  MetaData2.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    key = json["key"];
    value = json["value"];
    displayKey = json["display_key"];
    displayValue = json["display_value"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["key"] = key;
    data["value"] = value;
    data["display_key"] = displayKey;
    data["display_value"] = displayValue;
    return data;
  }
}

class LineItems {
  int? id;
  String? name;
  int? productId;
  int? variationId;
  int? quantity;
  String? taxClass;
  String? subtotal;
  String? subtotalTax;
  String? total;
  String? totalTax;
  List<dynamic>? taxes;
  List<MetaData1>? metaData;
  String? sku;
  dynamic? price;
  Image? image;
  String? parentName;

  LineItems({this.id, this.name, this.productId, this.variationId, this.quantity, this.taxClass, this.subtotal, this.subtotalTax, this.total, this.totalTax, this.taxes, this.metaData, this.sku, this.price, this.image, this.parentName});

  LineItems.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    productId = json["product_id"];
    variationId = json["variation_id"];
    quantity = json["quantity"];
    taxClass = json["tax_class"];
    subtotal = json["subtotal"];
    subtotalTax = json["subtotal_tax"];
    total = json["total"];
    totalTax = json["total_tax"];
    taxes = json["taxes"] ?? [];
    metaData = json["meta_data"]==null ? null : (json["meta_data"] as List).map((e)=>MetaData1.fromJson(e)).toList();
    sku = json["sku"];
    price = json["price"];
    image = json["image"] == null ? null : Image.fromJson(json["image"]);
    parentName = json["parent_name"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["name"] = name;
    data["product_id"] = productId;
    data["variation_id"] = variationId;
    data["quantity"] = quantity;
    data["tax_class"] = taxClass;
    data["subtotal"] = subtotal;
    data["subtotal_tax"] = subtotalTax;
    data["total"] = total;
    data["total_tax"] = totalTax;
    if(taxes != null) {
      data["taxes"] = taxes;
    }
    if(metaData != null) {
      data["meta_data"] = metaData?.map((e)=>e.toJson()).toList();
    }
    data["sku"] = sku;
    data["price"] = price;
    if(image != null) {
      data["image"] = image?.toJson();
    }
    data["parent_name"] = parentName;
    return data;
  }
}

class Image {
  dynamic id;
  String? src;

  Image({this.id, this.src});

  Image.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    src = json["src"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["src"] = src;
    return data;
  }
}

class MetaData1 {
  int? id;
  String? key;
  dynamic value;
  String? displayKey;
  dynamic displayValue;

  MetaData1({this.id, this.key, this.value, this.displayKey, this.displayValue});

  MetaData1.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    key = json["key"];
    value = json["value"];
    displayKey = json["display_key"];
    displayValue = json["display_value"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["key"] = key;
    data["value"] = value;
    data["display_key"] = displayKey;
    data["display_value"] = displayValue;
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
  String? phone;

  Shipping({this.firstName, this.lastName, this.company, this.address1, this.address2, this.city, this.state, this.postcode, this.country, this.phone});

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
    data["phone"] = phone;
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