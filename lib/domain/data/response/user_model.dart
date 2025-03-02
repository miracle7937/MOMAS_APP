import 'dart:ffi';

import 'package:momas_pay/domain/data/response/tariff.dart';

class UserModel {
  bool? status;
  User? user;
  String? message;
  UserModel({this.status, this.user});

  UserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? firstName;
  String? lastName;
  String? phone;
  String? email;
  String? image;
  String? deviceId;
  int? mainWallet;
  int? role;
  int? code;
  String? pin;
  String? gender;
  String? city;
  String? state;
  String? lga;
  String? meterNo;
  String? meterType;
  int? status;
  String? token;
  String? meter;
  String? estateId;
  String? estateName;
  String? hno;
  String? address;
  bool? monthlyAdminFee;
  FlutterWaveKeys? flutterWaveKeys;
  PayStackKeys? payStackKeys;
  UserRole? userRole;
  Purchase? purchase;
  List<Tariff>? tariffs;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.image,
    this.deviceId,
    this.mainWallet,
    this.role,
    this.code,
    this.pin,
    this.gender,
    this.city,
    this.state,
    this.lga,
    this.meterNo,
    this.meterType,
    this.status,
    this.token,
    this.meter,
    this.hno,
    this.address,
    this.monthlyAdminFee,
    this.estateId,
    this.flutterWaveKeys,
    this.payStackKeys,
    this.userRole,
    this.purchase,
    this.tariffs,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phone = json['phone'];
    email = json['email'];
    image = json['image'];
    deviceId = json['device_id'];
    mainWallet = json['main_wallet'];
    role = json['role'];
    code = json['code'];
    pin = json['pin'];
    gender = json['gender'];
    city = json['city'];
    state = json['state'];
    lga = json['lga'];
    meterNo = json['meterNo'];
    meterType = json['meterType'];
    status = json['status'];
    token = json['token'];
    estateId = json['estate_id'];
    hno = json['hno'];
    monthlyAdminFee =
        (json['monthly_admin_fee']).toString() == "1" ? true : false;
    address = json['address'];
    estateName = json['estate_name'];
    tariffs = json['tariff'] != null
        ? (json['tariff'] as List).map((v) => Tariff.fromJson(v)).toList()
        : [];
    purchase =
        json['purchase'] != null ? Purchase.fromJson(json['purchase']) : null;
    userRole =
        json["role"] != null ? UserRole.getById(json["role"]) : UserRole.none;
    flutterWaveKeys = json['flutterwave_keys'] != null
        ? new FlutterWaveKeys.fromJson(json['flutterwave_keys'])
        : null;
    payStackKeys = json['paystack_keys'] != null
        ? new PayStackKeys.fromJson(json['paystack_keys'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['monthly_admin_fee'] = monthlyAdminFee;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['phone'] = phone;
    data['email'] = email;
    data['image'] = image;
    data['device_id'] = deviceId;
    data['main_wallet'] = mainWallet;
    data['role'] = role;
    data['code'] = code;
    data['pin'] = pin;
    data['gender'] = gender;
    data['city'] = city;
    data['state'] = state;
    data['lga'] = lga;
    data['meterNo'] = meterNo;
    data['meterType'] = meterType;
    data['status'] = status;
    data['token'] = token;
    data['estate_id'] = estateId;
    data['estate_name'] = estateName;
    data['tariff'] = tariffs?.map((value) {
      return value.toJson();
    }).toList();
    if (purchase != null) {
      data['purchase'] = purchase!.toJson();
    }

    if (flutterWaveKeys != null) {
      data['flutterwave_keys'] = flutterWaveKeys!.toJson();
    }
    if (payStackKeys != null) {
      data['paystack_keys'] = payStackKeys!.toJson();
    }
    return data;
  }
}

class PayStackKeys {
  String? paystackSecret;
  String? paystackPublic;

  PayStackKeys({this.paystackSecret, this.paystackPublic});

  PayStackKeys.fromJson(Map<String, dynamic> json) {
    paystackSecret = json['paystack_secret'];
    paystackPublic = json['paystack_public'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['paystack_secret'] = paystackSecret;
    data['paystack_public'] = paystackPublic;
    return data;
  }
}

class FlutterWaveKeys {
  String? flutterWaveSecret;
  String? flutterWavePublic;

  FlutterWaveKeys({this.flutterWaveSecret, this.flutterWavePublic});

  FlutterWaveKeys.fromJson(Map<String, dynamic> json) {
    flutterWaveSecret = json['flutterwave_secret'];
    flutterWavePublic = json['flutterwave_public'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['flutterwave_secret'] = flutterWaveSecret;
    data['flutterwave_public'] = flutterWavePublic;
    return data;
  }
}

enum UserRole {
  none(0),
  admin(1),
  customer(2),
  estateManager(3),
  estateStaff(4);

  final int id;
  const UserRole(this.id);

  static UserRole getById(int id) {
    return UserRole.values.firstWhere(
      (role) => role.id == id,
      orElse: () => UserRole.none,
    );
  }
}

class Purchase {
  num? minPurchase;
  num? maxPurchase;
  num? minVending;

  Purchase({this.minPurchase, this.maxPurchase, this.minVending});

  Purchase.fromJson(Map<String, dynamic> json) {
    minPurchase = json['min_purchase'];
    maxPurchase = json['max_purchase'];
    minVending = json['min_vending'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['min_purchase'] = minPurchase;
    data['max_purchase'] = maxPurchase;
    data['min_vending'] = minVending;
    return data;
  }
}
