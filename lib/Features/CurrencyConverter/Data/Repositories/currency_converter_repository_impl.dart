import 'package:async/async.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Data/DataSources/currency_converter_data_source.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Data/Models/convert_rate_model.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Domain/Entities/convert_rate_entity.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Domain/Entities/currency_entity.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Domain/Repositories/currency_converter_repository.dart';
import 'package:dio/dio.dart';

class CurrencyConverterRepositoryImpl implements CurrencyConverterRepository {
  final CurrencyConverterDataSource remoteDataSource;

  CurrencyConverterRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<ConvertRateEntity>> getConvertRates(ConvertRateEntity info) async {
    try {
      final response = await remoteDataSource.getCurrencyConvert(
        ConvertRateModel.fromEntity(info),
      );

      if (response.statusCode == 200) {
        final convertRate = ConvertRateModel.fromJson(response.data);
        return Result.value(convertRate);
      } else {
        return Result.error(
          Exception('Failed to get conversion rate: ${response.statusMessage}'),
        );
      }
    } on DioException catch (e) {
      return Result.error(e);
    } catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<List<ConvertRateEntity>>> getHistoricalRates(
      ConvertRateEntity info) async {
    try {
      final response = await remoteDataSource.getHistoricalData(
        ConvertRateModel.fromEntity(info),
      );

      if (response.statusCode == 200) {
        final List<ConvertRateEntity> rates = [];
        final Map<String, dynamic> results = response.data['results'];
        
        for (var entry in results.entries) {
          final date = entry.key;
          final rateData = entry.value;
          rates.add(ConvertRateModel(
            baseCurrency: info.baseCurrency,
            convertCurrency: info.convertCurrency,
            rate: rateData['val'].toDouble(),
            from: DateTime.parse(date),
            to: DateTime.parse(date),
          ));
        }
        
        return Result.value(rates);
      } else {
        return Result.error(
          Exception('Failed to get historical rates: ${response.statusMessage}'),
        );
      }
    } on DioException catch (e) {
      return Result.error(e);
    } catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<List<CurrencyEntity>>> getCurrencies() async {
    try {
      final response = await remoteDataSource.getCurrencies();

      if (response.statusCode == 200) {
        final Map<String, dynamic> currenciesData = response.data['results'];
        final List<CurrencyEntity> currencies = [];
        
        for (var entry in currenciesData.entries) {
          currencies.add(CurrencyEntity(
            code: entry.key,
            name: entry.value['currencyName'],
            symbol: entry.value['currencySymbol'] ?? '',
          ));
        }
        
        return Result.value(currencies);
      } else {
        return Result.error(
          Exception('Failed to get currencies: ${response.statusMessage}'),
        );
      }
    } on DioException catch (e) {
      return Result.error(e);
    } catch (e) {
      return Result.error(e);
    }
  }
}
