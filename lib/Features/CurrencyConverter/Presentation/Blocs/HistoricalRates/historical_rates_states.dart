import 'package:currency_converter_app/Features/CurrencyConverter/Domain/Entities/convert_rate_entity.dart';
import 'package:equatable/equatable.dart';

abstract class HistoricalRatesState extends Equatable {
  final List<ConvertRateEntity> historicalRates;
  const HistoricalRatesState(this.historicalRates);
}

class InitialHistoricalRatesState extends HistoricalRatesState {
  const InitialHistoricalRatesState(super.historicalRates);

  @override
  List<Object?> get props => [super.historicalRates];
}

class LoadingHistoricalRatesState extends HistoricalRatesState {
  const LoadingHistoricalRatesState(super.historicalRates);

  @override
  List<Object?> get props => [super.historicalRates];
}

class HistoricalRatesFetchSuccess extends HistoricalRatesState {
  const HistoricalRatesFetchSuccess(super.historicalRates);

  @override
  List<Object?> get props => [super.historicalRates];
}

class ErrorHistoricalRatesState extends HistoricalRatesState {
  final String errorMessage;
  const ErrorHistoricalRatesState(super.historicalRates, this.errorMessage);

  @override
  List<Object?> get props => [historicalRates, errorMessage];
}
