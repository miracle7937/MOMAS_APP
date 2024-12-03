import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momas_pay/bloc/payment_bloc/payment_event.dart';
import 'package:momas_pay/bloc/payment_bloc/payment_state.dart';

import '../../domain/repository/payment_repository.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository repository;

  PaymentBloc(this.repository) : super(PaymentInitial()) {
    on<MakePayment>((event, emit) async {
      await payment(event, emit);
    });
    on<SearchPayment>((event, emit) async {
      await searchPayment(event, emit);
    });
    on<RetryPayment>((event, emit) async {
      await retryPayment(event, emit);
    });
  }

  payment(PaymentEvent event, Emitter<PaymentState> emit) async {
    if (event is MakePayment) {
      emit(PaymentLoading());
      try {
        final response =
            await repository.fudWallet(event.amount, event.payType.name);
        if (response.status == true) {
          if (event.payType == PaymentType.wallet) {
            emit(PaymentWalletSuccess(
                message: "Wallet Payment was successful",
                ref: response.ref ?? ""));
            return;
          } else {
            emit(PaymentSuccess(url: response.url ?? ""));
          }
        } else {
          emit(PaymentFailure(error: response.message ?? 'Network error'));
        }
      } catch (e) {
        emit(PaymentFailure(error: e.toString()));
      }
    }
  }

  searchPayment(SearchPayment event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());
    try {
      final response = await repository.searchTransaction();
      if (response.status == true) {
        emit(PaymentHistorySuccess(response.data ?? []));
      } else {
        emit(const PaymentFailure(error: 'Network error'));
      }
    } catch (e) {
      emit(PaymentFailure(error: e.toString()));
    }
  }

  retryPayment(RetryPayment event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());
    try {
      final response = await repository.retryPayment(event.transactionId);
      if (response.status == true) {
        emit(MomasPaymentSuccess(response));
      } else {
        emit(PaymentFailure(error: response.message ?? "Network issue"));
      }
    } catch (e, _) {
      print(_);
      emit(PaymentFailure(error: e.toString()));
    }
  }
}

enum PaymentType { paystack, wallet, flutterwave, remita }
