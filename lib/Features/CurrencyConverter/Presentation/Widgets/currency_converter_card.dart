import 'package:currency_converter_app/Core/Config/app_theme.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Core/Config/app_constants.dart';
import '../../../../Core/Services/dependancy_injection_service.dart';
import '../Blocs/CurrencyConverter/currency_converter_bloc.dart';

class CurrencyConverterCard extends StatefulWidget {
  const CurrencyConverterCard({super.key});

  @override
  State<CurrencyConverterCard> createState() => _CurrencyConverterCardState();
}

class _CurrencyConverterCardState extends State<CurrencyConverterCard> {
  double amount = 0.0;
  double convertedAmount = 0.0;
  String baseCurrency = 'EGP';
  String convertCurrency = 'USD';

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.sizeOf(context);
    final cardHeight = 250.h;
    return BlocProvider(
      create: (context) => CurrencyConverterBloc(),
      child: BlocBuilder<CurrencyConverterBloc, CurrencyConverterState>(
        bloc: DependencyInjectionService().sl<CurrencyConverterBloc>(),
        builder: (context, state) {
          return Container(
            width: mediaQuery.width,
            height: cardHeight,
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColors.darkBlue,
              borderRadius: BorderRadius.circular(30.sp),
            ),
            child: Stack(
              children: [
                SizedBox(
                  width: mediaQuery.width,
                  height: cardHeight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: mediaQuery.width,
                        height: cardHeight * 0.6,
                        padding: EdgeInsets.all(16.sp),
                        decoration: BoxDecoration(
                          color: AppColors.blue,
                          borderRadius: BorderRadius.circular(30.sp),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Enter amount and currency',
                              style: appTheme.textTheme.bodyMedium!.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Bounceable(
                                      onTap: () {
                                        showCurrencyPicker(
                                          context: context,
                                          showFlag: true,
                                          showCurrencyName: true,
                                          showCurrencyCode: true,
                                          onSelect: (Currency currency) {
                                            setState(() {
                                              baseCurrency = currency.code;
                                            });
                                          },
                                        );
                                      },
                                      child: Image.network(
                                        "${AppConstants.iconsBaseUrl}/16x12/$baseCurrency.png",
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
