import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part './exchange_rates_event.dart';
part './exchange_rates_state.dart';

class ExchangeRatesBloc extends Bloc<ExchangeRatesEvent, ExchangeRatesState> {
  ExchangeRatesBloc() : super(ExchangeRatesInitial()) {
    on<FetchExchangeRatesEvent>(_onFetchExchangeRates);
    on<UpdateExchangeRatesEvent>(_onUpdateExchangeRates);
  }

  void _onFetchExchangeRates(
      FetchExchangeRatesEvent event, Emitter<ExchangeRatesState> emit) async {
    emit(ExchangeRatesLoading());
    try {
      final exchangeRates =
          <String, dynamic>{}; // Placeholder for fetched rates
      emit(ExchangeRatesLoaded(exchangeRates));
    } catch (error) {
      emit(ExchangeRatesError(error.toString()));
    }
  }

  void _onUpdateExchangeRates(
      UpdateExchangeRatesEvent event, Emitter<ExchangeRatesState> emit) {
    final Map<String, dynamic> convertedRates =
        Map<String, dynamic>.from(event.newRates);
    emit(ExchangeRatesLoaded(convertedRates));
  }
}
