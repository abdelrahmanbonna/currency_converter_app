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
}
