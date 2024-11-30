import 'dart:convert';

import 'package:currency_converter_app/Core/Config/app_constants.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Data/DataSources/currency_converter_cache_data_source.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Data/Models/convert_rate_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:intl/intl.dart';

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
    const testModel = ConvertRateModel(
      baseCurrency: 'USD',
      convertCurrency: 'EUR',
      amount: 100,
    );

    final cacheKey = '${AppConstants.exchangeRatesDBKey}_${testModel.baseCurrency}_${testModel.convertCurrency}';
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

    test('returns cached data when available', () async {
      // Arrange
      when(mockBox.get(cacheKey)).thenReturn(jsonEncode(mockData));

      // Act
      final result = await dataSource.getCurrencyConvert(testModel);

      // Assert
      verify(mockBox.get(cacheKey));
      expect(result.statusCode, 200);
      expect(result.data, mockData);
    });

    test('returns 404 when cache is empty', () async {
      // Arrange
      when(mockBox.get(cacheKey)).thenReturn(null);

      // Act
      final result = await dataSource.getCurrencyConvert(testModel);

      // Assert
      verify(mockBox.get(cacheKey));
      expect(result.statusCode, 404);
      expect(result.data, {'msg': 'Data not found'});
    });

    test('handles invalid cache data gracefully', () async {
      // Arrange
      when(mockBox.get(cacheKey)).thenReturn('invalid json');

      // Act & Assert
      expect(
        () => dataSource.getCurrencyConvert(testModel),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('getHistoricalData', () {
    final testModel = ConvertRateModel(
      baseCurrency: 'USD',
      convertCurrency: 'EUR',
      amount: 100,
      from: DateTime(2024, 1, 1),
      to: DateTime(2024, 1, 7),
    );

    final dateFormat = DateFormat('yyyy-MM-dd');
    final cacheKey = '${AppConstants.historicalRatesDBKey}_${testModel.baseCurrency}_${testModel.convertCurrency}_${dateFormat.format(testModel.from!)}_${dateFormat.format(testModel.to!)}';
    final mockData = {
      'USD_EUR': {
        '2024-01-01': 0.947355,
        '2024-01-07': 0.948123,
      }
    };

    test('returns cached historical data when available', () async {
      // Arrange
      when(mockBox.get(cacheKey)).thenReturn(jsonEncode(mockData));

      // Act
      final result = await dataSource.getHistoricalData(testModel);

      // Assert
      verify(mockBox.get(cacheKey));
      expect(result.statusCode, 200);
      expect(result.data, mockData);
    });

    test('returns 404 when historical cache is empty', () async {
      // Arrange
      when(mockBox.get(cacheKey)).thenReturn(null);

      // Act
      final result = await dataSource.getHistoricalData(testModel);

      // Assert
      verify(mockBox.get(cacheKey));
      expect(result.statusCode, 404);
      expect(result.data, {'msg': 'Data not found'});
    });

    test('throws ArgumentError when dates are missing', () async {
      // Arrange
      const invalidModel = ConvertRateModel(
        baseCurrency: 'USD',
        convertCurrency: 'EUR',
        amount: 100,
      );

      // Act & Assert
      expect(
        () => dataSource.getHistoricalData(invalidModel),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('getCurrencies', () {
    const cacheKey = AppConstants.currencyDBKey;
    final mockData = {
      'results': {
        'USD': {'currencyName': 'US Dollar', 'currencySymbol': '\$'},
        'EUR': {'currencyName': 'Euro', 'currencySymbol': '€'},
      }
    };

    test('returns cached currencies when available', () async {
      // Arrange
      when(mockBox.get(cacheKey)).thenReturn(jsonEncode(mockData));

      // Act
      final result = await dataSource.getCurrencies();

      // Assert
      verify(mockBox.get(cacheKey));
      expect(result.statusCode, 200);
      expect(result.data, mockData);
    });

    test('returns 404 when currencies cache is empty', () async {
      // Arrange
      when(mockBox.get(cacheKey)).thenReturn(null);

      // Act
      final result = await dataSource.getCurrencies();

      // Assert
      verify(mockBox.get(cacheKey));
      expect(result.statusCode, 404);
      expect(result.data, {'msg': 'Data not found'});
    });
  });

  group('setCurrencyData', () {
    test('stores currency data with correct cache key', () async {
      // Arrange
      final mockData = {
        'results': {
          'USD': {'currencyName': 'US Dollar', 'currencySymbol': '\$'},
          'EUR': {'currencyName': 'Euro', 'currencySymbol': '€'},
        }
      };

      // Act
      await dataSource.setCurrencyData(mockData);

      // Assert
      verify(mockBox.put(AppConstants.currencyDBKey, jsonEncode(mockData)));
    });
  });

  group('setCurrencyConvertData', () {
    test('stores conversion data with correct cache key', () async {
      // Arrange
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

      // Act
      await dataSource.setCurrencyConvertData(mockData);

      // Assert
      verify(mockBox.put(
        '${AppConstants.exchangeRatesDBKey}_USD_EUR',
        jsonEncode(mockData),
      ));
    });
  });

  group('setHistoricalData', () {
    test('stores historical data with correct cache key', () async {
      // Arrange
      final testModel = ConvertRateModel(
        baseCurrency: 'USD',
        convertCurrency: 'EUR',
        from: DateTime(2024, 1, 1),
        to: DateTime(2024, 1, 7),
      );

      final mockData = {
        'USD_EUR': {
          '2024-01-01': 0.947355,
          '2024-01-07': 0.948123,
        }
      };

      final dateFormat = DateFormat('yyyy-MM-dd');
      final expectedCacheKey = '${AppConstants.historicalRatesDBKey}_${testModel.baseCurrency}_${testModel.convertCurrency}_${dateFormat.format(testModel.from!)}_${dateFormat.format(testModel.to!)}';

      // Act
      await dataSource.setHistoricalData(mockData, testModel);

      // Assert
      verify(mockBox.put(expectedCacheKey, jsonEncode(mockData)));
    });
  });
}
