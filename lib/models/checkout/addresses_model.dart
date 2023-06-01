class AddressesModel {
  String? fullName;
  String? surName;
  String? phoneNumber;
  String? email;
  String? address;
  String? state;
  String? address2;
  String? city;
  String? postCode;
  String? country;
  bool? defaultAddress;

  AddressesModel(
      {this.fullName,
      this.surName,
      this.phoneNumber,
      this.email,
      this.address,
      this.state,
      this.address2,
      this.city,
      this.postCode,
      this.country,this.defaultAddress});

  AddressesModel.fromJson(Map<String,dynamic> json){
    fullName = json['fullName'];
    surName = json['surName'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    address = json['address'];
    state = json['state'];
    address2 = json['address2'];
    city = json['city'];
    postCode = json['postCode'];
    country = json['country'];
    defaultAddress = json['defaultAddress'];
  }

  // Map<String, dynamic> toJson(){
  //   Map<String,dynamic> data = <String, dynamic>{};
  //   data['fullName'] = fullName;
  //   data['surName'] = surName;
  //   data['surName'] = surName;
  //   data['phoneNumber'] = phoneNumber;
  //   data['email'] = email;
  //   data['address'] = address;
  //   data['state'] = state;
  //   data['street'] = street;
  //   data['apartment'] = apartment;
  //   data['floor'] = floor;
  //   data['building'] = building;
  //   data['defaultAddress'] = defaultAddress;
  //   return data;
  // }
}

