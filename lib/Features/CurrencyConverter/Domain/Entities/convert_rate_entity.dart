import 'package:equatable/equatable.dart';

class ConvertRateEntity extends Equatable {
  final double amount;
  final double rate;
  final String convertCurrency;
  final String baseCurrency;
  final DateTime? from;
  final DateTime? to;

  const ConvertRateEntity({
    this.amount = 0,
    this.rate = 0,
    this.from,
    this.to,
    required this.convertCurrency,
    required this.baseCurrency,
  });

  @override
  List<Object?> get props => [
        amount,
        rate,
        convertCurrency,
        baseCurrency,
        from,
        to,
      ];

  double get convertedAmount => amount * rate;

  ConvertRateEntity copyWith({
    double? amount,
    double? rate,
    String? convertCurrency,
    String? baseCurrency,
    DateTime? from,
    DateTime? to,
  }) {
    return ConvertRateEntity(
      amount: amount ?? this.amount,
      rate: rate ?? this.rate,
      convertCurrency: convertCurrency ?? this.convertCurrency,
      baseCurrency: baseCurrency ?? this.baseCurrency,
      from: from ?? this.from,
      to: to ?? this.to,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'rate': rate,
      'convertCurrency': convertCurrency,
      'baseCurrency': baseCurrency,
      'from': from?.toString(),
      'to': to?.toString(),
    };
  }
}
