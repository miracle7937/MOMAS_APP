class EstateResponse {
  bool? status;
  List<EstateData>? data;
  String? message;

  EstateResponse({this.status, this.data});

  EstateResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <EstateData>[];
      json['data'].forEach((v) {
        data!.add(EstateData.fromJson(v));
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

class EstateData {
  int? id;
  String? title;
  String? city;
  String? state;
  int? status;

  EstateData({this.id, this.title, this.city, this.state, this.status});

  EstateData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    city = json['city'];
    state = json['state'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['city'] = city;
    data['state'] = state;
    data['status'] = status;
    return data;
  }
}
