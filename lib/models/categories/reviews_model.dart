class ReviewsModel {
  int? id;
  String? dateCreated;
  String? dateCreatedGmt;
  String? review;
  int? rating;
  String? name;
  String? email;
  bool? verified;
  Links? links;

  ReviewsModel({this.id, this.dateCreated, this.dateCreatedGmt, this.review, this.rating, this.name, this.email, this.verified, this.links});

  ReviewsModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    dateCreated = json["date_created"];
    dateCreatedGmt = json["date_created_gmt"];
    review = json["review"];
    rating = json["rating"];
    name = json["name"];
    email = json["email"];
    verified = json["verified"];
    links = json["_links"] == null ? null : Links.fromJson(json["_links"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["date_created"] = dateCreated;
    data["date_created_gmt"] = dateCreatedGmt;
    data["review"] = review;
    data["rating"] = rating;
    data["name"] = name;
    data["email"] = email;
    data["verified"] = verified;
    if(links != null) {
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
    self = json["self"]==null ? null : (json["self"] as List).map((e)=>Self.fromJson(e)).toList();
    collection = json["collection"]==null ? null : (json["collection"] as List).map((e)=>Collection.fromJson(e)).toList();
    up = json["up"]==null ? null : (json["up"] as List).map((e)=>Up.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if(self != null) {
      data["self"] = self?.map((e)=>e.toJson()).toList();
    }
    if(collection != null) {
      data["collection"] = collection?.map((e)=>e.toJson()).toList();
    }
    if(up != null) {
      data["up"] = up?.map((e)=>e.toJson()).toList();
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