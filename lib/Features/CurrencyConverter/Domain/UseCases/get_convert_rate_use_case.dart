import 'package:async/async.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Domain/Entities/convert_rate_entity.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Domain/Repositories/currency_converter_repository.dart';

import '../../../../Core/UseCases/usecase.dart';

class GetConvertRateUseCase
    implements UseCase<ConvertRateEntity, ConvertRateEntity> {
  final CurrencyConverterRepository _repository;
  GetConvertRateUseCase(this._repository);

  @override
  Future<Result<ConvertRateEntity>> call(ConvertRateEntity params) async {
    return await _repository.getConvertRates(params);
  }
}
