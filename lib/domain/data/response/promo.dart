class Promo {
  final String url;
  final String? link;

  Promo({required this.url, required this.link});

  factory Promo.fromJson(Map<String, dynamic> json) {
    return Promo(
      url: json['url'],
      link: json['link'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'link': link,
    };
  }
}

class PromoResponse {
  final bool status;
  final List<Promo> promo;

  PromoResponse({required this.status, required this.promo});

  factory PromoResponse.fromJson(Map<String, dynamic> json) {
    return PromoResponse(
      status: json['status'],
      promo: (json['promo'] as List).map((i) => Promo.fromJson(i)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'promo': promo.map((i) => i.toJson()).toList(),
    };
  }
}
