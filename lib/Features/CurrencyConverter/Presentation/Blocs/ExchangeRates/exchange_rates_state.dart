part of 'exchange_rates_bloc.dart';

abstract class ExchangeRatesState extends Equatable {
  const ExchangeRatesState();

  @override
  List<Object> get props => [];
}

class ExchangeRatesInitial extends ExchangeRatesState {
  @override
  List<Object> get props => [];
}

class ExchangeRatesLoading extends ExchangeRatesState {}

class ExchangeRatesLoaded extends ExchangeRatesState {
  final Map<String, dynamic> exchangeRates;

  const ExchangeRatesLoaded(this.exchangeRates);

  @override
  List<Object> get props => [exchangeRates];
}

class ExchangeRatesError extends ExchangeRatesState {
  final String errorMessage;

  const ExchangeRatesError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
