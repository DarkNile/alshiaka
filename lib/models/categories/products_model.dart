import 'package:easy_localization/easy_localization.dart';

class ProductModel {
  List<dynamic>? variations;
  int? id;
  String? mainProductId;
  int? qty;
  String? name;
  List<Images>? images;
  dynamic image;
  dynamic categories;
  dynamic categoriesIds;
  dynamic dateCreated;
  String? type;
  dynamic dateCreatedGmt;
  dynamic dateModified;
  dynamic dateModifiedGmt;
  String? description;
  String? permalink;
  String? sku;
  String? price;
  bool? fav;
  String? regularPrice;
  String? salePrice;
  bool? onSale;
  String? status;
  bool? purchasable;
  bool? virtual;
  bool? downloadable;
  List<dynamic>? downloads;
  int? downloadLimit;
  int? downloadExpiry;
  String? taxStatus;
  String? taxClass;
  bool? manageStock;
  int? stockQuantity;
  String? stockStatus;
  String? backorders;
  bool? backordersAllowed;
  bool? backordered;
  dynamic weight;
  Dimensions? dimensions;
  String? shippingClass;
  int? shippingClassId;
  // List<Attributes>? attributes;
  dynamic attributes;
  int? menuOrder;
  List<MetaData>? metaData;
  Translations? translations;
  String? lang;
  Links? links;

  ProductModel(
      {this.variations,
      this.id,
      this.mainProductId,
      this.dateCreated,
      this.image,
      this.categoriesIds,
      this.categories,
      this.qty,
      this.name,
      this.images,
      this.dateCreatedGmt,
      this.type,
      this.dateModified,
      this.dateModifiedGmt,
      this.description,
      this.permalink,
      this.sku,
      this.price,
      this.fav,
      this.regularPrice,
      this.salePrice,
      this.onSale,
      this.status,
      this.purchasable,
      this.virtual,
      this.downloadable,
      this.downloads,
      this.downloadLimit,
      this.downloadExpiry,
      this.taxStatus,
      this.taxClass,
      this.manageStock,
      this.stockQuantity,
      this.stockStatus,
      this.backorders,
      this.backordersAllowed,
      this.backordered,
      this.weight,
      this.dimensions,
      this.shippingClass,
      this.shippingClassId,
      this.attributes,
      this.menuOrder,
      this.metaData,
      this.translations,
      this.lang,
      this.links});

