import 'package:bloc/bloc.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Presentation/Blocs/HistoricalRates/historical_rates_events.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Domain/Repositories/currency_converter_repository.dart';
import 'package:flutter/foundation.dart';

import 'historical_rates_states.dart';

class HistoricalRatesBloc
    extends Bloc<HistoricalRatesEvent, HistoricalRatesState> {
  final CurrencyConverterRepository _repository;
  HistoricalRatesBloc(this._repository)
      : super(const InitialHistoricalRatesState([])) {
    on<GetHistoricalRatesEvent>((event, emit) async {
      emit(const LoadingHistoricalRatesState([]));
      try {
        final rates =
            await _repository.getHistoricalRates(event.convertRateEntity);

        if (kDebugMode) {
          print('Bloc received rates result: $rates');
        } // Debug log

        if (rates.isValue) {
          final ratesList = rates.asValue!.value;
          if (kDebugMode) {
            print('Emitting success with ${ratesList.length} rates');
          } // Debug log
          emit(HistoricalRatesFetchSuccess(ratesList));
        } else {
          if (kDebugMode) {
            print('Emitting error: ${rates.asError!.error}');
          } // Debug log
          emit(ErrorHistoricalRatesState(
              const [], rates.asError!.error.toString()));
        }
      } catch (error, stackTrace) {
        if (kDebugMode) {
          print('Bloc error: $error');
          print('Stack trace: $stackTrace');
        }
        emit(ErrorHistoricalRatesState(const [], error.toString()));
      }
    });
  }
}
