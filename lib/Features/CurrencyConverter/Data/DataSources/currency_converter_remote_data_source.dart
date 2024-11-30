import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

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
      'q': '${data.baseCurrency}_${data.convertCurrency}',
    };

    return _networkService.unAuthedDio.get(
      EndPointsPaths.convertEndPoint,
      queryParameters: queryParam,
    );
  }

  @override
  Future<Response> getHistoricalData(ConvertRateModel data) {
    if (data.from == null || data.to == null) {
      throw ArgumentError('From and To dates are required for historical data');
    }

    final dateFormat = DateFormat('yyyy-MM-dd');
    Map<String, dynamic> queryParam = {
      'q': '${data.baseCurrency}_${data.convertCurrency}',
      'date': dateFormat.format(data.from!),
      'endDate': dateFormat.format(data.to!),
      'compact': 'ultra'
    };

    return _networkService.unAuthedDio.get(
      EndPointsPaths.convertEndPoint,
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
