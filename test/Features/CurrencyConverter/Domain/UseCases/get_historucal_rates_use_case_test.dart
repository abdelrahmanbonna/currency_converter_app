import 'package:async/async.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Domain/Entities/convert_rate_entity.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Domain/Repositories/currency_converter_repository.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Domain/UseCases/get_historucal_rates_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_historucal_rates_use_case_test.mocks.dart';

@GenerateMocks([CurrencyConverterRepository])
void main() {
  late GetHistorucalRatesUseCase useCase;
  late MockCurrencyConverterRepository mockRepository;

  setUp(() {
    mockRepository = MockCurrencyConverterRepository();
    useCase = GetHistorucalRatesUseCase(mockRepository);
  });

  final now = DateTime.now();
  const tConvertRateEntity = ConvertRateEntity(
    baseCurrency: 'USD',
    convertCurrency: 'EUR',
    rate: 0.85,
  );

  final tHistoricalRates = [
    ConvertRateEntity(
      baseCurrency: 'USD',
      convertCurrency: 'EUR',
      rate: 0.85,
      from: now.subtract(const Duration(days: 7)),
      to: now.subtract(const Duration(days: 6)),
    ),
    ConvertRateEntity(
      baseCurrency: 'USD',
      convertCurrency: 'EUR',
      rate: 0.86,
      from: now.subtract(const Duration(days: 6)),
      to: now.subtract(const Duration(days: 5)),
    ),
    ConvertRateEntity(
      baseCurrency: 'USD',
      convertCurrency: 'EUR',
      rate: 0.84,
      from: now.subtract(const Duration(days: 5)),
      to: now.subtract(const Duration(days: 4)),
    ),
  ];

  test('should get historical rates from repository', () async {
    // arrange
    when(mockRepository.getHistoricalRates(any))
        .thenAnswer((_) async => Result.value(tHistoricalRates));

    // act
    final result = await useCase(tConvertRateEntity);

    // assert
    expect(result.isValue, true);
    expect(result.asValue!.value, tHistoricalRates);
    verify(mockRepository.getHistoricalRates(tConvertRateEntity));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return empty list when repository returns empty', () async {
    // arrange
    when(mockRepository.getHistoricalRates(any))
        .thenAnswer((_) async => Result.value([]));

    // act
    final result = await useCase(tConvertRateEntity);

    // assert
    expect(result.isValue, true);
    expect(result.asValue!.value, isEmpty);
    verify(mockRepository.getHistoricalRates(tConvertRateEntity));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return error when repository fails', () async {
    // arrange
    final tError = Exception('Failed to get historical rates');
    when(mockRepository.getHistoricalRates(any))
        .thenAnswer((_) async => Result.error(tError));

    // act
    final result = await useCase(tConvertRateEntity);

    // assert
    expect(result.isError, true);
    expect(result.asError!.error, tError);
    verify(mockRepository.getHistoricalRates(tConvertRateEntity));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should handle different date ranges correctly', () async {
    // arrange
    final customDateRange = ConvertRateEntity(
      baseCurrency: 'USD',
      convertCurrency: 'EUR',
      from: now.subtract(const Duration(days: 30)),
      to: now,
    );

    when(mockRepository.getHistoricalRates(any))
        .thenAnswer((_) async => Result.value(tHistoricalRates));

    // act
    final result = await useCase(customDateRange);

    // assert
    expect(result.isValue, true);
    verify(mockRepository.getHistoricalRates(customDateRange));
    verifyNoMoreInteractions(mockRepository);
  });
}
