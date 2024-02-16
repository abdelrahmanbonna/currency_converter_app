import 'package:bloc/bloc.dart';
import 'package:currency_converter_app/Core/Config/my_app.dart';
import 'package:currency_converter_app/Core/Errors/failures.dart';
import 'package:currency_converter_app/Core/UseCases/usecase.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Domain/Entities/convert_rate_entity.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Domain/UseCases/get_currencies_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../Domain/Entities/currency_entity.dart';
import '../../../Domain/UseCases/get_convert_rate_use_case.dart';

part 'currency_converter_event.dart';
part 'currency_converter_state.dart';

class CurrencyConverterBloc
    extends Bloc<CurrencyConverterEvent, CurrencyConverterState> {
  final GetConvertRateUseCase getConvertRateUseCase;
  final GetCurrenciesUseCase getCurrenciesUseCase;
  ConvertRateEntity _convertRateEntity =
      const ConvertRateEntity(convertCurrency: '', baseCurrency: '');

  CurrencyConverterBloc(this.getConvertRateUseCase, this.getCurrenciesUseCase)
      : super(const CurrencyConverterInitial(0)) {
    on<ConvertCurrencyEvent>((event, emit) async {
      EasyLoading.show();
      final result = await getConvertRateUseCase.call(
        ConvertRateEntity(
          convertCurrency: event.convertCurrency,
          baseCurrency: event.baseCurrency,
          amount: event.amount,
        ),
      );
      EasyLoading.dismiss();

      if (result.isValue) {
        _convertRateEntity = result.asValue!.value;
        emit(CurrencyConverterConvertSuccess(
            result.asValue!.value.convertedAmount));
      } else {
        showSnackBar((result.asError!.error as Failure).message);
      }
    });
    on<GetCurrenciesEvent>((event, emit) async {
      EasyLoading.show();
      final result = await getCurrenciesUseCase.call(NoParams());
      EasyLoading.dismiss();

      if (result.isValue) {
        emit(CurrenciesFetchSuccess(
            _convertRateEntity.convertedAmount, result.asValue!.value));
      } else {
        showSnackBar((result.asError!.error as Failure).message);
      }
    });
  }
}
