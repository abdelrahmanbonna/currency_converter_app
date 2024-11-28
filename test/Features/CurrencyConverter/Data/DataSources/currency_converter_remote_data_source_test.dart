import 'package:currency_converter_app/Core/Config/end_points_paths.dart';
import 'package:currency_converter_app/Core/Services/network_service.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Data/DataSources/currency_converter_remote_data_source.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Data/Models/convert_rate_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNetworkService extends Mock implements NetworkService {}

class MockDio extends Mock implements Dio {}

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

  group('CurrencyConverterRemoteDataSource', () {
    test('getCurrencyConvert makes correct API request', () async {
      // arrange
      final model = ConvertRateModel(
        baseCurrency: 'USD',
        convertCurrency: 'EUR',
      );

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

      // act
      await dataSource.getCurrencyConvert(model);

      // assert
      verify(mockDio.get(
        EndPointsPaths.convertEndPoint,
        queryParameters: {
          'q': 'USD_EUR',
          EndPointsPaths.apiKeyParamName: EndPointsPaths.apiKey,
        },
      ));
    });

    test('getHistoricalData makes correct API request', () async {
      // arrange
      final model = ConvertRateModel(
        baseCurrency: 'USD',
        convertCurrency: 'EUR',
        from: DateTime(2024, 1, 1),
        to: DateTime(2024, 1, 7),
      );

      when(mockDio.get(
        EndPointsPaths.historicalDataEndPoint,
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

      // act
      await dataSource.getHistoricalData(model);

      // assert
      verify(mockDio.get(
        EndPointsPaths.historicalDataEndPoint,
        queryParameters: {
          'q': 'USD_EUR',
          'date_from': '2024-1-1',
          'date_to': '2024-1-7',
          EndPointsPaths.apiKeyParamName: EndPointsPaths.apiKey,
        },
      ));
    });

    test('getCurrencies makes correct API request', () async {
      // arrange
      when(mockDio.get(
        EndPointsPaths.currenciesEndPoint,
        queryParameters: anyNamed('queryParameters'),
      )).thenAnswer((_) async => Response(
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
              }
            },
          ));

      // act
      await dataSource.getCurrencies();

      // assert
      verify(mockDio.get(
        EndPointsPaths.currenciesEndPoint,
        queryParameters: {
          'currencies': '',
          EndPointsPaths.apiKeyParamName: EndPointsPaths.apiKey,
        },
      ));
    });
  });
}
