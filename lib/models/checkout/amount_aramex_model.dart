class AmountAramexModel {
  Amount? amount;

  AmountAramexModel({this.amount});

  AmountAramexModel.fromJson(Map<String, dynamic> json) {
    amount =
        json['amount'] != null ? new Amount.fromJson(json['amount']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.amount != null) {
      data['amount'] = this.amount!.toJson();
    }
    return data;
  }
}

class Amount {
  String? currencyCode;
  double? value;

  Amount({this.currencyCode, this.value});

  Amount.fromJson(Map<String, dynamic> json) {
    currencyCode = json['CurrencyCode'];
    value = json['Value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CurrencyCode'] = this.currencyCode;
    data['Value'] = this.value;
    return data;
  }
}
