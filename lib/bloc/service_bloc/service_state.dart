import 'package:equatable/equatable.dart';

import '../../domain/data/response/comment_response.dart';
import '../../domain/data/response/service_data_response.dart';
import '../../domain/data/response/service_response.dart';

abstract class ServiceState extends Equatable {
  const ServiceState();

  @override
  List<Object> get props => [];
}

class ServiceStateInitial extends ServiceState {}

class ServiceStateLoading extends ServiceState {}

class ServiceSearchStateLoading extends ServiceState {}

class ServiceStateFailed extends ServiceState {
  final String error;

  const ServiceStateFailed(this.error);
}

class ServiceStateSuccess extends ServiceState {
  final ServiceDataResponse dataResponse;

  const ServiceStateSuccess(this.dataResponse);

  @override
  List<Object> get props => [];
}

class ServiceSearchStateSuccess extends ServiceState {
  final ServiceSearchResponse dataResponse;

  const ServiceSearchStateSuccess(this.dataResponse);

  @override
  List<Object> get props => [];
}

class ServiceSaveChatStateSuccess extends ServiceState {
  final String message;

  const ServiceSaveChatStateSuccess(this.message);

  @override
  List<Object> get props => [message];
}


class ServiceGetChatStateSuccess extends ServiceState {
  final CommentResponse response;

  const ServiceGetChatStateSuccess(this.response);

  @override
  List<Object> get props => [response];
}
