import 'package:bloc/bloc.dart';
import 'package:currency_converter_app/Core/Config/my_app.dart';
import 'package:currency_converter_app/Core/Errors/failures.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Domain/Entities/convert_rate_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../Domain/UseCases/get_convert_rate_use_case.dart';

part 'currency_converter_event.dart';
part 'currency_converter_state.dart';

class CurrencyConverterBloc
    extends Bloc<CurrencyConverterEvent, CurrencyConverterState> {
  final GetConvertRateUseCase getConvertRateUseCase;

  CurrencyConverterBloc(this.getConvertRateUseCase)
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
        emit(CurrencyConverterConvertSuccess(
            result.asValue!.value.convertedAmount));
      } else {
        showSnackBar((result.asError!.error as Failure).message);
      }
    });
  }
}
