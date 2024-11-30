import 'package:async/async.dart';
import 'package:currency_converter_app/Core/UseCases/usecase.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Domain/Entities/convert_rate_entity.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Domain/Repositories/currency_converter_repository.dart';

class GetHistorucalRatesUseCase
    extends UseCase<List<ConvertRateEntity>, ConvertRateEntity> {
  final CurrencyConverterRepository _repository;
  GetHistorucalRatesUseCase(this._repository);

  @override
  Future<Result<List<ConvertRateEntity>>> call(ConvertRateEntity params) async {
    return await _repository.getHistoricalRates(params);
  }
}
