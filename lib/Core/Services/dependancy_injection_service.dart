import 'package:currency_converter_app/Features/CurrencyConverter/Data/DataSources/currency_converter_data_source.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Data/Repositories/currency_converter_repository_imp.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Domain/UseCases/get_convert_rate_use_case.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Presentation/Blocs/CurrencyConverter/currency_converter_bloc.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Presentation/Blocs/ExchangeRates/exchange_rates_bloc.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../../Features/CurrencyConverter/Domain/Repositories/currency_converter_repository.dart';
import 'network_service.dart';

class DependencyInjectionService {
  static DependencyInjectionService? _this;
  final sl = GetIt.instance;

  DependencyInjectionService._();

  factory DependencyInjectionService() {
    return _this ??= DependencyInjectionService._();
  }

  Future<void> init() async {
    await registerCoreDependencies();
    await registerDataSources();
    await registerRepositories();
    await registerUseCases();
    await registerBlocs();
  }

  Future<void> registerCoreDependencies() async {
    Box box = await Hive.openBox<String>('MyDB').then((value) => value);

    sl.registerLazySingleton<Dio>(
      () => Dio(),
    );
    sl.registerLazySingleton<NetworkService>(
      () => NetworkService(sl()),
    );
    sl.registerLazySingleton(
      () => box,
    );
  }

  Future<void> registerDataSources() async {
    sl.registerLazySingleton<CurrencyConverterDataSource>(
      () => CurrencyConverterRemoteDataSource(sl()),
    );
  }

  Future<void> registerRepositories() async {
    sl.registerLazySingleton<CurrencyConverterRepository>(
      () => CurrencyConverterRepositoryImp(sl()),
    );
  }

  Future<void> registerUseCases() async {
    sl.registerLazySingleton<GetConvertRateUseCase>(
      () => GetConvertRateUseCase(sl()),
    );
  }

  Future<void> registerBlocs() async {
    sl.registerLazySingleton<CurrencyConverterBloc>(
      () => CurrencyConverterBloc(sl()),
    );
    sl.registerLazySingleton<ExchangeRatesBloc>(
      () => ExchangeRatesBloc(),
    );
  }
}
