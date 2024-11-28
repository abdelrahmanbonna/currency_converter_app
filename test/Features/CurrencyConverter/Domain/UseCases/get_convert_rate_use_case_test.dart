import 'package:async/async.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Domain/Entities/convert_rate_entity.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Domain/Repositories/currency_converter_repository.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Domain/UseCases/get_convert_rate_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_convert_rate_use_case_test.mocks.dart';

@GenerateMocks([CurrencyConverterRepository])
void main() {
  late GetConvertRateUseCase useCase;
  late MockCurrencyConverterRepository mockRepository;

  setUp(() {
    mockRepository = MockCurrencyConverterRepository();
    useCase = GetConvertRateUseCase(mockRepository);
  });

  const tConvertRateEntity = ConvertRateEntity(
    baseCurrency: 'USD',
    convertCurrency: 'EUR',
    rate: 0.85,
  );

  test('should get conversion rate from repository', () async {
    // arrange
    when(mockRepository.getConvertRates(any))
        .thenAnswer((_) async => Result.value(tConvertRateEntity));

    // act
    final result = await useCase(tConvertRateEntity);

    // assert
    expect(result.isValue, true);
    expect(result.asValue!.value, tConvertRateEntity);
    verify(mockRepository.getConvertRates(tConvertRateEntity));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return error when repository fails', () async {
    // arrange
    final tError = Exception('Failed to get conversion rate');
    when(mockRepository.getConvertRates(any))
        .thenAnswer((_) async => Result.error(tError));

    // act
    final result = await useCase(tConvertRateEntity);

    // assert
    expect(result.isError, true);
    expect(result.asError!.error, tError);
    verify(mockRepository.getConvertRates(tConvertRateEntity));
    verifyNoMoreInteractions(mockRepository);
  });
}
