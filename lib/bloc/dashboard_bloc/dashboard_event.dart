


import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
}

class WalletDashboardEvent extends DashboardEvent{
  @override
  List<Object?> get props => [];
}

class FeatureDashboardEvent extends DashboardEvent{
  @override
  List<Object?> get props => [];
}

class PromotionEvent extends DashboardEvent{
  @override
  List<Object?> get props => [];
}