
import 'package:equatable/equatable.dart';

abstract class ServiceEvent extends Equatable {
  const ServiceEvent();

  @override
  List<Object> get props => [];
}

class ServicePropertiesEvent extends ServiceEvent {
  const ServicePropertiesEvent();

  @override
  List<Object> get props => [];
}

class ServiceSearchEvent extends ServiceEvent {
  final String estateId;
 final String serviceId;
  const ServiceSearchEvent(this.estateId, this.serviceId);

  @override
  List<Object> get props => [ estateId, serviceId];
}


class ServicePostCommentEvent extends ServiceEvent {
  final String comment;
  final String rating;
  final String jobId;
  const ServicePostCommentEvent(this.comment, this.rating, this.jobId);

  @override
  List<Object> get props => [ comment, rating, jobId];
}


class  GetCommentEvent extends ServiceEvent {
  final String jobId;
  const GetCommentEvent(this.jobId);

  @override
  List<Object> get props => [ jobId];
}