  ProductModel.fromJson(Map<String, dynamic> json) {
    variations = json["variations"] ?? [];
    id = json["id"];
    mainProductId = json["mainProductId"];
    qty = json['qty'] ?? 1;
    name = json["name"];
    image = json["image"];
    categories = json["categories"];
    categoriesIds = json["category_ids"];
    images = json["images"] == null
        ? null
        : (json["images"] as List).map((e) => Images.fromJson(e)).toList();
    dateCreated = json["date_created"];
    type = json["type"];
    dateCreatedGmt = json["date_created_gmt"];
    dateModified = json["date_modified"];
    dateModifiedGmt = json["date_modified_gmt"];
    description = json["description"];
    permalink = json["permalink"];
    sku = json["sku"];
    price = json["price"];
    fav = false;
    regularPrice = json["regular_price"];
    salePrice = json["sale_price"];
    onSale = json["on_sale"];
    status = json["status"];
    purchasable = json["purchasable"];
    virtual = json["virtual"];
    downloadable = json["downloadable"];
    downloads = json["downloads"] ?? [];
    downloadLimit = json["download_limit"];
    downloadExpiry = json["download_expiry"];
    taxStatus = json["tax_status"];
    taxClass = json["tax_class"];
    manageStock = json["manage_stock"];
    stockQuantity = json["stock_quantity"];
    stockStatus = json["stock_status"];
    backorders = json["backorders"];
    backordersAllowed = json["backorders_allowed"];
    backordered = json["backordered"];
    weight = json["weight"];
    dimensions = json["dimensions"] == null
        ? null
        : Dimensions.fromJson(json["dimensions"]);
    shippingClass = json["shipping_class"];
    shippingClassId = json["shipping_class_id"];
    // attributes = json["attributes"] == null
    //     ? null
    //     : (json["attributes"] as List)
    //         .map((e) => Attributes.fromJson(e))
    //         .toList();
    attributes = json["attributes"] == null ? null : json["attributes"];
    menuOrder = json["menu_order"];
    metaData = json["meta_data"] == null
        ? null
        : (json["meta_data"] as List).map((e) => MetaData.fromJson(e)).toList();
    translations = json["translations"] == null
        ? null
        : Translations.fromJson(json["translations"]);
    lang = json["lang"];
    links = json["_links"] == null ? null : Links.fromJson(json["_links"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["variations"] = variations;
    data["id"] = id;
    data["mainProductId"] = mainProductId;
    data["qty"] = qty;
    data["name"] = name;
    data["image"] = image;
    data["categories"] = categories;
    data["images"] = images;
    data["date_created"] = dateCreated;
    data["type"] = type;
    data["date_created_gmt"] = dateCreatedGmt;
    data["date_modified"] = dateModified;
    data["date_modified_gmt"] = dateModifiedGmt;
    data["description"] = description;
    data["permalink"] = permalink;
    data["sku"] = sku;
    data["price"] = price;
    data["fav"] = fav;
    data["regular_price"] = regularPrice;
    data["sale_price"] = salePrice;
    data["on_sale"] = onSale;
    data["status"] = status;
    data["purchasable"] = purchasable;
    data["virtual"] = virtual;
    data["downloadable"] = downloadable;
    if (downloads != null) {
      data["downloads"] = downloads;
    }
    data["download_limit"] = downloadLimit;
    data["download_expiry"] = downloadExpiry;
    data["tax_status"] = taxStatus;
    data["tax_class"] = taxClass;
    data["manage_stock"] = manageStock;
    data["stock_quantity"] = stockQuantity;
    data["stock_status"] = stockStatus;
    data["backorders"] = backorders;
    data["backorders_allowed"] = backordersAllowed;
    data["backordered"] = backordered;
    data["weight"] = weight;
    if (dimensions != null) {
      data["dimensions"] = dimensions?.toJson();
    }
    data["shipping_class"] = shippingClass;
    data["shipping_class_id"] = shippingClassId;
    if (attributes != null) {
      // data["attributes"] = attributes?.map((e) => e.toJson()).toList();
      data["attributes"] = attributes;
    }
    if (images != null) {
      data["images"] = images?.map((e) => e.toJson()).toList();
    }

    data["menu_order"] = menuOrder;
    if (metaData != null) {
      data["meta_data"] = metaData?.map((e) => e.toJson()).toList();
    }
    if (translations != null) {
      data["translations"] = translations?.toJson();
    }
    data["lang"] = lang;
    if (links != null) {
      data["_links"] = links?.toJson();
    }
    return data;
  }
}

class Links {
  List<Self>? self;
  List<Collection>? collection;
  List<Up>? up;

  Links({this.self, this.collection, this.up});

  Links.fromJson(Map<String, dynamic> json) {
    self = json["self"] == null
        ? null
        : (json["self"] as List).map((e) => Self.fromJson(e)).toList();
    collection = json["collection"] == null
        ? null
        : (json["collection"] as List)
            .map((e) => Collection.fromJson(e))
            .toList();
    up = json["up"] == null
        ? null
        : (json["up"] as List).map((e) => Up.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (self != null) {
      data["self"] = self?.map((e) => e.toJson()).toList();
    }
    if (collection != null) {
      data["collection"] = collection?.map((e) => e.toJson()).toList();
    }
    if (up != null) {
      data["up"] = up?.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class Up {
  String? href;

  Up({this.href});

  Up.fromJson(Map<String, dynamic> json) {
    href = json["href"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["href"] = href;
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

class Translations {
  String? ar;
  String? en;

  Translations({this.ar, this.en});

  Translations.fromJson(Map<String, dynamic> json) {
    ar = json["ar"];
    en = json["en"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["ar"] = ar;
    data["en"] = en;
    return data;
  }
}

class MetaData {
  int? id;
  String? key;
  dynamic? value;

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

class Attributes {
  int? id;
  String? name;
  String? slug;
  String? option;
  bool? visible;
  List<String>? options;
  dynamic selectedOptions;
  bool? variation;

  Attributes(
      {this.id, this.name, this.slug, this.visible, this.option, this.options});

  Attributes.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"].toString().tr();
    slug = json["slug"];
    visible = json["visible"];
    option = json["option"];
    variation = json["variation"];
    if (json['options'] != null) {
      options = List<String>.from(json["options"]);
    }
    selectedOptions = json['selectedOptions'] == null
        ? null
        : selectedOptions is String
            ? json['selectedOptions']
            : List<String>.from(json["selectedOptions"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["name"] = name;
    data["slug"] = slug;
    data["variation"] = variation;
    data["option"] = option;
    data["options"] = options;
    return data;
  }
}

class Dimensions {
  String? length;
  String? width;
  String? height;

  Dimensions({this.length, this.width, this.height});

  Dimensions.fromJson(Map<String, dynamic> json) {
    length = json["length"];
    width = json["width"];
    height = json["height"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["length"] = length;
    data["width"] = width;
    data["height"] = height;
    return data;
  }
}

class Images {
  int? id;
  String? dateCreated;
  String? dateCreatedGmt;
  String? dateModified;
  String? dateModifiedGmt;
  String? src;
  String? name;
  String? alt;

  Images(
      {this.id,
      this.dateCreated,
      this.dateCreatedGmt,
      this.dateModified,
      this.dateModifiedGmt,
      this.src,
      this.name,
      this.alt});

  Images.fromJson(Map<String, dynamic> json) {
    this.id = json["id"];
    this.dateCreated = json["date_created"];
    this.dateCreatedGmt = json["date_created_gmt"];
    this.dateModified = json["date_modified"];
    this.dateModifiedGmt = json["date_modified_gmt"];
    this.src = json["src"];
    this.name = json["name"];
    this.alt = json["alt"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["date_created"] = this.dateCreated;
    data["date_created_gmt"] = this.dateCreatedGmt;
    data["date_modified"] = this.dateModified;
    data["date_modified_gmt"] = this.dateModifiedGmt;
    data["src"] = this.src;
    data["name"] = this.name;
    data["alt"] = this.alt;
    return data;
  }
}
