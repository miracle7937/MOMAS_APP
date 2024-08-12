import 'package:equatable/equatable.dart';

abstract class AirtimeEvent extends Equatable {
  const AirtimeEvent();

  @override
  List<Object> get props => [];
}

class BuyAirtime extends AirtimeEvent {
  final String serviceId;
  final String amount;
  final String phone;
  final String ref;

  const BuyAirtime({required this.serviceId, required this.amount, required this.phone, required this.ref});

  @override
  List<Object> get props => [serviceId, amount, phone, ref];
}
