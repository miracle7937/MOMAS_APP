class MomasPaymentResponse {
  bool? status;
  MomasPaymentData? data;
  String? message;

  MomasPaymentResponse({this.status, this.data, this.message});

  MomasPaymentResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ?  MomasPaymentData.fromJson(json['data']) : null;
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

  MomasPaymentData(
      {this.fullName,
        this.address,
        this.service,
        this.orderId,
        this.token,
        this.amount,
      this.date});

  MomasPaymentData.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    address = json['address'];
    service = json['service'];
    orderId = json['order_id'];
    token = json['token'];
    amount = json['amount'];
    date = json['date'];
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
    return data;
  }
}
