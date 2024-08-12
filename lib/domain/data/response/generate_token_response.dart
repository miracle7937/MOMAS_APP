


class GenerateTokenResponse{

  bool? status;
  String? message;
  TokenData? data;

  GenerateTokenResponse({this.status, this.message});

  GenerateTokenResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'].toString() == "true" ? true : false;
    message = json['message'];
    if (json["data"] != null) {
      data = TokenData.fromJson(json["data"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}

class TokenData {
  int? token;
  String? name;
  String? address;
  String? service;

  TokenData({this.token, this.name, this.address, this.service});

  TokenData.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    name = json['name'];
    address = json['address'];
    service = json['service'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['name'] = name;
    data['address'] = address;
    data['service'] = service;
    return data;
  }
}
