import 'package:equatable/equatable.dart';
import 'package:momaspayplus/domain/data/response/estate_response.dart';

import '../../domain/data/response/access_token_list_data.dart';
import '../../domain/data/response/generate_token_response.dart';

abstract class AccessTokenState extends Equatable {
  const AccessTokenState();

  @override
  List<Object> get props => [];
}

class AccessTokenInitial extends AccessTokenState {}

class AccessTokenLoading extends AccessTokenState {}

class AccessTokenFailed extends AccessTokenState {
  final String error;

  const AccessTokenFailed(this.error);
}

class AccessTokenSuccess extends AccessTokenState {
  final List<EstateData> estateData;
  const AccessTokenSuccess(this.estateData);

  @override
  List<Object> get props => [];
}

class SetEstateSuccess extends AccessTokenState {
  final String message;

  const SetEstateSuccess(this.message);
}

class VerifyTokenSuccess extends AccessTokenState {
  final String message;

  const VerifyTokenSuccess(this.message);
}

class GenerateTokenSuccess extends AccessTokenState {
  final GenerateTokenResponse data;
  const GenerateTokenSuccess(this.data);
}

class GetTokenListSuccess extends AccessTokenState {
  final List<TokenBody> data;
  const GetTokenListSuccess(this.data);
}
