import 'package:currency_converter_app/Core/Config/end_points_paths.dart';
import 'package:currency_converter_app/Core/Services/network_service.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Data/DataSources/currency_converter_remote_data_source.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Data/Models/convert_rate_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'currency_converter_remote_data_source_test.mocks.dart';

@GenerateMocks([NetworkService, Dio])
void main() {
  late MockNetworkService mockNetworkService;
  late CurrencyConverterRemoteDataSource dataSource;
  late MockDio mockDio;

  setUp(() {
    mockNetworkService = MockNetworkService();
    mockDio = MockDio();
    when(mockNetworkService.unAuthedDio).thenReturn(mockDio);
    dataSource = CurrencyConverterRemoteDataSource(mockNetworkService);
  });

  group('getCurrencyConvert', () {
    final tConvertRateModel = ConvertRateModel(
      baseCurrency: 'USD',
      convertCurrency: 'EUR',
    );

    test('should perform a GET request with proper parameters', () async {
      // arrange
      when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: ''),
                statusCode: 200,
                data: {'USD_EUR': 0.85},
              ));

      // act
      await dataSource.getCurrencyConvert(tConvertRateModel);

      // assert
      verify(mockDio.get(
        EndPointsPaths.convertEndPoint,
        queryParameters: {
          'base_currency': 'USD',
          'currencies': 'EUR',
        },
      ));
    });

    test('should throw exception when the response is not successful', () async {
      // arrange
      when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 400,
          data: {'error': 'Bad Request'},
        ),
      ));

      // act & assert
      expect(
        () => dataSource.getCurrencyConvert(tConvertRateModel),
        throwsA(isA<DioException>()),
      );
    });
  });

  group('getHistoricalData', () {
    final tConvertRateModel = ConvertRateModel(
      baseCurrency: 'USD',
      convertCurrency: 'EUR',
      from: DateTime(2024, 1, 1),
      to: DateTime(2024, 1, 7),
    );

    test('should perform a GET request with proper parameters including dates',
        () async {
      // arrange
      when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: ''),
                statusCode: 200,
                data: {'2024-01-01': {'USD_EUR': 0.85}},
              ));

      // act
      await dataSource.getHistoricalData(tConvertRateModel);

      // assert
      verify(mockDio.get(
        EndPointsPaths.historicalDataEndPoint,
        queryParameters: {
          'base_currency': 'USD',
          'currencies': 'EUR',
          'date_from': '2024-1-1',
          'date_to': '2024-1-7',
        },
      ));
    });
  });

  group('getCurrencies', () {
    test('should perform a GET request to fetch available currencies', () async {
      // arrange
      when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: ''),
                statusCode: 200,
                data: {
                  'currencies': {'USD': 'US Dollar', 'EUR': 'Euro'}
                },
              ));

      // act
      await dataSource.getCurrencies();

      // assert
      verify(mockDio.get(
        EndPointsPaths.currenciesEndPoint,
        queryParameters: {'currencies': ''},
      ));
    });
  });
}
