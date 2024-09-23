import 'package:momas_pay/domain/data/response/user_model.dart';

class MomasVerificationResponse {
  bool? status;
  Data? data;

  MomasVerificationResponse({this.status, this.data});

  MomasVerificationResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? customerName;
  String? address;
  String? meterType;
  Purchase? purchase;

  Data({this.customerName, this.address, this.meterType, this.purchase});

  Data.fromJson(Map<String, dynamic> json) {
    customerName = json['customer_name'];
    address = json['address'];
    meterType = json['meter_type'];
    purchase =
        json['purchase'] != null ? Purchase.fromJson(json['purchase']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customer_name'] = this.customerName;
    data['address'] = this.address;
    data['meter_type'] = this.meterType;
    data['purchase'] = this.purchase?.toJson();
    return data;
  }
}
