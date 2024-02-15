part of 'exchange_rates_bloc.dart';

abstract class ExchangeRatesState extends Equatable {
  const ExchangeRatesState();
}

class ExchangeRatesInitial extends ExchangeRatesState {
  @override
  List<Object> get props => [];
}
