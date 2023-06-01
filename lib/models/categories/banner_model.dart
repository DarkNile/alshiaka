class BannerModel {
  List<dynamic>? slide;
  String? image;

  BannerModel({this.slide, this.image});

  BannerModel.fromJson(Map<String, dynamic> json) {
    slide = json["slide"] ?? [];
    image = json["image"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if(slide != null) {
      data["slide"] = slide;
    }
    data["image"] = image;
    return data;
  }
}