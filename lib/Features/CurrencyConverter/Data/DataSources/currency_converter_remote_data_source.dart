import 'package:dio/dio.dart';

import '../../../../Core/Config/end_points_paths.dart';
import '../../../../Core/Services/network_service.dart';
import '../Models/convert_rate_model.dart';
import 'currency_converter_data_source.dart';

class CurrencyConverterRemoteDataSource implements CurrencyConverterDataSource {
  final NetworkService _networkService;

  CurrencyConverterRemoteDataSource(this._networkService);

  @override
  Future<Response> getCurrencyConvert(ConvertRateModel data) {
    Map<String, dynamic> queryParam = {
      'base_currency': data.baseCurrency,
      'currencies': data.convertCurrency,
      EndPointsPaths.apiKeyParamName: EndPointsPaths.apiKey,
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
      EndPointsPaths.apiKeyParamName: EndPointsPaths.apiKey,
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

  @override
  Future<Response> getCurrencies() {
    return _networkService.unAuthedDio.get(
      EndPointsPaths.currenciesEndPoint,
      queryParameters: {
        'currencies': '',
        EndPointsPaths.apiKeyParamName: EndPointsPaths.apiKey,
      },
    );
  }
}
