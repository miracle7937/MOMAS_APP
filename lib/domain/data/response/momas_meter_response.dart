import 'package:momas_pay/domain/data/response/tariff.dart';
import 'package:momas_pay/domain/data/response/user_model.dart';

class MomasVerificationResponse {
  bool? status;
  Data? data;
  String? message;
  MomasVerificationResponse({this.status, this.data, this.message});

  MomasVerificationResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
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
  List<Tariff>? tariffs;
  Data(
      {this.customerName,
      this.address,
      this.meterType,
      this.purchase,
      this.tariffs});

  Data.fromJson(Map<String, dynamic> json) {
    customerName = json['customer_name'];
    address = json['address'];
    meterType = json['meter_type'];
    purchase =
        json['purchase'] != null ? Purchase.fromJson(json['purchase']) : null;
    tariffs = json['tariffs'] != null
        ? (json['tariffs'] as List)
            .map((toElement) => Tariff.fromJson(toElement))
            .toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customer_name'] = customerName;
    data['address'] = address;
    data['meter_type'] = meterType;
    data['purchase'] = purchase?.toJson();
    return data;
  }
}

class TariffModel {
  int? id;
  String? type;
  String? estateId;
  String? title;
  int? amount;

  TariffModel({this.id, this.type, this.estateId, this.title, this.amount});

  TariffModel.fromJson(Map<String, dynamic> json) {
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
