class DataResponse {

  bool? status;
  List<DataPlan>? mtnData;
  List<DataPlan>? gloData;
  List<DataPlan>? airtelData;
  List<DataPlan>? l9mobileData;
  List<DataPlan>? smileData;
  List<DataPlan>? spectranetData;

   Map<String, List<DataPlan>?> dataMap = {};

  DataResponse({this.status, this.mtnData, this.gloData, this.airtelData, this.l9mobileData, this.smileData, this.spectranetData});


  DataResponse.fromJson(Map<String, dynamic> json) {

    status = json['status'];
    if (json['mtn_data'] != null) {
      mtnData = <DataPlan>[];
      json['mtn_data'].forEach((v) { mtnData?.add(DataPlan.fromJson(v)); });
    }
    if (json['glo_data'] != null) {
      gloData = <DataPlan>[];
      json['glo_data'].forEach((v) { gloData!.add(DataPlan.fromJson(v)); });
    }
    if (json['airtel_data'] != null) {
      airtelData = <DataPlan>[];
      json['airtel_data'].forEach((v) { airtelData!.add(DataPlan.fromJson(v)); });
    }
    if (json['9mobile_data'] != null) {
      l9mobileData = <DataPlan>[];
    json['9mobile_data'].forEach((v) { l9mobileData!.add(DataPlan.fromJson(v)); });
    }
    if (json['smile_data'] != null) {
    smileData = <DataPlan>[];
    json['smile_data'].forEach((v) { smileData!.add(DataPlan.fromJson(v)); });
    }
    if (json['spectranet_data'] != null) {
    spectranetData = <DataPlan>[];
    json['spectranet_data'].forEach((v) { spectranetData!.add(DataPlan.fromJson(v)); });
    }
    dataMap['mtn_data'] = mtnData;
    dataMap['glo_data'] = gloData;
    dataMap['airtel_data'] = airtelData;
    dataMap['9mobile_data'] = l9mobileData;
    dataMap['smile_data'] = smileData;
    dataMap['spectranet_data'] = spectranetData;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (mtnData != null) {
      data['mtn_data'] = mtnData!.map((v) => v.toJson()).toList();
    }
    if (gloData != null) {
      data['glo_data'] = gloData!.map((v) => v.toJson()).toList();
    }
    if (airtelData != null) {
      data['airtel_data'] = airtelData!.map((v) => v.toJson()).toList();
    }
    if (l9mobileData != null) {
      data['9mobile_data'] = l9mobileData!.map((v) => v.toJson()).toList();
    }
    if (smileData != null) {
      data['smile_data'] = smileData!.map((v) => v.toJson()).toList();
    }
    if (spectranetData != null) {
      data['spectranet_data'] = spectranetData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataPlan {
  String? variationCode;
  String? name;
  String? variationAmount;
  String? fixedPrice;

  DataPlan({this.variationCode, this.name, this.variationAmount, this.fixedPrice});

  DataPlan.fromJson(Map<String, dynamic> json) {
    variationCode = json['variation_code'];
    name = json['name'];
    variationAmount = json['variation_amount'];
    fixedPrice = json['fixedPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['variation_code'] = variationCode;
    data['name'] = name;
    data['variation_amount'] = variationAmount;
    data['fixedPrice'] = fixedPrice;
    return data;
  }
}
