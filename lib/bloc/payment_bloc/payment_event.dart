import 'package:equatable/equatable.dart';
import 'package:momas_pay/bloc/payment_bloc/payment_bloc.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

class MakePayment extends PaymentEvent {
  final PaymentType payType;
  final String amount;

  const MakePayment({required this.payType, required this.amount});

  @override
  List<Object> get props => [payType, amount];
}

class SearchPayment extends PaymentEvent {
  const SearchPayment();

  @override
  List<Object> get props => [];
}
