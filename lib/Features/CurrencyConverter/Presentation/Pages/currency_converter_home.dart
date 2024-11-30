import 'package:currency_converter_app/Core/Config/app_theme.dart';
import 'package:currency_converter_app/Core/Services/dependancy_injection_service.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Presentation/Blocs/CurrencyConverter/currency_converter_bloc.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Presentation/Blocs/HistoricalRates/historical_rates_bloc.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Presentation/Widgets/currency_converter_card.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Presentation/Widgets/history_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // added import

class CurrencyConverterHome extends StatefulWidget {
  const CurrencyConverterHome({super.key});

  @override
  State<CurrencyConverterHome> createState() => _CurrencyConverterHomeState();
}

class _CurrencyConverterHomeState extends State<CurrencyConverterHome> {
  TextEditingController baseCurrencyController =
      TextEditingController(text: 'USD');
  TextEditingController targetCurrencyController =
      TextEditingController(text: 'EUR');
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.veryDarkBlue,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CurrencyConverterCard(
                baseCurrencyController: baseCurrencyController,
                convertCurrencyController: targetCurrencyController,
              ),
              SizedBox(
                height: 10.h,
              ),
              FilledButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    isDismissible: true,
                    isScrollControlled: true,
                    builder: (context) {
                      return BlocProvider.value(
                        value: DependencyInjectionService()
                            .sl<HistoricalRatesBloc>(),
                        child: HistoryBottomSheet(
                          baseCurrency: baseCurrencyController.text,
                          targetCurrency: targetCurrencyController.text,
                        ),
                      );
                    },
                  );
                },
                child: const Text(
                  'Get Historical Data',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
