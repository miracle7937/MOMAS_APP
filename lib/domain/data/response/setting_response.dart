


class SettingsDataResponse {
  bool? status;
  SupportData? data;

  SettingsDataResponse({this.status, this.data});

  SettingsDataResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new SupportData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class SupportData {
  String? paymentSupport;
  String? meterSupport;
  String? generalSupport;

  SupportData({this.paymentSupport, this.meterSupport, this.generalSupport});

  SupportData.fromJson(Map<String, dynamic> json) {
    paymentSupport = json['payment_support'];
    meterSupport = json['meter_support'];
    generalSupport = json['general_support'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['payment_support'] = paymentSupport;
    data['meter_support'] = meterSupport;
    data['general_support'] = generalSupport;
    return data;
  }
}
