import 'package:currency_converter_app/Core/Config/end_points_paths.dart';
import 'package:currency_converter_app/Core/Services/network_service.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Data/Models/convert_rate_model.dart';
import 'package:dio/dio.dart';

abstract class CurrencyConverterDataSource {
  Future<Response> getCurrencyConvert(ConvertRateModel data);
  Future<Response> getHistoricalData(ConvertRateModel data);
}

class CurrencyConverterRemoteDataSource implements CurrencyConverterDataSource {
  final NetworkService _networkService;

  CurrencyConverterRemoteDataSource(this._networkService);

  @override
  Future<Response> getCurrencyConvert(ConvertRateModel data) {
    Map<String, dynamic> queryParam = {
      'base_currency': data.baseCurrency,
      'currencies': data.convertCurrency,
    };

    return _networkService.unAuthedDio.get(
      EndPointsPaths.convertEndPoint,
      queryParameters: queryParam,
    );
  }

  @override
  Future<Response> getHistoricalData(ConvertRateModel data) {
    Map<String, dynamic> queryParam = {
      'base_currency': data.baseCurrency,
      'currencies': data.convertCurrency,
    };

    if (data.from != null && data.to != null) {
      queryParam['date_from'] =
          '${data.from!.year}-${data.from!.month}-${data.from!.day}';
      queryParam['date_to'] =
          '${data.to!.year}-${data.to!.month}-${data.to!.day}';
    }

    return _networkService.unAuthedDio.get(
      EndPointsPaths.historicalDataEndPoint,
      queryParameters: queryParam,
    );
  }
}
