class Tariff {
  int? id;
  String? type;
  String? estateId;
  String? title;
  int? amount;

  Tariff({this.id, this.type, this.estateId, this.title, this.amount});

  Tariff.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    estateId = json['estate_id'];
    title = json['title'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['estate_id'] = estateId;
    data['title'] = title;
    data['amount'] = amount;
    return data;
  }
}
