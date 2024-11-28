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
    try {
      final result =
          await _dataSource.getCurrencyConvert(ConvertRateModel.fromEntity(info));

      if (result.statusCode == 200) {
        final String pairKey = '${info.baseCurrency}_${info.convertCurrency}';
        final rateData = result.data['results'][pairKey];
        
        if (rateData == null) {
          return Result.error(
            ServerFailure(
              "Invalid response: Missing conversion rate data",
            ),
          );
        }

        var data = ConvertRateEntity(
          convertCurrency: rateData['to'],
          baseCurrency: rateData['fr'],
          from: info.from,
          to: info.to,
          rate: (rateData['val'] as num).toDouble(),
          amount: info.amount,
        );

        return Result.value(data);
      } else {
        return Result.error(
          ServerFailure(
            "Server Failure\nStatus code:${result.statusCode}\nCouldn't get data from server",
          ),
        );
      }
    } catch (e) {
      return Result.error(
        ServerFailure(
          "Error processing response: ${e.toString()}",
        ),
      );
    }
  }

  @override
  Future<Result<List<ConvertRateEntity>>> getHistoricalRates(
      ConvertRateEntity info) async {
    try {
      final result =
          await _dataSource.getHistoricalData(ConvertRateModel.fromEntity(info));

      if (result.statusCode == 200) {
        final List<ConvertRateEntity> rates = [];
        final Map<String, dynamic> historicalData = result.data;
        
        historicalData.forEach((date, value) {
          if (value != null) {
            rates.add(ConvertRateEntity(
              convertCurrency: info.convertCurrency,
              baseCurrency: info.baseCurrency,
              rate: (value as num).toDouble(),
              from: DateTime.parse(date),
              to: DateTime.parse(date),
              amount: info.amount,
            ));
          }
        });

        // Sort rates by date
        rates.sort((a, b) => a.from!.compareTo(b.from!));
        
        return Result.value(rates);
      } else {
        return Result.error(
          ServerFailure(
            "Server Failure\nStatus code:${result.statusCode}\nCouldn't get historical data",
          ),
        );
      }
    } catch (e) {
      return Result.error(
        ServerFailure(
          "Error processing historical data: ${e.toString()}",
        ),
      );
    }
  }

  @override
  Future<Result<List<CurrencyEntity>>> getCurrencies() async {
    try {
      final result = await _dataSource.getCurrencies();

      if (result.statusCode == 200) {
        final Map<String, dynamic> currenciesData = result.data['results'];
        final List<CurrencyEntity> currencies = [];

        currenciesData.forEach((code, data) {
          currencies.add(CurrencyEntity(
            code: code,
            name: data['currencyName'] ?? '',
            symbol: data['currencySymbol'] ?? '',
          ));
        });

        return Result.value(currencies);
      } else {
        return Result.error(
          ServerFailure(
            "Server Failure\nStatus code:${result.statusCode}\nCouldn't get currencies",
          ),
        );
      }
    } catch (e) {
      return Result.error(
        ServerFailure(
          "Error processing currencies: ${e.toString()}",
        ),
      );
    }
  }
}
