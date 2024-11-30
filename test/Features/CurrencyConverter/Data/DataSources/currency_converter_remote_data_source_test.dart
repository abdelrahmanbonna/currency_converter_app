import 'package:currency_converter_app/Core/Config/end_points_paths.dart';
import 'package:currency_converter_app/Core/Services/network_service.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Data/DataSources/currency_converter_remote_data_source.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Data/Models/convert_rate_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:intl/intl.dart';

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
    test('makes correct API request', () async {
      // arrange
      const model = ConvertRateModel(
        baseCurrency: 'USD',
        convertCurrency: 'EUR',
        amount: 100,
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
      final result = await dataSource.getCurrencyConvert(model);

      // assert
      verify(mockDio.get(
        EndPointsPaths.convertEndPoint,
        queryParameters: {
          'q': 'USD_EUR',
        },
      ));

      expect(result.statusCode, 200);
      expect(result.data['results']['USD_EUR']['val'], 0.947355);
    });

    test('throws error on API failure', () async {
      // arrange
      const model = ConvertRateModel(
        baseCurrency: 'USD',
        convertCurrency: 'EUR',
        amount: 100,
      );

      when(mockDio.get(
        EndPointsPaths.convertEndPoint,
        queryParameters: anyNamed('queryParameters'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        error: 'Network error',
      ));

      // act & assert
      expect(() => dataSource.getCurrencyConvert(model),
          throwsA(isA<DioException>()));
    });
  });

  group('getHistoricalData', () {
    test('makes correct API request with date range', () async {
      // arrange
      final model = ConvertRateModel(
        baseCurrency: 'USD',
        convertCurrency: 'EUR',
        from: DateTime(2024, 1, 1),
        to: DateTime(2024, 1, 7),
      );

      final dateFormat = DateFormat('yyyy-MM-dd');

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
      final result = await dataSource.getHistoricalData(model);

      // assert
      verify(mockDio.get(
        EndPointsPaths.convertEndPoint,
        queryParameters: {
          'q': 'USD_EUR',
          'date': dateFormat.format(model.from!),
          'endDate': dateFormat.format(model.to!),
          'compact': 'ultra',
        },
      ));

      expect(result.statusCode, 200);
      expect(result.data['results']['USD_EUR']['val'], 0.947355);
    });

    test('throws error when dates are missing', () async {
      // arrange
      const model = ConvertRateModel(
        baseCurrency: 'USD',
        convertCurrency: 'EUR',
      );

      // act & assert
      expect(
          () => dataSource.getHistoricalData(model),
          throwsA(isA<ArgumentError>().having((e) => e.message, 'message',
              'From and To dates are required for historical data')));
    });

    test('throws error on historical data API failure', () async {
      // arrange
      final model = ConvertRateModel(
        baseCurrency: 'USD',
        convertCurrency: 'EUR',
        from: DateTime(2024, 1, 1),
        to: DateTime(2024, 1, 7),
      );

      when(mockDio.get(
        EndPointsPaths.convertEndPoint,
        queryParameters: anyNamed('queryParameters'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        error: 'Network error',
      ));

      // act & assert
      expect(() => dataSource.getHistoricalData(model),
          throwsA(isA<DioException>()));
    });
  });
}
