enum Network { mtn, glo, airtel, n9Mobile }

extension NetworkExtension on Network {
  String get displayName {
    switch (this) {
      case Network.mtn:
        return "mtn_data";
      case Network.n9Mobile:
        return "9mobile_data";
      case Network.airtel:
        return "airtel_data";
      case Network.glo:
        return "glo_data";
    }
  }
}

enum CableEnum { gotv, dstv, startimes, showmax }
