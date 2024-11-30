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
    final String cacheKey = '${AppConstants.exchangeRatesDBKey}_${data.baseCurrency}_${data.convertCurrency}';
    final cachedData = _box.get(cacheKey);

    if (cachedData != null) {
      final jsonData = jsonDecode(cachedData);
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
    if (data['results'] == null || (data['results'] as Map).isEmpty) {
      return; // Don't cache invalid data
    }
    
    final String pairKey = data['results'].keys.first;
    final String cacheKey = '${AppConstants.exchangeRatesDBKey}_$pairKey';
    
    var dataInJSON = jsonEncode(data);
    _box.put(cacheKey, dataInJSON);
  }

  @override
  Future<Response> getHistoricalData(ConvertRateModel data) {
    final String cacheKey = '${AppConstants.historicalRatesDBKey}_${data.baseCurrency}_${data.convertCurrency}';
    final historicalData = _box.get(cacheKey);

    if (historicalData != null) {
      final jsonData = jsonDecode(historicalData);

      // Filter historical data based on input parameters
      final filteredData = _filterHistoricalData(jsonData, data);

      return Future.value(
        Response(
          requestOptions: RequestOptions(
            data: filteredData,
          ),
          data: filteredData,
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

  setHistoricalData(Map<String, dynamic> data) async {
    if (data['results'] == null || (data['results'] as Map).isEmpty) {
      return; // Don't cache invalid data
    }
    
    final String pairKey = data['results'].keys.first;
    final String cacheKey = '${AppConstants.historicalRatesDBKey}_$pairKey';
    
    // Get existing historical data or initialize new map
    final existingData = _box.get(cacheKey);
    Map<String, dynamic> historicalData = existingData != null
        ? Map<String, dynamic>.from(jsonDecode(existingData))
        : {};

    // Merge new data with existing data
    historicalData.addAll(data);

    // Store updated data
    var dataInJSON = jsonEncode(historicalData);
    _box.put(cacheKey, dataInJSON);
  }

  // Helper method to filter historical data
  Map<String, dynamic> _filterHistoricalData(
      Map<String, dynamic> historicalData, ConvertRateModel data) {
    // Filter data based on date range only since we're already using currency-specific cache
    final filteredData = <String, dynamic>{
      'results': {},
      'query': historicalData['query'] ?? {}
    };

    final results = historicalData['results'] as Map<String, dynamic>;
    results.forEach((key, value) {
      if (_isDateInRange(key, data.from, data.to)) {
        filteredData['results'][key] = value;
      }
    });

    return filteredData;
  }

  bool _isDateInRange(String key, DateTime? from, DateTime? to) {
    try {
      final datePart = key.split('_').last;
      if (!datePart.contains('-')) return true; // If no date in key, include it
      
      final date = DateTime.parse(datePart);

      // If no date range is specified, return true
      if (from == null && to == null) return true;

      // Check if date is within the specified range
      return (from == null ||
              date.isAtSameMomentAs(from) ||
              date.isAfter(from)) &&
          (to == null || date.isAtSameMomentAs(to) || date.isBefore(to));
    } catch (e) {
      // If date parsing fails, return false
      return false;
    }
  }
}
