import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/data/response/arrears_items.dart';
import '../../domain/repository/bill_repository.dart';

// EVENTS
abstract class CustomerArrearsEvent {}

class GetArrears extends CustomerArrearsEvent {}

class PaySingleArrear extends CustomerArrearsEvent {
  final int id;
  final String paymentRef;
  PaySingleArrear({
    required this.id,
    required this.paymentRef,
  });
}

class PayAllArrears extends CustomerArrearsEvent {
  final String paymentRef;
  PayAllArrears(this.paymentRef);
}

// STATES
abstract class CustomerArrearsState {}

class ArrearsInitial extends CustomerArrearsState {}

class ArrearsLoading extends CustomerArrearsState {}

class ArrearsSuccess extends CustomerArrearsState {
  final List<ArrearItem> arrears;
  ArrearsSuccess({required this.arrears});
}

class ArrearsFailure extends CustomerArrearsState {
  final String error;
  ArrearsFailure({required this.error});
}

class ArrearPaymentLoading extends CustomerArrearsState {}

class ArrearPaymentSuccess extends CustomerArrearsState {
  final String reference;
  ArrearPaymentSuccess({required this.reference});
}

class ArrearPaymentFailure extends CustomerArrearsState {
  final String error;
  ArrearPaymentFailure({required this.error});
}

// BLOC
class CustomerArrearsBloc
    extends Bloc<CustomerArrearsEvent, CustomerArrearsState> {
  final BillRepository repository;

  CustomerArrearsBloc({required this.repository}) : super(ArrearsInitial()) {
    on<GetArrears>(_getArrears);
    on<PaySingleArrear>(_paySingle);
    on<PayAllArrears>(_payAll);
  }

  Future<void> _getArrears(
      GetArrears event, Emitter<CustomerArrearsState> emit) async {
    emit(ArrearsLoading());
    try {
      final List<ArrearItem> jsonList = await repository.getCustomerArrears();
      emit(ArrearsSuccess(arrears: jsonList));
    } catch (e) {
      emit(ArrearsFailure(error: e.toString()));
    }
  }

  Future<void> _paySingle(
      PaySingleArrear event, Emitter<CustomerArrearsState> emit) async {
    emit(ArrearPaymentLoading());
    try {
      final response = await repository.payArrear({
        "type": "single",
        "id": event.id.toString(),
        "paymentRef": event.paymentRef,
      });

      if (response.status == true) {
        emit(ArrearPaymentSuccess(reference: response.message ?? ""));
      } else {
        emit(ArrearPaymentFailure(error: response.message ?? "Payment failed"));
      }
    } catch (e) {
      emit(ArrearPaymentFailure(error: e.toString()));
    }
  }

  Future<void> _payAll(
      PayAllArrears event, Emitter<CustomerArrearsState> emit) async {
    emit(ArrearPaymentLoading());
    try {
      final response = await repository.payArrear({
        "type": "all",
        "paymentRef": event.paymentRef,
      });

      if (response.status == true) {
        emit(ArrearPaymentSuccess(reference: response.message ?? ""));
      } else {
        emit(ArrearPaymentFailure(error: response.message ?? "Payment failed"));
      }
    } catch (e) {
      emit(ArrearPaymentFailure(error: e.toString()));
    }
  }
}
