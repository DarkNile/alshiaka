// To parse this JSON data, do
//
//     final categoriesModel = categoriesModelFromJson(jsonString);

import 'dart:convert';

List<CategoriesModel> categoriesModelFromJson(String str) =>
    List<CategoriesModel>.from(
        json.decode(str).map((x) => CategoriesModel.fromJson(x)));

String categoriesModelToJson(List<CategoriesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoriesModel {
  CategoriesModel({
    this.id,
    this.name,
    this.slug,
    this.parent,
    this.description,
    this.image,
    this.links,
    this.display,
    this.count,
    this.menuOrder,
    this.lang,
    this.translations,
  });

  int? id;
  String? name;
  String? slug;
  int? parent;
  String? description;
  Map<String, dynamic>? image;
  Links? links;
  String? display;
  int? count;
  int? menuOrder;
  dynamic lang;
  Translations? translations;

  factory CategoriesModel.fromJson(Map<String, dynamic> json) =>
      CategoriesModel(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        parent: json["parent"],
        description: json["description"],
        image: json["image"] == null ? null : json["image"],
        links: Links.fromJson(json["_links"]),
        display: json["display"],
        count: json["count"],
        menuOrder: json["menu_order"],
        lang: json["lang"],
        translations: Translations.fromJson(json["translations"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "parent": parent,
        "description": description,
        "image": image == null ? null : image,
        "_links": links!.toJson(),
        "display": display,
        "count": count,
        "menu_order": menuOrder,
        "lang": lang,
        "translations": translations!.toJson(),
      };
}

class Links {
  Links({
    this.self,
  });

  List<Self>? self;

  factory Links.fromJson(Map<String, dynamic> json) => Links(
        self: List<Self>.from(json["self"].map((x) => Self.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "self": List<dynamic>.from(self!.map((x) => x.toJson())),
      };
}

class Self {
  Self({
    this.href,
  });

  String? href;

  factory Self.fromJson(Map<String, dynamic> json) => Self(
        href: json["href"],
      );

  Map<String, dynamic> toJson() => {
        "href": href,
      };
}

class Translations {
  Translations({
    this.ar,
    this.en,
  });

  int? ar;
  int? en;

  factory Translations.fromJson(Map<String, dynamic> json) => Translations(
        ar: json["ar"] == null ? null : json["ar"],
        en: json["en"],
      );

  Map<String, dynamic> toJson() => {
        "ar": ar == null ? null : ar,
        "en": en,
      };
}
