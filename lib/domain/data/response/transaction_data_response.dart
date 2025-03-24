import 'package:flutter/material.dart';

class TransactionDataResponse {
  bool? status;
  List<TransactionData>? data;

  TransactionDataResponse({this.status, this.data});

  TransactionDataResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <TransactionData>[];
      json['data'].forEach((v) {
        data!.add(TransactionData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TransactionData {
  int? id;
  int? userId;
  String? payType;
  String? serviceType;
  String? trxId;
  int? amount;
  PaymentStatus? status;
  String? note;
  String? token;
  String? createdAt;
  String? updatedAt;

  TransactionData(
      {this.id,
      this.userId,
      this.payType,
      this.serviceType,
      this.trxId,
      this.amount,
      this.status,
      this.note,
      this.token,
      this.createdAt,
      this.updatedAt});

  TransactionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    payType = json['pay_type'];
    serviceType = json['service_type'];
    trxId = json['trx_id'];
    amount = json['amount'];
    status = json['status'] != null
        ? PaymentStatus.fromValue(json['status'])
        : PaymentStatus.none;
    note = json['note'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['pay_type'] = payType;
    data['service_type'] = serviceType;
    data['trx_id'] = trxId;
    data['amount'] = amount;
    data['status'] = status;
    data['note'] = note;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['token'] = token;
    return data;
  }
}

enum PaymentStatus {
  pending(0),
  successful(2),
  declined(3),
  none(4);

  final int value;

  const PaymentStatus(this.value);

  static PaymentStatus fromValue(int value) {
    switch (value) {
      case 0:
        return PaymentStatus.pending;
      case 2:
        return PaymentStatus.successful;
      case 3:
        return PaymentStatus.declined;
      case 4:
        return PaymentStatus.none;

      default:
        throw ArgumentError('Invalid PaymentStatus value: $value');
    }
  }

  Color get color {
    switch (this) {
      case PaymentStatus.pending:
        return Colors.orange; // Pending - Orange
      case PaymentStatus.successful:
        return Colors.green; // Successful - Green
      case PaymentStatus.declined:
        return Colors.red; // Declined - Red
      default:
        return Colors.grey; // Default or unknown status
    }
  }

  @override
  String toString() {
    switch (this) {
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.successful:
        return 'Successful';
      case PaymentStatus.declined:
        return 'Declined';
      case PaymentStatus.none:
        return 'NONE';
    }
  }
}
