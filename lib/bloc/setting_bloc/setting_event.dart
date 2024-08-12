

import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class SupportSettingEvent extends SettingsEvent{}
class DeleteEvent extends SettingsEvent{
  final String email;

  const DeleteEvent({required this.email});
}


class RequestMeterEvent extends SettingsEvent{
  final String email;
  final String fullName;
  final String phoneNumber;
  final String address;

  const RequestMeterEvent(this.email, this.fullName, this.phoneNumber, this.address);
}

