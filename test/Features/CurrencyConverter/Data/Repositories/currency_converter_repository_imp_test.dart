import 'package:currency_converter_app/Core/Errors/failures.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Data/DataSources/currency_converter_cache_data_source.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Data/DataSources/currency_converter_remote_data_source.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Data/Repositories/currency_converter_repository_imp.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Domain/Entities/convert_rate_entity.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([
  MockSpec<CurrencyConverterRemoteDataSource>(),
  MockSpec<CurrencyConverterCacheDataSource>()
])
import 'currency_converter_repository_imp_test.mocks.dart';

void main() {
  late MockCurrencyConverterRemoteDataSource mockRemoteDataSource;
  late MockCurrencyConverterCacheDataSource mockCacheDataSource;
  late CurrencyConverterRepositoryImp repository;

  setUp(() {
    mockRemoteDataSource = MockCurrencyConverterRemoteDataSource();
    mockCacheDataSource = MockCurrencyConverterCacheDataSource();
    repository = CurrencyConverterRepositoryImp(
      mockRemoteDataSource,
      mockCacheDataSource,
    );
  });

  const testBaseCurrency = 'USD';
  const testConvertCurrency = 'EUR';
  const testRate = 0.85;
  const testAmount = 100.0;
  final testFromDate = DateTime(2023, 1, 1);
  final testToDate = DateTime(2023, 12, 31);

  group('getConvertRates', () {
    const testEntity = ConvertRateEntity(
      baseCurrency: testBaseCurrency,
      convertCurrency: testConvertCurrency,
      amount: testAmount,
      rate: testRate,
    );

    test('should return conversion rate when remote data source succeeds', () async {
      // Arrange
      final successResponse = Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 200,
        data: {
          'results': {
            'USD_EUR': {
              'val': testRate,
              'to': testConvertCurrency,
              'fr': testBaseCurrency,
            },
          },
        },
      );

      when(mockRemoteDataSource.getCurrencyConvert(any))
          .thenAnswer((_) async => successResponse);
      when(mockCacheDataSource.setCurrencyConvertData(any))
          .thenAnswer((_) async => {});

      // Act
      final result = await repository.getConvertRates(testEntity);

      // Assert
      expect(result.isValue, true);
      final value = result.asValue!.value;
      expect(value.baseCurrency, equals(testBaseCurrency));
      expect(value.convertCurrency, equals(testConvertCurrency));
      expect(value.rate, equals(testRate));
      verify(mockRemoteDataSource.getCurrencyConvert(any));
      verify(mockCacheDataSource.setCurrencyConvertData(any));
    });

    test('should return cached data when remote data source fails and cache is available',
        () async {
      // Arrange
      final errorResponse = Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 404,
      );

      final cacheResponse = Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 200,
        data: {
          'results': {
            'USD_EUR': {
              'val': testRate,
              'to': testConvertCurrency,
              'fr': testBaseCurrency,
            },
          },
        },
      );

      when(mockRemoteDataSource.getCurrencyConvert(any))
          .thenAnswer((_) async => errorResponse);
      when(mockCacheDataSource.getCurrencyConvert(any))
          .thenAnswer((_) async => cacheResponse);

      // Act
      final result = await repository.getConvertRates(testEntity);

      // Assert
      expect(result.isValue, true);
      final value = result.asValue!.value;
      expect(value.baseCurrency, equals(testBaseCurrency));
      expect(value.convertCurrency, equals(testConvertCurrency));
      expect(value.rate, equals(testRate));
      verify(mockRemoteDataSource.getCurrencyConvert(any));
      verify(mockCacheDataSource.getCurrencyConvert(any));
    });

    test('should return failure when both remote and cache sources fail', () async {
      // Arrange
      final errorResponse = Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 404,
      );

      when(mockRemoteDataSource.getCurrencyConvert(any))
          .thenAnswer((_) async => errorResponse);
      when(mockCacheDataSource.getCurrencyConvert(any))
          .thenAnswer((_) async => errorResponse);

      // Act
      final result = await repository.getConvertRates(testEntity);

      // Assert
      expect(result.isError, true);
      expect(result.asError!.error, isA<ServerFailure>());
    });

    test('should handle exceptions from remote data source', () async {
      // Arrange
      when(mockRemoteDataSource.getCurrencyConvert(any))
          .thenThrow(Exception('Network error'));
      when(mockCacheDataSource.getCurrencyConvert(any))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: ''),
                statusCode: 404,
              ));

      // Act
      final result = await repository.getConvertRates(testEntity);

      // Assert
      expect(result.isError, true);
      expect(result.asError!.error, isA<ServerFailure>());
      verify(mockRemoteDataSource.getCurrencyConvert(any));
      verify(mockCacheDataSource.getCurrencyConvert(any));
    });
  });

  group('getHistoricalRates', () {
    final testEntity = ConvertRateEntity(
      baseCurrency: testBaseCurrency,
      convertCurrency: testConvertCurrency,
      from: testFromDate,
      to: testToDate,
    );

    test('should return historical rates when remote data source succeeds', () async {
      // Arrange
      final successResponse = Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 200,
        data: {
          'USD_EUR': {
            '2023-01-01': 0.85,
            '2023-01-02': 0.86,
            '2023-01-03': 0.84,
          },
        },
      );

      when(mockRemoteDataSource.getHistoricalData(any))
          .thenAnswer((_) async => successResponse);

      // Act
      final result = await repository.getHistoricalRates(testEntity);

      // Assert
      expect(result.isValue, true);
      final rates = result.asValue!.value;
      expect(rates.length, equals(3));
      expect(rates[0].rate, equals(0.85));
      expect(rates[0].from, equals(DateTime(2023, 1, 1)));
      verify(mockRemoteDataSource.getHistoricalData(any));
    });

    test('should return failure when no historical data is found', () async {
      // Arrange
      final errorResponse = Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 200,
        data: {},
      );

      when(mockRemoteDataSource.getHistoricalData(any))
          .thenAnswer((_) async => errorResponse);

      // Act
      final result = await repository.getHistoricalRates(testEntity);

      // Assert
      expect(result.isError, true);
      expect(result.asError!.error, isA<ServerFailure>());
      verify(mockRemoteDataSource.getHistoricalData(any));
    });

    test('should handle invalid date formats in historical data', () async {
      // Arrange
      final invalidResponse = Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 200,
        data: {
          'USD_EUR': {
            'invalid_date': 0.85,
            '2023-01-02': 0.86,
          },
        },
      );

      when(mockRemoteDataSource.getHistoricalData(any))
          .thenAnswer((_) async => invalidResponse);

      // Act
      final result = await repository.getHistoricalRates(testEntity);

      // Assert
      expect(result.isValue, true);
      final rates = result.asValue!.value;
      expect(rates.length, equals(1));
      expect(rates[0].rate, equals(0.86));
      verify(mockRemoteDataSource.getHistoricalData(any));
    });
  });

  group('getCurrencies', () {
    test('should return list of currencies when remote data source succeeds', () async {
      // Arrange
      final successResponse = Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 200,
        data: {
          'results': {
            'USD': {
              'currencyName': 'US Dollar',
              'currencySymbol': '\$',
            },
            'EUR': {
              'currencyName': 'Euro',
              'currencySymbol': '€',
            },
          },
        },
      );

      when(mockRemoteDataSource.getCurrencies())
          .thenAnswer((_) async => successResponse);

      // Act
      final result = await repository.getCurrencies();

      // Assert
      expect(result.isValue, true);
      final currencies = result.asValue!.value;
      expect(currencies.length, equals(2));
      expect(currencies[0].code, equals('USD'));
      expect(currencies[0].name, equals('US Dollar'));
      expect(currencies[0].symbol, equals('\$'));
      verify(mockRemoteDataSource.getCurrencies());
    });

    test('should handle missing currency properties', () async {
      // Arrange
      final response = Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 200,
        data: {
          'results': {
            'USD': {
              'currencyName': 'US Dollar',
              // Missing symbol
            },
            'EUR': {
              // Missing name and symbol
            },
          },
        },
      );

      when(mockRemoteDataSource.getCurrencies())
          .thenAnswer((_) async => response);

      // Act
      final result = await repository.getCurrencies();

      // Assert
      expect(result.isValue, true);
      final currencies = result.asValue!.value;
      expect(currencies.length, equals(2));
      expect(currencies[0].symbol, equals(''));
      expect(currencies[1].name, equals(''));
      expect(currencies[1].symbol, equals(''));
      verify(mockRemoteDataSource.getCurrencies());
    });

    test('should return failure when remote data source fails', () async {
      // Arrange
      final errorResponse = Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 404,
      );

      when(mockRemoteDataSource.getCurrencies())
          .thenAnswer((_) async => errorResponse);

      // Act
      final result = await repository.getCurrencies();

      // Assert
      expect(result.isError, true);
      expect(result.asError!.error, isA<ServerFailure>());
      verify(mockRemoteDataSource.getCurrencies());
    });

    test('should handle exceptions', () async {
      // Arrange
      when(mockRemoteDataSource.getCurrencies())
          .thenThrow(Exception('Network error'));

      // Act
      final result = await repository.getCurrencies();

      // Assert
      expect(result.isError, true);
      expect(result.asError!.error, isA<ServerFailure>());
      verify(mockRemoteDataSource.getCurrencies());
    });
  });
}
