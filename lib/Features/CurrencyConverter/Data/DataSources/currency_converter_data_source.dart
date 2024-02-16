import 'package:currency_converter_app/Features/CurrencyConverter/Data/Models/convert_rate_model.dart';
import 'package:dio/dio.dart';

abstract class CurrencyConverterDataSource {
  Future<Response> getCurrencyConvert(ConvertRateModel data);

  Future<Response> getHistoricalData(ConvertRateModel data);

  Future<Response> getCurrencies();
}
