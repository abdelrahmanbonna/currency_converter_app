part of 'exchange_rates_bloc.dart';

abstract class ExchangeRatesEvent extends Equatable {
  const ExchangeRatesEvent();

  @override
  List<Object> get props => [];
}

class FetchExchangeRatesEvent extends ExchangeRatesEvent {}

class UpdateExchangeRatesEvent extends ExchangeRatesEvent {
  final Map<String, dynamic> newRates;

  const UpdateExchangeRatesEvent(this.newRates);

  @override
  List<Object> get props => [newRates];
}
