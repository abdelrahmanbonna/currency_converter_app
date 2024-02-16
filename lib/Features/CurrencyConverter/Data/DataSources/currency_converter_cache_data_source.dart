import 'dart:convert';

import 'package:currency_converter_app/Core/Config/app_constants.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Data/DataSources/currency_converter_data_source.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Data/Models/convert_rate_model.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

class CurrencyConverterCacheDataSource implements CurrencyConverterDataSource {
  final Box _box;
  CurrencyConverterCacheDataSource(this._box);

  @override
  Future<Response> getCurrencies() {
    final data = _box.get(AppConstants.currencyDBKey);

    if (data != null) {
      final jsonData = jsonDecode(data);
      return Future.value(
        Response(
          requestOptions: RequestOptions(
            data: jsonData,
          ),
          data: jsonData,
          statusCode: 200,
        ),
      );
    } else {
      return Future.value(
        Response(
          requestOptions: RequestOptions(
            data: {"msg": "Data not found"},
          ),
          data: {"msg": "Data not found"},
          statusCode: 404,
        ),
      );
    }
  }

  setCurrencyData(Map data) async {
    var dataInJSON = jsonEncode(data);

    _box.put(AppConstants.currencyDBKey, dataInJSON);
  }

  @override
  Future<Response> getCurrencyConvert(ConvertRateModel data) {
    final data = _box.get(AppConstants.exchangeRatesDBKey);

    if (data != null) {
      final jsonData = jsonDecode(data);
      return Future.value(
        Response(
          requestOptions: RequestOptions(
            data: jsonData,
          ),
          data: jsonData,
          statusCode: 200,
        ),
      );
    } else {
      return Future.value(
        Response(
          requestOptions: RequestOptions(
            data: {"msg": "Data not found"},
          ),
          data: {"msg": "Data not found"},
          statusCode: 404,
        ),
      );
    }
  }

  setCurrencyConvertData(Map data) async {
    var dataInJSON = jsonEncode(data);

    _box.put(AppConstants.exchangeRatesDBKey, dataInJSON);
  }

  @override
  Future<Response> getHistoricalData(ConvertRateModel data) {
    // TODO: implement getHistoricalData
    throw UnimplementedError();
  }
}
