class ServiceSearchResponse {
  bool? status;
  List<SearchData>? data;
  String? message;

  ServiceSearchResponse({this.status, this.data, this.message});

  ServiceSearchResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <SearchData>[];
      json['data'].forEach((v) {
        data!.add(SearchData.fromJson(v));
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

class SearchData {
  int? id;
  String? estateId;
  String? serviceId;
  String? serviceTitle;
  int? status;
  String? professionalName;
  String? professionalPhone;
  String? professionalEmail;
  String? rating;
  String? commentId;

  SearchData(
      {this.id,
        this.estateId,
        this.serviceId,
        this.serviceTitle,
        this.status,
        this.professionalName,
        this.professionalPhone,
        this.professionalEmail,
        this.rating,
        this.commentId});

  SearchData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    estateId = json['estate_id'];
    serviceId = json['service_id'];
    serviceTitle = json['service_title'];
    status = json['status'];
    professionalName = json['professional_name'];
    professionalPhone = json['professional_phone'];
    professionalEmail = json['professional_email'];
    rating = json['rating'];
    commentId = json['comment_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['estate_id'] = estateId;
    data['service_id'] = serviceId;
    data['service_title'] = serviceTitle;
    data['status'] = status;
    data['professional_name'] = professionalName;
    data['professional_phone'] = professionalPhone;
    data['professional_email'] = professionalEmail;
    data['rating'] = rating;
    data['comment_id'] = commentId;
    return data;
  }
}
