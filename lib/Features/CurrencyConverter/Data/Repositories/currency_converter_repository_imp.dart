import 'package:async/async.dart';
import 'package:currency_converter_app/Core/Errors/failures.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Data/DataSources/currency_converter_remote_data_source.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Data/Models/convert_rate_model.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Domain/Entities/convert_rate_entity.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Domain/Entities/currency_entity.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Domain/Repositories/currency_converter_repository.dart';

import '../DataSources/currency_converter_cache_data_source.dart';

class CurrencyConverterRepositoryImp implements CurrencyConverterRepository {
  final CurrencyConverterRemoteDataSource _dataSource;
  final CurrencyConverterCacheDataSource _cacheDataSource;

  CurrencyConverterRepositoryImp(this._dataSource, this._cacheDataSource);

  @override
  Future<Result<ConvertRateEntity>> getConvertRates(
      ConvertRateEntity info) async {
    final result =
        await _dataSource.getCurrencyConvert(ConvertRateModel.fromEntity(info));

    if (result.statusCode == 200) {
      var data = ConvertRateEntity(
        convertCurrency: info.convertCurrency,
        baseCurrency: info.baseCurrency,
        from: info.from,
        to: info.to,
        rate: result.data["data"][info.convertCurrency],
        amount: info.amount,
      );

      return Result.value(
        data,
      );
    } else {
      return Result.error(
        ServerFailure(
          "Server Failure\nStatus code:${result.statusCode}\nCouldn't get data from server",
        ),
      );
    }
  }

  @override
  Future<Result<List<ConvertRateEntity>>> getHistoricalRates(
      ConvertRateEntity info) async {
    //TODO implement converting the data

    final result =
        await _dataSource.getHistoricalData(ConvertRateModel.fromEntity(info));

    if (result.statusCode == 200) {
      return Result.value([]);
    } else {
      return Result.error(
        ServerFailure(
          "Server Failure\nStatus code:${result.statusCode}\nCouldn't get data from server",
        ),
      );
    }
  }

  @override
  Future<Result<List<CurrencyEntity>>> getCurrencies() async {
    final result1 = await _cacheDataSource.getCurrencies();

    if (result1.statusCode == 200) {
      List<CurrencyEntity> list = [];
      for (var value in (result1.data['data'] as Iterable)) {
        list.add(CurrencyEntity.fromJson(value));
      }

      return Result.value(list);
    } else {
      final result = await _dataSource.getCurrencies();

      if (result.statusCode == 200) {
        _cacheDataSource.setCurrencyData(result.data['data']);

        List<CurrencyEntity> list = [];
        (result.data['data'] as Map).forEach((key, value) {
          list.add(CurrencyEntity.fromJson(value));
        });

        return Result.value(list);
      } else {
        return Result.error(
          ServerFailure(
            "Server Failure\nStatus code:${result.statusCode}\nCouldn't get data from server",
          ),
        );
      }
    }
  }
}
