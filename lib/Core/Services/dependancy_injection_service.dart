import 'package:currency_converter_app/Features/CurrencyConverter/Presentation/Blocs/CurrencyConverter/currency_converter_bloc.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Presentation/Blocs/ExchangeRates/exchange_rates_bloc.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

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

  Future<void> registerDataSources() async {}

  Future<void> registerRepositories() async {}

  Future<void> registerUseCases() async {}

  Future<void> registerBlocs() async {
    sl.registerLazySingleton<CurrencyConverterBloc>(
        () => CurrencyConverterBloc());
    sl.registerLazySingleton<ExchangeRatesBloc>(() => ExchangeRatesBloc());
  }
}
