import 'package:equatable/equatable.dart';

import '../payment_bloc/payment_bloc.dart';
import 'momas_bloc.dart';

abstract class MomasPaymentEvent extends Equatable {
  const MomasPaymentEvent();

  @override
  List<Object> get props => [];
}

class MomasVerification extends MomasPaymentEvent {
  final String meterNo;
  final String estateId;

  const MomasVerification({required this.meterNo, required this.estateId});

  @override
  List<Object> get props => [meterNo];
}

class MomasMeterPayment extends MomasPaymentEvent {
  final MomasPaymentType paymentType;
  final String meterType, trxref;
  final String? estateId;
  final String? meterNo;
  String? vendValueKWPerNaira;
  String? totalPaidAmount;
  String? tariffId;
  String? utilityAmount;
  String? vendingAmount;
  String? vatAmount;

  MomasMeterPayment({
    required this.meterType,
    required this.trxref,
    required this.paymentType,
    this.estateId,
    this.meterNo,
    this.vendValueKWPerNaira,
    this.utilityAmount,
    this.tariffId,
    this.totalPaidAmount,
    this.vendingAmount,
    this.vatAmount,
  });

  @override
  List<Object> get props => [meterType, trxref, paymentType];
}

class MomasPaymentHistory extends MomasPaymentEvent {
  const MomasPaymentHistory();
}

class MomasGetVentingProperties extends MomasPaymentEvent {
  const MomasGetVentingProperties();
}
