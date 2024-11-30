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
  final double convertedAmount;
  final List<CurrencyEntity> currencies;

  const CurrenciesFetchSuccess(this.convertedAmount, this.currencies)
      : super(0.0);

  @override
  List<Object?> get props => [convertedAmount, currencies];
}
