import 'package:equatable/equatable.dart';

import '../../domain/data/response/setting_response.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

class SettingsStateInitial extends SettingsState {}

class SettingsStateFailed extends SettingsState {
 final String error;
 const  SettingsStateFailed( this.error);
}

class SettingsStateLoading extends SettingsState {}

class SettingsSupportStateSuccess extends SettingsState {
  final String message;
  const  SettingsSupportStateSuccess( this.message);
}

class SettingsSupportStateLoading extends SettingsState {
  final SettingsDataResponse response;
  const SettingsSupportStateLoading({required this.response});
}