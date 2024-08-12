

class ServiceDataResponse {
  bool? status;
  Data? data;
  String? message;

  ServiceDataResponse({this.status, this.data, this.message});

  ServiceDataResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Estate>? estate;
  List<Service>? service;

  Data({this.estate, this.service});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['estate'] != null) {
      estate = <Estate>[];
      json['estate'].forEach((v) {
        estate!.add(new Estate.fromJson(v));
      });
    }
    if (json['service'] != null) {
      service = <Service>[];
      json['service'].forEach((v) {
        service!.add(new Service.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (estate != null) {
      data['estate'] = estate!.map((v) => v.toJson()).toList();
    }
    if (service != null) {
      data['service'] = service!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Estate {
  int? id;
  String? title;
  String? city;
  String? state;
  int? status;

  Estate({this.id, this.title, this.city, this.state, this.status});

  Estate.fromJson(Map<String, dynamic> json) {
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

class Service {
  int? id;
  String? serviceTitle;
  int? status;

  Service({this.id, this.serviceTitle, this.status});

  Service.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceTitle = json['service_title'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['service_title'] = serviceTitle;
    data['status'] = status;
    return data;
  }
}
