import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momas_pay/domain/data/response/vending_properties.dart';

import '../../domain/data/request/momas_meter_buy.dart';
import '../../domain/data/request/momas_payent_response.dart';
import '../../domain/data/response/meter_payment_response.dart';
import '../../domain/data/response/momas_meter_response.dart';
import '../../domain/repository/bill_repository.dart';
import 'momas_event.dart';
import 'momas_state.dart';

class MomasPaymentBloc extends Bloc<MomasPaymentEvent, MomasPaymentState> {
  final BillRepository repository;

  MomasPaymentBloc({required this.repository}) : super(MomasPaymentInitial()) {
    on<MomasVerification>((event, emit) async {
      await onVerify(event, emit);
    });
    on<MomasMeterPayment>((event, emit) async {
      await onPayment(event, emit);
    });
    on<MomasPaymentHistory>((event, emit) async {
      await onPaymentHistory(event, emit);
    });

    on<MomasGetVentingProperties>((event, emit) async {
      await onGetVendingProperties(event, emit);
    });
  }

  Future onVerify(
      MomasVerification event, Emitter<MomasPaymentState> emit) async {
    emit(MomasVerificationLoading());
    try {
      final MomasVerificationResponse response =
          await repository.verifyMomasMeter(event.meterNo, event.estateId);
      if (response.status == true) {
        emit(MomasMeterVerificationState(response: response));
      } else {
        emit(MomasPaymentFailure(
            error: response.message ?? "Fail to verify momas meter"));
      }
    } catch (e) {
      emit(MomasPaymentFailure(error: e.toString()));
    }
  }

  Future onPayment(
      MomasMeterPayment event, Emitter<MomasPaymentState> emit) async {
    emit(MomasPaymentLoading());
    try {
      var data = MomasMeterBuy(
          vatAmount: event.vatAmount,
          estateId: event.estateId,
          vendValueKWPerNaira: event.vendValueKWPerNaira,
          utilityAmount: event.utilityAmount,
          tariffId: event.tariffId,
          vendingAmount: event.vendingAmount,
          totalPaidAmount: event.totalPaidAmount,
          trxref: event.trxref,
          meterType: event.meterType,
          meterNo: event.meterNo);
      MomasPaymentResponse? response;
      if (event.paymentType == MomasPaymentType.self) {
        response = await repository.payMomasMeter(data);
      } else {
        response = await repository.payOtherMomasMeter(data);
      }
      if (response.status == true) {
        emit(MomasPaymentSuccess(response));
      } else {
        emit(MomasPaymentFailure(error: response.message ?? "Payment fails"));
      }
    } catch (e) {
      emit(MomasPaymentFailure(error: e.toString()));
    }
  }

  Future onPaymentHistory(
      MomasPaymentHistory event, Emitter<MomasPaymentState> emit) async {
    emit(MomasPaymentLoading());
    try {
      MeterPaymentResponse response = await repository.getMomasMeterHistory();

      if (response.status == true) {
        emit(MomasMeterSuccess(response));
      } else {
        emit(MomasPaymentFailure(error: response.message ?? "Payment fails"));
      }
    } catch (e, _) {
      print(e);
      print(_);
      emit(MomasPaymentFailure(error: e.toString()));
    }
  }

  Future onGetVendingProperties(
      MomasGetVentingProperties event, Emitter<MomasPaymentState> emit) async {
    emit(MomasPaymentLoading());
    try {
      VendingPropertiesData response = await repository.getVendingProperties();

      if (response.status == true) {
        emit(MomasVendingProperties(response));
      } else {
        emit(const MomasPaymentFailure(
            error: "Fails to get vending parameters"));
      }
    } catch (e, _) {
      print(e);
      print(_);
      emit(MomasPaymentFailure(error: e.toString()));
    }
  }
}

enum MomasPaymentType { self, others }
