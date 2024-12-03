class MomasPaymentResponse {
  bool? status;
  MomasPaymentData? data;
  String? message;

  MomasPaymentResponse({this.status, this.data, this.message});

  MomasPaymentResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data =
        json['data'] != null ? MomasPaymentData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class MomasPaymentData {
  String? fullName;
  String? address;
  String? service;
  String? orderId;
  String? token;
  String? amount;
  String? date;
  String? kctToken1;
  String? kctToken2;
  String? vendingAmount;
  String? vendAmountKwPerNaira;
  String? vatAmount;

  MomasPaymentData(
      {this.fullName,
      this.address,
      this.service,
      this.orderId,
      this.token,
      this.amount,
      this.date,
      this.kctToken1,
      this.kctToken2,
      this.vendingAmount,
      this.vendAmountKwPerNaira,
      this.vatAmount});

  MomasPaymentData.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    address = json['address'];
    service = json['service'];
    orderId = json['order_id'];
    token = json['token'];
    amount = json['amount'];
    date = json['date'];
    kctToken1 = json['kct_token1'];
    kctToken2 = json['kct_token2'];
    vendingAmount = json['vending_amount'];
    vendAmountKwPerNaira = json['vend_amount_kw_per_naira'];
    vatAmount = json['vat_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['full_name'] = fullName;
    data['address'] = address;
    data['service'] = service;
    data['order_id'] = orderId;
    data['token'] = token;
    data['amount'] = amount;
    data['date'] = date;
    data['kct_token1'] = kctToken1;
    data['kct_token2'] = kctToken2;
    data['vend_amount_kw_per_naira'] = vendAmountKwPerNaira;
    data['vending_amount'] = vendingAmount;
    data['vat_amount'] = vatAmount;
    return data;
  }
}
