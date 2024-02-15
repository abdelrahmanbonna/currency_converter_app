import 'package:async/async.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Domain/Entities/convert_rate_entity.dart';

abstract class CurrencyConverterRepository {
  Future<Result<ConvertRateEntity>> getConvertRates(ConvertRateEntity info);
}
