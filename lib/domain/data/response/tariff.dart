class Tariff {
  int? id;
  String? type;
  String? estateId;
  String? title;
  num? amount;
  num? vat;

  Tariff(
      {this.id, this.type, this.estateId, this.title, this.amount, this.vat});

  Tariff.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    estateId = json['estate_id'];
    title = json['title'];
    amount = json['amount'];
    vat = json['vat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['estate_id'] = estateId;
    data['title'] = title;
    data['amount'] = amount;
    data['vat'] = vat;
    return data;
  }
}
