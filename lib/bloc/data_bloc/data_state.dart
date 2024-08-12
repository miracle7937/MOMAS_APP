
import 'package:equatable/equatable.dart';
import 'package:momas_pay/domain/data/response/data_response.dart';
import 'package:momas_pay/domain/data/response/generic_response.dart';

abstract class DataState extends Equatable {
  const DataState();

  @override
  List<Object> get props => [];
}

class DataInitial extends DataState {}

class DataLoading extends DataState {}

class DataSuccess extends DataState {
  final DataResponse response;

  const DataSuccess({required this.response});

  @override
  List<Object> get props => [response];
}


class BuyDataSuccess extends DataState {
  final GenericResponse response;

  const BuyDataSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

class DataFailure extends DataState {
  final String error;

  const DataFailure({required this.error});

  @override
  List<Object> get props => [error];
}