class CableTvResponse {
  bool? status;
  List<CableData>? dstv;
  List<CableData>? gotv;
  List<CableData>? startimes;
  List<CableData>? showmax;


  Map<String, List<CableData>?> dataMap = {};

  CableTvResponse(
      {this.status, this.dstv, this.gotv, this.startimes, this.showmax});

  CableTvResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['dstv'] != null) {
      dstv = <CableData>[];
      json['dstv'].forEach((v) {
        dstv!.add(CableData.fromJson(v));
      });
    }
    if (json['gotv'] != null) {
      gotv = <CableData>[];
      json['gotv'].forEach((v) {
        gotv!.add(CableData.fromJson(v));
      });
    }
    if (json['startimes'] != null) {
      startimes = <CableData>[];
      json['startimes'].forEach((v) {
        startimes!.add(CableData.fromJson(v));
      });
    }
    if (json['showmax'] != null) {
      showmax = <CableData>[];
      json['showmax'].forEach((v) {
        showmax!.add(CableData.fromJson(v));
      });
    }
    dataMap['gotv'] = gotv;
    dataMap['dstv'] = dstv;
    dataMap['startimes'] = startimes;
    dataMap['showmax'] = showmax;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (dstv != null) {
      data['dstv'] = dstv!.map((v) => v.toJson()).toList();
    }
    if (gotv != null) {
      data['gotv'] = gotv!.map((v) => v.toJson()).toList();
    }
    if (startimes != null) {
      data['startimes'] = startimes!.map((v) => v.toJson()).toList();
    }
    if (showmax != null) {
      data['showmax'] = showmax!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CableData {
  String? variationCode;
  String? name;
  String? variationAmount;
  String? fixedPrice;

  CableData({this.variationCode, this.name, this.variationAmount, this.fixedPrice});

  CableData.fromJson(Map<String, dynamic> json) {
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
