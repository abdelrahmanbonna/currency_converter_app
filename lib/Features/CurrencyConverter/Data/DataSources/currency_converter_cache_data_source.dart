import 'dart:convert';

import 'package:currency_converter_app/Core/Config/app_constants.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Data/DataSources/currency_converter_data_source.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Data/Models/convert_rate_model.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class CurrencyConverterCacheDataSource implements CurrencyConverterDataSource {
  final Box _box;
  CurrencyConverterCacheDataSource(this._box);

  Response _notFoundResponse() {
    return Response(
      requestOptions: RequestOptions(path: ''),
      data: {'msg': 'Data not found'},
      statusCode: 404,
    );
  }

  @override
  Future<Response> getCurrencies() async {
    final data = _box.get(AppConstants.currencyDBKey);
    if (data == null) return _notFoundResponse();

    try {
      final jsonData = jsonDecode(data);
      return Response(
        requestOptions: RequestOptions(path: ''),
        data: jsonData,
        statusCode: 200,
      );
    } catch (e) {
      return _notFoundResponse();
    }
  }

  @override
  Future<Response> getCurrencyConvert(ConvertRateModel data) async {
    final String cacheKey =
        '${AppConstants.exchangeRatesDBKey}_${data.baseCurrency}_${data.convertCurrency}';
    final cachedData = _box.get(cacheKey);
    if (cachedData == null) return _notFoundResponse();

    try {
      final jsonData = jsonDecode(cachedData);
      return Response(
        requestOptions: RequestOptions(path: ''),
        data: jsonData,
        statusCode: 200,
      );
    } catch (e) {
      throw const FormatException('Invalid cache data format');
    }
  }

  @override
  Future<Response> getHistoricalData(ConvertRateModel data) async {
    if (data.from == null || data.to == null) {
      throw ArgumentError('From and To dates are required for historical data');
    }

    final dateFormat = DateFormat('yyyy-MM-dd');
    final String cacheKey =
        '${AppConstants.historicalRatesDBKey}_${data.baseCurrency}_${data.convertCurrency}_${dateFormat.format(data.from!)}_${dateFormat.format(data.to!)}';
    final historicalData = _box.get(cacheKey);
    if (historicalData == null) return _notFoundResponse();

    try {
      final jsonData = jsonDecode(historicalData);
      return Response(
        requestOptions: RequestOptions(path: ''),
        data: jsonData,
        statusCode: 200,
      );
    } catch (e) {
      return _notFoundResponse();
    }
  }

  Future<void> setCurrencyData(Map<String, dynamic> data) async {
    final dataInJSON = jsonEncode(data);
    await _box.put(AppConstants.currencyDBKey, dataInJSON);
  }

  Future<void> setCurrencyConvertData(Map<String, dynamic> data) async {
    if (data['results'] == null || (data['results'] as Map).isEmpty) return;

    final String pairKey = (data['results'] as Map).keys.first;
    final String cacheKey = '${AppConstants.exchangeRatesDBKey}_$pairKey';
    final dataInJSON = jsonEncode(data);
    await _box.put(cacheKey, dataInJSON);
  }

  Future<void> setHistoricalData(
      Map<String, dynamic> data, ConvertRateModel model) async {
    if (data.isEmpty || model.from == null || model.to == null) return;

    final dateFormat = DateFormat('yyyy-MM-dd');
    final String cacheKey =
        '${AppConstants.historicalRatesDBKey}_${model.baseCurrency}_${model.convertCurrency}_${dateFormat.format(model.from!)}_${dateFormat.format(model.to!)}';
    final dataInJSON = jsonEncode(data);
    await _box.put(cacheKey, dataInJSON);
  }
}
