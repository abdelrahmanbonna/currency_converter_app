import 'package:async/src/result/result.dart';
import 'package:currency_converter_app/Core/Errors/failures.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Data/DataSources/currency_converter_data_source.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Data/Models/convert_rate_model.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Domain/Entities/convert_rate_entity.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Domain/Repositories/currency_converter_repository.dart';

class CurrencyConverterRepositoryImp implements CurrencyConverterRepository {
  final CurrencyConverterDataSource _dataSource;

  CurrencyConverterRepositoryImp(this._dataSource);

  @override
  Future<Result<ConvertRateEntity>> getConvertRates(
      ConvertRateEntity info) async {
    final result =
        await _dataSource.getCurrencyConvert(ConvertRateModel.fromEntity(info));

    if (result.statusCode == 200) {
      return Result.value(ConvertRateEntity(
        convertCurrency: info.convertCurrency,
        baseCurrency: info.baseCurrency,
        from: info.from,
        to: info.to,
        rate: result.data["${info.baseCurrency}_${info.convertCurrency}"],
        amount: info.amount,
      ));
    } else {
      return Result.error(ServerFailure(
          "Server Failure\nStatus code:${result.statusCode}\nCouldn't get data from server"));
    }
  }
}
