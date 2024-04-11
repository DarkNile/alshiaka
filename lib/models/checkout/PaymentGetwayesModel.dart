class PaymentGetwayesModel {
  String? id;
  String? title;
  String? description;
  dynamic order;
  bool? enabled;
  String? methodTitle;
  String? methodDescription;
  List<String>? methodSupports;
  // Settings? settings;
  bool? needsSetup;
  List<dynamic>? postInstallScripts;
  String? settingsUrl;
  List<dynamic>? requiredSettingsKeys;
  Links? links;

  PaymentGetwayesModel(
      {this.id,
      this.title,
      this.description,
      this.order,
      this.enabled,
      this.methodTitle,
      this.methodDescription,
      this.methodSupports,
      // this.settings,
      this.needsSetup,
      this.postInstallScripts,
      this.settingsUrl,
      this.requiredSettingsKeys,
      this.links});

  PaymentGetwayesModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    title = json["title"];
    description = json["description"];
    order = json["order"];
    enabled = json["enabled"];
    methodTitle = json["method_title"];
    methodDescription = json["method_description"];
    methodSupports = json["method_supports"] == null
        ? null
        : List<String>.from(json["method_supports"]);
    // settings = json["settings"] == null ? null : Settings.fromJson(json["settings"]);
    needsSetup = json["needs_setup"];
    postInstallScripts = json["post_install_scripts"] ?? [];
    settingsUrl = json["settings_url"];
    requiredSettingsKeys = json["required_settings_keys"] ?? [];
    links = json["_links"] == null ? null : Links.fromJson(json["_links"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["title"] = title;
    data["description"] = description;
    data["order"] = order;
    data["enabled"] = enabled;
    data["method_title"] = methodTitle;
    data["method_description"] = methodDescription;
    if (methodSupports != null) {
      data["method_supports"] = methodSupports;
    }
    // if(settings != null) {
    //   data["settings"] = settings?.toJson();
    // }
    data["needs_setup"] = needsSetup;
    if (postInstallScripts != null) {
      data["post_install_scripts"] = postInstallScripts;
    }
    data["settings_url"] = settingsUrl;
    if (requiredSettingsKeys != null) {
      data["required_settings_keys"] = requiredSettingsKeys;
    }
    if (links != null) {
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
    self = json["self"] == null
        ? null
        : (json["self"] as List).map((e) => Self.fromJson(e)).toList();
    collection = json["collection"] == null
        ? null
        : (json["collection"] as List)
            .map((e) => Collection.fromJson(e))
            .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (self != null) {
      data["self"] = self?.map((e) => e.toJson()).toList();
    }
    if (collection != null) {
      data["collection"] = collection?.map((e) => e.toJson()).toList();
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

class Settings {
  Title? title;
  DescriptionType? descriptionType;

  Settings({this.title, this.descriptionType});

  Settings.fromJson(Map<String, dynamic> json) {
    title = json["title"] == null ? null : Title.fromJson(json["title"]);
    descriptionType = json["description_type"] == null
        ? null
        : DescriptionType.fromJson(json["description_type"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (title != null) {
      data["title"] = title?.toJson();
    }
    if (descriptionType != null) {
      data["description_type"] = descriptionType?.toJson();
    }
    return data;
  }
}

class DescriptionType {
  String? id;
  String? label;
  String? description;
  String? type;
  String? value;
  int? defaultt;
  String? tip;
  String? placeholder;
  dynamic options;

  DescriptionType(
      {this.id,
      this.label,
      this.description,
      this.type,
      this.value,
      this.defaultt,
      this.tip,
      this.placeholder,
      this.options});

  DescriptionType.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    label = json["label"];
    description = json["description"];
    type = json["type"];
    value = json["value"];
    defaultt = json["default"];
    tip = json["tip"];
    placeholder = json["placeholder"];
    options = json["options"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["label"] = label;
    data["description"] = description;
    data["type"] = type;
    data["value"] = value;
    data["default"] = defaultt;
    data["tip"] = tip;
    data["placeholder"] = placeholder;
    if (options != null) {
      data["options"] = options?.toJson();
    }
    return data;
  }
}

class Title {
  String? id;
  String? label;
  String? description;
  String? type;
  String? value;
  String? defaultt;
  String? tip;
  String? placeholder;

  Title(
      {this.id,
      this.label,
      this.description,
      this.type,
      this.value,
      this.defaultt,
      this.tip,
      this.placeholder});

  Title.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    label = json["label"];
    description = json["description"];
    type = json["type"];
    value = json["value"];
    defaultt = json["default"];
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
    data["default"] = defaultt;
    data["tip"] = tip;
    data["placeholder"] = placeholder;
    return data;
  }
}
