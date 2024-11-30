import 'package:currency_converter_app/Core/Config/end_points_paths.dart';
import 'package:currency_converter_app/Core/Services/network_service.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Data/DataSources/currency_converter_remote_data_source.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Data/Models/convert_rate_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<NetworkService>(), MockSpec<Dio>()])
import 'currency_converter_remote_data_source_test.mocks.dart';

void main() {
  late CurrencyConverterRemoteDataSource dataSource;
  late MockNetworkService mockNetworkService;
  late MockDio mockDio;

  setUp(() {
    mockNetworkService = MockNetworkService();
    mockDio = MockDio();
    when(mockNetworkService.unAuthedDio).thenReturn(mockDio);
    dataSource = CurrencyConverterRemoteDataSource(mockNetworkService);
  });

  group('getCurrencyConvert', () {
    const testModel = ConvertRateModel(
      baseCurrency: 'USD',
      convertCurrency: 'EUR',
      amount: 100,
    );

    test('makes correct API request', () async {
      // Arrange
      when(mockDio.get(
        EndPointsPaths.convertEndPoint,
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 200,
            data: {
              'query': {'count': 1},
              'results': {
                'USD_EUR': {
                  'id': 'USD_EUR',
                  'val': 0.947355,
                  'to': 'EUR',
                  'fr': 'USD'
                }
              }
            },
          ));

      // Act
      final result = await dataSource.getCurrencyConvert(testModel);

      // Assert
      verify(mockDio.get(
        EndPointsPaths.convertEndPoint,
        queryParameters: {
          'q': '${testModel.baseCurrency}_${testModel.convertCurrency}',
        },
      ));
      expect(result.statusCode, 200);
      expect(result.data['results']['USD_EUR']['val'], 0.947355);
    });

    test('throws exception when API call fails', () async {
      // Arrange
      when(mockDio.get(
        EndPointsPaths.convertEndPoint,
        queryParameters: anyNamed('queryParameters'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        error: 'Network error',
      ));

      // Act & Assert
      expect(
        () => dataSource.getCurrencyConvert(testModel),
        throwsA(isA<DioException>()),
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

    test('makes correct API request with date range', () async {
      // Arrange
      when(mockDio.get(
        EndPointsPaths.convertEndPoint,
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 200,
            data: {
              'USD_EUR': {
                '2024-01-01': 0.947355,
                '2024-01-07': 0.948123,
              }
            },
          ));

      // Act
      final result = await dataSource.getHistoricalData(testModel);

      // Assert
      verify(mockDio.get(
        EndPointsPaths.convertEndPoint,
        queryParameters: {
          'q': '${testModel.baseCurrency}_${testModel.convertCurrency}',
          'date': '2024-01-01',
          'endDate': '2024-01-07',
          'compact': 'ultra',
        },
      ));
      expect(result.statusCode, 200);
      expect(result.data['USD_EUR']['2024-01-01'], 0.947355);
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
    test('makes correct API request', () async {
      // Arrange
      when(mockDio.get(
        EndPointsPaths.currenciesEndPoint,
        queryParameters: {
          'currencies': '',
          'apiKey': EndPointsPaths.apiKey,
        },
      )).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 200,
            data: {
              'results': {
                'USD': {'currencyName': 'US Dollar', 'currencySymbol': '\$'},
                'EUR': {'currencyName': 'Euro', 'currencySymbol': '€'},
              }
            },
          ));

      // Act
      final result = await dataSource.getCurrencies();

      // Assert
      verify(mockDio.get(
        EndPointsPaths.currenciesEndPoint,
        queryParameters: {
          'currencies': '',
          'apiKey': EndPointsPaths.apiKey,
        },
      ));
      expect(result.statusCode, 200);
      expect(result.data['results']['USD']['currencyName'], 'US Dollar');
    });

    test('throws exception when API call fails', () async {
      // Arrange
      when(mockDio.get(
        EndPointsPaths.currenciesEndPoint,
        queryParameters: anyNamed('queryParameters'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        error: 'Network error',
      ));

      // Act & Assert
      expect(
        () => dataSource.getCurrencies(),
        throwsA(isA<DioException>()),
      );
    });
  });
}
