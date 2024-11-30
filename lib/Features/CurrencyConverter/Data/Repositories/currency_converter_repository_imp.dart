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
      final result = await _dataSource
          .getCurrencyConvert(ConvertRateModel.fromEntity(info));

      if (result.statusCode == 200) {
        final String pairKey = '${info.baseCurrency}_${info.convertCurrency}';
        final rateData = result.data['results'][pairKey];

        if (rateData == null) {
          // Try to get from cache if remote data is invalid
          final cachedResult = await _getCachedConvertRates(info);
          if (cachedResult != null) {
            return Result.value(cachedResult);
          }

          return Result.error(
            const ServerFailure(
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

        // Save successful response to cache
        await _cacheDataSource.setCurrencyConvertData(data.toMap());

        return Result.value(data);
      } else {
        // Try to get from cache if remote request fails
        final cachedResult = await _getCachedConvertRates(info);
        if (cachedResult != null) {
          return Result.value(cachedResult);
        }

        return Result.error(
          ServerFailure(
            "Server Failure\nStatus code:${result.statusCode}\nCouldn't get data from server",
          ),
        );
      }
    } catch (e) {
      // Try to get from cache if remote request throws error
      final cachedResult = await _getCachedConvertRates(info);
      if (cachedResult != null) {
        return Result.value(cachedResult);
      }

      return Result.error(
        ServerFailure(
          "Server Failure\n${e.toString()}",
        ),
      );
    }
  }

  Future<ConvertRateEntity?> _getCachedConvertRates(
      ConvertRateEntity info) async {
    try {
      final cachedResult = await _cacheDataSource
          .getCurrencyConvert(ConvertRateModel.fromEntity(info));

      if (cachedResult.statusCode == 200) {
        final String pairKey = '${info.baseCurrency}_${info.convertCurrency}';
        final rateData = cachedResult.data['results'][pairKey];

        if (rateData != null) {
          return ConvertRateEntity(
            convertCurrency: rateData['to'],
            baseCurrency: rateData['fr'],
            from: info.from,
            to: info.to,
            rate: (rateData['val'] as num).toDouble(),
            amount: info.amount,
          );
        }
      }
    } catch (e) {
      // If cache retrieval fails, return null to continue with error flow
      return null;
    }
    return null;
  }

  @override
  Future<Result<List<ConvertRateEntity>>> getHistoricalRates(
      ConvertRateEntity info) async {
    try {
      final result = await _dataSource
          .getHistoricalData(ConvertRateModel.fromEntity(info));

      if (result.statusCode == 200) {
        final List<ConvertRateEntity> rates = [];
        final Map<String, dynamic> historicalData = result.data;
        
        print('Historical Data Response: $historicalData'); // Debug log
        
        // Get the currency pair key (e.g., "USD_EUR")
        final String pairKey = '${info.baseCurrency}_${info.convertCurrency}';
        print('Looking for pair key: $pairKey'); // Debug log
        
        final Map<String, dynamic>? pairData = historicalData[pairKey] as Map<String, dynamic>?;
        print('Pair data found: $pairData'); // Debug log
        
        if (pairData != null) {
          pairData.forEach((dateStr, value) {
            final rate = double.tryParse(value.toString());
            final date = DateTime.tryParse(dateStr);
            
            print('Parsing date: $dateStr, rate: $value'); // Debug log
            
            if (rate != null && date != null) {
              rates.add(ConvertRateEntity(
                baseCurrency: info.baseCurrency,
                convertCurrency: info.convertCurrency,
                rate: rate,
                from: date,
              ));
            }
          });

          print('Parsed rates count: ${rates.length}'); // Debug log
          
          // Sort rates by date
          rates.sort((a, b) => a.from!.compareTo(b.from!));
          
          return Result.value(rates);
        }
        
        return Result.error(
          ServerFailure(
            'No historical data found for $pairKey',
          ),
        );
      } else {
        return Result.error(
          ServerFailure(
            result.data['msg'] ?? 'Failed to fetch historical rates',
          ),
        );
      }
    } catch (e, stackTrace) {
      print('Error in getHistoricalRates: $e'); // Debug log
      print('Stack trace: $stackTrace'); // Debug log
      return Result.error(
        ServerFailure(
          e.toString(),
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
