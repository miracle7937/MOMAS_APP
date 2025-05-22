import 'package:equatable/equatable.dart';
import 'package:momaspayplus/bloc/payment_bloc/payment_bloc.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

class MakePayment extends PaymentEvent {
  final PaymentType payType;
  final String amount;
  final ServiceType serviceType;

  const MakePayment(
      {required this.serviceType, required this.payType, required this.amount});

  @override
  List<Object> get props => [payType, amount, serviceType];
}

class SearchPayment extends PaymentEvent {
  const SearchPayment();

  @override
  List<Object> get props => [];
}

class GenerateAccount extends PaymentEvent {
  const GenerateAccount();

  @override
  List<Object> get props => [];
}

class RetryPayment extends PaymentEvent {
  const RetryPayment(this.transactionId);
  final String transactionId;

  @override
  List<Object> get props => [];
}

class ViewReceipt extends PaymentEvent {
  final String transactionId;
  const ViewReceipt(this.transactionId);

  @override
  List<Object> get props => [];
}
