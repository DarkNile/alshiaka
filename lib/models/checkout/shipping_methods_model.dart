class ShippingMethodsModel {
  int? id;
  int? instanceId;
  String? title;
  int? order;
  bool? enabled;
  String? methodId;
  String? methodTitle;
  String? methodDescription;
  Settings? settings;
  Links? links;

  ShippingMethodsModel({this.id, this.instanceId, this.title, this.order, this.enabled, this.methodId, this.methodTitle, this.methodDescription, this.settings, this.links});

  ShippingMethodsModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    instanceId = json["instance_id"];
    title = json["title"];
    order = json["order"];
    enabled = json["enabled"];
    methodId = json["method_id"];
    methodTitle = json["method_title"];
    methodDescription = json["method_description"];
    settings = json["settings"] == null ? null : Settings.fromJson(json["settings"]);
    links = json["_links"] == null ? null : Links.fromJson(json["_links"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["instance_id"] = instanceId;
    data["title"] = title;
    data["order"] = order;
    data["enabled"] = enabled;
    data["method_id"] = methodId;
    data["method_title"] = methodTitle;
    data["method_description"] = methodDescription;
    if(settings != null) {
      data["settings"] = settings?.toJson();
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
  List<Describes>? describes;

  Links({this.self, this.collection, this.describes});

  Links.fromJson(Map<String, dynamic> json) {
    self = json["self"]==null ? null : (json["self"] as List).map((e)=>Self.fromJson(e)).toList();
    collection = json["collection"]==null ? null : (json["collection"] as List).map((e)=>Collection.fromJson(e)).toList();
    describes = json["describes"]==null ? null : (json["describes"] as List).map((e)=>Describes.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if(self != null) {
      data["self"] = self?.map((e)=>e.toJson()).toList();
    }
    if(collection != null) {
      data["collection"] = collection?.map((e)=>e.toJson()).toList();
    }
    if(describes != null) {
      data["describes"] = describes?.map((e)=>e.toJson()).toList();
    }
    return data;
  }
}

class Describes {
  String? href;

  Describes({this.href});

  Describes.fromJson(Map<String, dynamic> json) {
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

class Settings {
  Title? title;
  TaxStatus? taxStatus;
  Cost? cost;

  Settings({this.title, this.taxStatus, this.cost});

  Settings.fromJson(Map<String, dynamic> json) {
    title = json["title"] == null ? null : Title.fromJson(json["title"]);
    taxStatus = json["tax_status"] == null ? null : TaxStatus.fromJson(json["tax_status"]);
    cost = json["cost"] == null ? null : Cost.fromJson(json["cost"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if(title != null) {
      data["title"] = title?.toJson();
    }
    if(taxStatus != null) {
      data["tax_status"] = taxStatus?.toJson();
    }
    if(cost != null) {
      data["cost"] = cost?.toJson();
    }
    return data;
  }
}

class Cost {
  String? id;
  String? label;
  String? description;
  String? type;
  String? value;
  String? tip;
  String? placeholder;

  Cost({this.id, this.label, this.description, this.type, this.value, this.tip, this.placeholder});

  Cost.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    label = json["label"];
    description = json["description"];
    type = json["type"];
    value = json["value"];
    tip = json["tip"];
    placeholder = json["placeholder"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["label"] = label;
    data["description"] = description;
    data["type"] = type;
    data["value"] = value;
    data["tip"] = tip;
    data["placeholder"] = placeholder;
    return data;
  }
}

class TaxStatus {
  String? id;
  String? label;
  String? description;
  String? type;
  String? value;
  String? tip;
  String? placeholder;
  Options? options;

  TaxStatus({this.id, this.label, this.description, this.type, this.value, this.tip, this.placeholder, this.options});

  TaxStatus.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    label = json["label"];
    description = json["description"];
    type = json["type"];
    value = json["value"];
    tip = json["tip"];
    placeholder = json["placeholder"];
    options = json["options"] == null ? null : Options.fromJson(json["options"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["label"] = label;
    data["description"] = description;
    data["type"] = type;
    data["value"] = value;
    data["tip"] = tip;
    data["placeholder"] = placeholder;
    if(options != null) {
      data["options"] = options?.toJson();
    }
    return data;
  }
}

class Options {
  String? taxable;
  String? none;

  Options({this.taxable, this.none});

  Options.fromJson(Map<String, dynamic> json) {
    taxable = json["taxable"];
    none = json["none"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["taxable"] = taxable;
    data["none"] = none;
    return data;
  }
}

class Title {
  String? id;
  String? label;
  String? description;
  String? type;
  String? value;
  String? tip;
  String? placeholder;

  Title({this.id, this.label, this.description, this.type, this.value, this.tip, this.placeholder});

  Title.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    label = json["label"];
    description = json["description"];
    type = json["type"];
    value = json["value"];
    tip = json["tip"];
    placeholder = json["placeholder"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["label"] = label;
    data["description"] = description;
    data["type"] = type;
    data["value"] = value;
    data["tip"] = tip;
    data["placeholder"] = placeholder;
    return data;
  }
}