import 'package:equatable/equatable.dart';
import 'package:momaspayplus/domain/data/response/feature.dart';
import 'package:momaspayplus/domain/data/response/user_model.dart';
import 'package:momaspayplus/domain/data/response/wallet.dart';

import '../../domain/data/response/promo.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {}

class WalletLoading extends DashboardState {}

class FeaturesLoading extends DashboardState {}

class PromotionLoading extends DashboardState {}

class WalletFailure extends DashboardState {}

class FeaturesFailure extends DashboardState {}

class PromotionFailure extends DashboardState {}

class FeaturesSuccessful extends DashboardState {
  final Feature feature;
  const FeaturesSuccessful(this.feature);
  @override
  List<Object> get props => [feature];
}

class WalletSuccessful extends DashboardState {
  final Wallet wallet;
  const WalletSuccessful(this.wallet);
  @override
  List<Object> get props => [wallet];
}

class PromotionSuccessful extends DashboardState {
  final List<Promo> promo;
  const PromotionSuccessful(this.promo);
  @override
  List<Object> get props => [promo];
}

class GetUserSuccessful extends DashboardState {
  final UserModel userModel;
  const GetUserSuccessful(this.userModel);
  @override
  List<Object> get props => [userModel];
}
