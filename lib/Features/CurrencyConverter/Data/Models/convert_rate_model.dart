import 'package:currency_converter_app/Features/CurrencyConverter/Domain/Entities/convert_rate_entity.dart';

class ConvertRateModel extends ConvertRateEntity {
  const ConvertRateModel({
    required super.convertCurrency,
    required super.baseCurrency,
    super.amount,
    super.rate,
    super.from,
    super.to,
  });

  factory ConvertRateModel.fromEntity(ConvertRateEntity entity) {
    return ConvertRateModel(
      convertCurrency: entity.convertCurrency,
      baseCurrency: entity.baseCurrency,
      from: entity.from,
      to: entity.to,
      amount: entity.amount,
      rate: entity.rate,
    );
  }

  factory ConvertRateModel.fromJson(Map<String, dynamic> json) {
    final String pairKey = json['results'].keys.first;
    final result = json['results'][pairKey];
    
    return ConvertRateModel(
      convertCurrency: result['to'],
      baseCurrency: result['fr'],
      rate: result['val'].toDouble(),
      amount: 1.0, // Default amount
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'query': {
        'count': 1,
      },
      'results': {
        '${baseCurrency}_$convertCurrency': {
          'id': '${baseCurrency}_$convertCurrency',
          'val': rate,
          'to': convertCurrency,
          'fr': baseCurrency,
        },
      },
    };
  }
}
