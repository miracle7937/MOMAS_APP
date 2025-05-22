class DashboardModel {
  bool status;
  Feature feature;

  DashboardModel({
    required this.status,
    required this.feature,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      status: json['status'],
      feature: Feature.fromJson(json['feature']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'feature': feature.toJson(),
    };
  }
}

class Feature {
  int id;
  int momasMeter;
  int otherMeter;
  int printToken;
  int accessToken;
  int services;
  int billPayment;
  int support;
  int topUp;
  int analysis;

  Feature({
    required this.id,
    required this.momasMeter,
    required this.otherMeter,
    required this.printToken,
    required this.accessToken,
    required this.services,
    required this.billPayment,
    required this.support,
    required this.topUp,
    required this.analysis,
  });

  factory Feature.fromJson(Map<String, dynamic> json) {
    return Feature(
      id: json['id'],
      momasMeter: json['momas_meter'],
      otherMeter: json['other_meter'],
      printToken: json['print_token'],
      accessToken: json['access_token'],
      services: json['services'],
      billPayment: json['bill_payment'],
      support: json['support'],
      topUp: json['top_up'],
      analysis: json['analysis'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'momas_meter': momasMeter,
      'other_meter': otherMeter,
      'print_token': printToken,
      'access_token': accessToken,
      'services': services,
      'bill_payment': billPayment,
      'support': support,
      'top_up': topUp,
      'analysis': analysis,
    };
  }
}
