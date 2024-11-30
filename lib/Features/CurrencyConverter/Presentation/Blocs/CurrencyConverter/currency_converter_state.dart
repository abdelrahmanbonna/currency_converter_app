part of './currency_converter_bloc.dart';

abstract class CurrencyConverterState extends Equatable {
  final double convertedAmount;
  const CurrencyConverterState(this.convertedAmount);
}

class CurrencyConverterInitial extends CurrencyConverterState {
  const CurrencyConverterInitial(super.convertedAmount);

  @override
  List<Object> get props => [convertedAmount];
}

class CurrencyConverterConvertSuccess extends CurrencyConverterState {
  const CurrencyConverterConvertSuccess(super.convertedAmount);

  @override
  List<Object?> get props => [convertedAmount];
}

class CurrenciesFetchSuccess extends CurrencyConverterState {
  final List<CurrencyEntity> currencies;

  const CurrenciesFetchSuccess(super.convertedAmount, this.currencies);

  @override
  List<Object?> get props => [convertedAmount, currencies];
}
