import 'package:equatable/equatable.dart';
import 'package:momas_pay/domain/data/request/generate_token_request.dart';
import 'package:momas_pay/domain/data/request/set_estate_request.dart';

abstract class AccessTokenEvent extends Equatable {
  const AccessTokenEvent();

  @override
  List<Object> get props => [];
}

class GetAccessToken extends AccessTokenEvent {
  const GetAccessToken();

  @override
  List<Object> get props => [];
}

class SetEstate extends AccessTokenEvent {
  final SetEstateRequest data;

  const SetEstate(this.data);

  @override
  List<Object> get props => [data];
}

class GenerateTokenEvent extends AccessTokenEvent {
  final GenerateTokenRequest data;

  const GenerateTokenEvent(this.data);

  @override
  List<Object> get props => [data];
}
