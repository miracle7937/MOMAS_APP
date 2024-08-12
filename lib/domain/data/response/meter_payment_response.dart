class MeterPaymentResponse {
  bool? status;
  List<MeterData>? data;
  String? message;

  MeterPaymentResponse({this.status, this.data});

  MeterPaymentResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <MeterData>[];
      json['data'].forEach((v) {
        data!.add( MeterData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MeterData {
  int? id;
  String? userId;
  String? orderId;
  String? token;
  int? amount;
  int? unit;
  int? status;
  String? createdAt;
  String? updatedAt;

  MeterData(
      {this.id,
        this.userId,
        this.orderId,
        this.token,
        this.amount,
        this.unit,
        this.status,
        this.createdAt,
        this.updatedAt});

  MeterData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    orderId = json['order_id'];
    token = json['token'];
    amount = json['amount'];
    unit = json['unit'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['order_id'] = orderId;
    data['token'] = token;
    data['amount'] = amount;
    data['unit'] = unit;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
