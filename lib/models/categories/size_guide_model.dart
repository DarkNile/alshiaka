class SizeGuideModel {
  List<String>? tabs;
  List<String>? names;
  dynamic tables;

  SizeGuideModel({this.tabs, this.names, this.tables});

  SizeGuideModel.fromJson(Map<String, dynamic> json) {
    tabs = json["tabs"]==null ? null : List<String>.from(json["tabs"]);
    names = json["names"]==null ? null : List<String>.from(json["names"]);
    tables = json["tables"]==null ? null : List.from(json["tables"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if(tabs != null) {
      data["tabs"] = tabs;
    }
    if(names != null) {
      data["names"] = names;
    }
    if(tables != null) {
      data["tables"] = tables;
    }
    return data;
  }
}