import 'dart:convert';

import 'package:currency_converter_app/Core/Config/app_constants.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Data/DataSources/currency_converter_cache_data_source.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Data/Models/convert_rate_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<Box>()])
import 'currency_converter_cache_data_source_test.mocks.dart';

void main() {
  late CurrencyConverterCacheDataSource dataSource;
  late MockBox mockBox;

  setUp(() {
    mockBox = MockBox();
    dataSource = CurrencyConverterCacheDataSource(mockBox);
  });

  group('getCurrencyConvert', () {
    final model = ConvertRateModel(
      baseCurrency: 'USD',
      convertCurrency: 'EUR',
      amount: 100,
      from: DateTime(2024, 1, 1),
      to: DateTime(2024, 1, 7),
    );

    test('returns cached data when available', () async {
      final cacheKey = '${AppConstants.exchangeRatesDBKey}_${model.baseCurrency}_${model.convertCurrency}';
      final mockData = {
        'results': {
          'USD_EUR': {
            'id': 'USD_EUR',
            'val': 0.947355,
            'to': 'EUR',
            'fr': 'USD'
          }
        }
      };

      when(mockBox.get(cacheKey)).thenReturn(jsonEncode(mockData));

      final result = await dataSource.getCurrencyConvert(model);

      expect(result.statusCode, 200);
      expect(result.data, mockData);
    });

    test('returns 404 when cache is empty', () async {
      final cacheKey = '${AppConstants.exchangeRatesDBKey}_${model.baseCurrency}_${model.convertCurrency}';
      when(mockBox.get(cacheKey)).thenReturn(null);

      final result = await dataSource.getCurrencyConvert(model);

      expect(result.statusCode, 404);
      expect(result.data, {'msg': 'Data not found'});
    });
  });

  group('setCurrencyConvertData', () {
    test('stores data with correct cache key', () async {
      final mockData = {
        'results': {
          'USD_EUR': {
            'id': 'USD_EUR',
            'val': 0.947355,
            'to': 'EUR',
            'fr': 'USD'
          }
        }
      };

      const expectedCacheKey = '${AppConstants.exchangeRatesDBKey}_USD_EUR';

      await dataSource.setCurrencyConvertData(mockData);

      verify(mockBox.put(expectedCacheKey, jsonEncode(mockData))).called(1);
    });
  });

  group('getHistoricalData', () {
    final model = ConvertRateModel(
      baseCurrency: 'USD',
      convertCurrency: 'EUR',
      from: DateTime(2024, 1, 1),
      to: DateTime(2024, 1, 7),
    );

    test('returns filtered historical data when available', () async {
      final cacheKey = '${AppConstants.historicalRatesDBKey}_${model.baseCurrency}_${model.convertCurrency}';
      final mockData = {
        'results': {
          'USD_EUR_2024-01-01': {'val': 0.91},
          'USD_EUR_2024-01-02': {'val': 0.92},
          'USD_EUR_2024-01-08': {'val': 0.93}, // Outside date range
        },
        'query': {'count': 3}
      };

      when(mockBox.get(cacheKey)).thenReturn(jsonEncode(mockData));

      final result = await dataSource.getHistoricalData(model);

      expect(result.statusCode, 200);
      expect(result.data['results'].length, 2);
      expect(result.data['results'].containsKey('USD_EUR_2024-01-08'), false);
    });

    test('returns 404 when historical cache is empty', () async {
      final cacheKey = '${AppConstants.historicalRatesDBKey}_${model.baseCurrency}_${model.convertCurrency}';
      when(mockBox.get(cacheKey)).thenReturn(null);

      final result = await dataSource.getHistoricalData(model);

      expect(result.statusCode, 404);
      expect(result.data, {'msg': 'Data not found'});
    });
  });

  group('setHistoricalData', () {
    test('merges and stores historical data with correct cache key', () async {
      final existingData = {
        'results': {
          'USD_EUR_2024-01-01': {'val': 0.91},
        },
        'query': {'count': 1}
      };

      final newData = {
        'results': {
          'USD_EUR_2024-01-02': {'val': 0.92},
        },
        'query': {'count': 1}
      };

      const cacheKey = '${AppConstants.historicalRatesDBKey}_USD_EUR';
      
      when(mockBox.get(cacheKey)).thenReturn(jsonEncode(existingData));

      await dataSource.setHistoricalData(newData);

      verify(mockBox.put(
        cacheKey,
        any,
      )).called(1);
    });
  });
}
