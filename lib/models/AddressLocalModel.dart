class AddressMedelLocal{
  //attributes = fields in table
  late  var id;
  late String firstname;
  late String lastname;
  late String phone;
  late String email;
  late String state;
  late String region;
  late dynamic city;
  late var address;
  late var code;
  AddressMedelLocal(dynamic obj) {
    id=obj["id"];
    firstname = obj['firstname'];
    lastname = obj["lastname"];
    phone = obj["phone"];
    email = obj["email"];
    state = obj["state"];
    region = obj["region"];
    city = obj["city"];
    address=obj["address"];
    code=obj["code"];
  }
  AddressMedelLocal.fromMap(Map < String, dynamic > data){
    id=data["id"];
    firstname=data['firstname'];
    lastname = data['lastname'];
    phone = data['phone'];
    email = data["email"];
    state = data['state'];
    region = data['region'];
    city = data['city'];
    address=data["address"];
    code=data["code"];
  }
  Map<String, dynamic> toMap() =>
      {
        "id":id,
        'firstname': firstname,
        'lastname': lastname,
        'phone': phone,
        "email": email,
        'state': state,
        'region': region,
        'city': city,
        "address":address,
        "code":code,
      };
}