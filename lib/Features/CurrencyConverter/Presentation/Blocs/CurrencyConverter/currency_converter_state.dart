part of './currency_converter_bloc.dart';

abstract class CurrencyConverterState extends Equatable {
  const CurrencyConverterState();
}

class CurrencyConverterInitial extends CurrencyConverterState {
  final double convertedAmount = 0;

  @override
  List<Object> get props => [convertedAmount];
}

class CurrencyConverterConvertSuccess extends CurrencyConverterState {
  final double convertedAmount;
  const CurrencyConverterConvertSuccess({
    required this.convertedAmount,
  });

  @override
  List<Object?> get props => [convertedAmount];
}
