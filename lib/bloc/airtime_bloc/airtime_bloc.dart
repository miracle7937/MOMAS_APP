import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momas_pay/domain/data/response/generic_response.dart';
import 'package:momas_pay/domain/repository/bill_repository.dart';

import '../../domain/data/request/airtime_request.dart';
import 'airtime_event.dart';
import 'airtime_state.dart';


class AirtimeBloc extends Bloc<AirtimeEvent, AirtimeState> {
  final BillRepository repository;

  AirtimeBloc({required this.repository}) : super(AirtimeInitial()){
    on<BuyAirtime>((event, emit) async {
        await mapEventToState(event, emit);

    });  }

 Future mapEventToState(AirtimeEvent event,  Emitter<AirtimeState> emit) async {
    if (event is BuyAirtime) {
      emit(AirtimeLoading());
      try {
        final AirtimeRequest request = AirtimeRequest(
          ref: event.ref ,
          serviceId: event.serviceId,
          amount: event.amount,
          phone: event.phone,
        );
        final GenericResponse response = await repository.buyAirtime(request);
       if(response.status ==true){
         emit(AirtimeSuccess(response: response));
       }else{
         emit(AirtimeFailure(error: response.message ?? ""));
       }
      } catch (e) {
        emit(AirtimeFailure(error: e.toString()));
      }
    }
  }
}
