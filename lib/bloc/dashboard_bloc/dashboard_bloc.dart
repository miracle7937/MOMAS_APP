import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momas_pay/bloc/dashboard_bloc/dashboard_state.dart';
import 'package:momas_pay/domain/service/dashboard_service.dart';

import '../../domain/repository/dashboard_repository.dart';
import 'dashboard_event.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardService service;

  DashboardBloc(this.service) : super(DashboardInitial()) {
    on<DashboardEvent>((event, emit) async {
      if (event is WalletDashboardEvent) {
        await _onWalletEvent(event, emit);
      } else if (event is FeatureDashboardEvent) {
        await _onFeatureEvent(event, emit);
      }
    });
  }

  Future<void> _onWalletEvent(
      DashboardEvent event, Emitter<DashboardState> emit) async {
    super.onEvent(event);
    try {
      if (event is WalletDashboardEvent) {
        emit(WalletLoading());
        var wallet = await service.getBalance();
        if (wallet.status == true) {
          emit(WalletSuccessful(wallet));
        } else {
          emit(WalletFailure());
        }
      }
    } catch (_, e) {
      emit(WalletFailure());
    }
  }

  Future<void> _onFeatureEvent(
      DashboardEvent event, Emitter<DashboardState> emit) async {
    super.onEvent(event);

    try {
      if (event is FeatureDashboardEvent) {
        emit(FeaturesLoading());
        var data = await service.getFeature();
        if (data.status == true) {
          emit(FeaturesSuccessful(data.feature));
        } else {
          emit(FeaturesFailure());
        }
      }
    } catch (_, e) {
      print(e);
      emit(WalletFailure());
    }
  }
}

class WalletBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardService service;

  WalletBloc(this.service) : super(DashboardInitial()) {
    on<WalletDashboardEvent>((event, emit) async {
      emit(WalletLoading());
      try {
        var wallet = await service.getBalance();
        if (wallet.status == true) {
          emit(WalletSuccessful(wallet));
        } else {
          emit(WalletFailure());
        }
      } catch (e) {
        emit(WalletFailure());
      }
    });
  }
}

class PromoBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardService service;

  PromoBloc(this.service) : super(DashboardInitial()) {
    on<PromotionEvent>((event, emit) async {
      emit(FeaturesLoading());
      try {
        var data = await service.getPromo();
        if (data.status == true) {
          emit(PromotionSuccessful(data.promo));
        } else {
          emit(PromotionFailure());
        }
      } catch (e) {
        emit(PromotionFailure());
      }
    });
  }
}
