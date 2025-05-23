import 'package:momaspayplus/domain/data/response/promo.dart';
import 'package:momaspayplus/domain/data/response/wallet.dart';

import '../../utils/routes.dart';
import '../data/response/feature.dart';
import '../data/response/user_model.dart';
import '../request.dart';

class DashboardRepository {
  final ServerRequest _request = ServerRequest();

  Future<Wallet> balance() async {
    var response = await _request.postData(
      path: Routes.balance,
    );
    return Wallet.fromJson(response.data);
  }

  Future<DashboardModel> features() async {
    var response = await _request.getData(
      path: Routes.features,
    );
    return DashboardModel.fromJson(response.data);
  }

  Future<PromoResponse> getPromo() async {
    var response = await _request.getData(
      path: Routes.promo,
    );
    return PromoResponse.fromJson(response.data);
  }

  Future<UserModel> getUser() async {
    var response = await _request.getData(
      path: Routes.getUser,
    );
    return UserModel.fromJson(response.data);
  }
}
