import 'package:async/async.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Domain/Entities/currency_entity.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Domain/Repositories/currency_converter_repository.dart';

import '../../../../Core/UseCases/usecase.dart';

class GetCurrenciesUseCase implements UseCase<List<CurrencyEntity>, NoParams> {
  final CurrencyConverterRepository _repository;

  GetCurrenciesUseCase(this._repository);

  @override
  Future<Result<List<CurrencyEntity>>> call(NoParams params) async {
    return await _repository.getCurrencies();
  }
}
