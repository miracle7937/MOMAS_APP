import 'package:equatable/equatable.dart';
import 'package:momaspayplus/domain/data/response/generic_response.dart';

abstract class AirtimeState extends Equatable {
  const AirtimeState();

  @override
  List<Object> get props => [];
}

class AirtimeInitial extends AirtimeState {}

class AirtimeLoading extends AirtimeState {}

class AirtimeSuccess extends AirtimeState {
  final GenericResponse response;

  const AirtimeSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

class AirtimeFailure extends AirtimeState {
  final String error;

  const AirtimeFailure({required this.error});

  @override
  List<Object> get props => [error];
}
