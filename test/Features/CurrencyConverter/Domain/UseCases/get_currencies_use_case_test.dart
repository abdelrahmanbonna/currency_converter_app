import 'package:async/async.dart';
import 'package:currency_converter_app/Core/UseCases/usecase.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Domain/Entities/currency_entity.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Domain/Repositories/currency_converter_repository.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Domain/UseCases/get_currencies_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_currencies_use_case_test.mocks.dart';

@GenerateMocks([CurrencyConverterRepository])
void main() {
  late GetCurrenciesUseCase useCase;
  late MockCurrencyConverterRepository mockRepository;

  setUp(() {
    mockRepository = MockCurrencyConverterRepository();
    useCase = GetCurrenciesUseCase(mockRepository);
  });

  final tCurrencies = [
    const CurrencyEntity(
      symbol: '\$',
      name: 'US Dollar',
      symbolNative: '\$',
      decimalDigits: 2,
      rounding: 0,
      code: 'USD',
      namePlural: 'US dollars',
      type: 'fiat',
    ),
    const CurrencyEntity(
      symbol: '€',
      name: 'Euro',
      symbolNative: '€',
      decimalDigits: 2,
      rounding: 0,
      code: 'EUR',
      namePlural: 'euros',
      type: 'fiat',
    ),
  ];

  test('should get currencies list from repository', () async {
    // arrange
    when(mockRepository.getCurrencies())
        .thenAnswer((_) async => Result.value(tCurrencies));

    // act
    final result = await useCase(NoParams());

    // assert
    expect(result.isValue, true);
    expect(result.asValue!.value, tCurrencies);
    verify(mockRepository.getCurrencies());
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return empty list when repository returns empty', () async {
    // arrange
    when(mockRepository.getCurrencies())
        .thenAnswer((_) async => Result.value([]));

    // act
    final result = await useCase(NoParams());

    // assert
    expect(result.isValue, true);
    expect(result.asValue!.value, isEmpty);
    verify(mockRepository.getCurrencies());
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return error when repository fails', () async {
    // arrange
    final tError = Exception('Failed to get currencies');
    when(mockRepository.getCurrencies())
        .thenAnswer((_) async => Result.error(tError));

    // act
    final result = await useCase(NoParams());

    // assert
    expect(result.isError, true);
    expect(result.asError!.error, tError);
    verify(mockRepository.getCurrencies());
    verifyNoMoreInteractions(mockRepository);
  });
}
