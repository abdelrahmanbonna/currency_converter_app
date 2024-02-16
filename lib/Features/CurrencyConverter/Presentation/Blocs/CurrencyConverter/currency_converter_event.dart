part of './currency_converter_bloc.dart';

abstract class CurrencyConverterEvent extends Equatable {
  const CurrencyConverterEvent();
}

class ConvertCurrencyEvent extends CurrencyConverterEvent {
  final double amount;
  final String baseCurrency;
  final String convertCurrency;

  const ConvertCurrencyEvent({
    required this.amount,
    required this.baseCurrency,
    required this.convertCurrency,
  });

  @override
  List<Object?> get props => [amount, baseCurrency, convertCurrency];
}
