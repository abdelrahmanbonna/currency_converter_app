import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part './exchange_rates_event.dart';
part './exchange_rates_state.dart';

class ExchangeRatesBloc extends Bloc<ExchangeRatesEvent, ExchangeRatesState> {
  ExchangeRatesBloc() : super(ExchangeRatesInitial()) {
    on<ExchangeRatesEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
