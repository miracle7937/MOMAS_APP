import 'package:momaspayplus/domain/data/response/feature.dart';
import 'package:momaspayplus/domain/data/response/promo.dart';
import 'package:momaspayplus/domain/data/response/user_model.dart';
import 'package:momaspayplus/domain/repository/dashboard_repository.dart';

import '../data/response/wallet.dart';

class DashboardService {
  final DashboardRepository repository;

  DashboardService(this.repository);

  Future<Wallet> getBalance() async {
    return await repository.balance();
  }

  Future<DashboardModel> getFeature() async {
    return await repository.features();
  }

  Future<PromoResponse> getPromo() async {
    return await repository.getPromo();
  }

  Future<UserModel> getUser() async {
    return await repository.getUser();
  }
}
