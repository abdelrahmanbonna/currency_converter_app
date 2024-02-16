import 'package:currency_converter_app/Core/Config/app_theme.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Presentation/Widgets/currency_converter_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CurrencyConverterHome extends StatefulWidget {
  const CurrencyConverterHome({super.key});

  @override
  State<CurrencyConverterHome> createState() => _CurrencyConverterHomeState();
}

class _CurrencyConverterHomeState extends State<CurrencyConverterHome> {
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
              const CurrencyConverterCard(),
              SizedBox(
                height: 10.h,
              ),
              FilledButton(
                onPressed: () {},
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
