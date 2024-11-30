import 'package:cached_network_image/cached_network_image.dart';
import 'package:currency_converter_app/Core/Config/app_constants.dart';
import 'package:currency_converter_app/Core/Config/app_theme.dart';
import 'package:currency_converter_app/Core/Services/dependancy_injection_service.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Presentation/Pages/currency_converter_home.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Blocs/CurrencyConverter/currency_converter_bloc.dart';

class CurrencyConverterCard extends StatefulWidget {
  final TextEditingController baseCurrencyController;
  final TextEditingController convertCurrencyController;
  const CurrencyConverterCard({
    Key? key,
    required this.baseCurrencyController,
    required this.convertCurrencyController,
  }) : super(key: key);

  @override
  State<CurrencyConverterCard> createState() => _CurrencyConverterCardState();
}

class _CurrencyConverterCardState extends State<CurrencyConverterCard> {
  double amount = 1.0;
  String baseCurrency = 'USD';
  String convertCurrency = 'EUR';

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.sizeOf(context);
    final cardHeight = 250.h;
    return BlocProvider(
      create: (context) =>
          DependencyInjectionService().sl<CurrencyConverterBloc>(),
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
                                    child: Padding(
                                      padding: EdgeInsets.all(16.sp),
                                      child: Bounceable(
                                        onTap: () {
                                          showCurrencyPicker(
                                            context: context,
                                            showFlag: true,
                                            showCurrencyName: true,
                                            showCurrencyCode: true,
                                            favorite: ['EGP', 'USD', 'EUR'],
                                            onSelect: (Currency currency) {
                                              setState(() {
                                                baseCurrency = currency.code;
                                                widget.baseCurrencyController
                                                    .text = baseCurrency;
                                              });
                                            },
                                          );
                                        },
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "${AppConstants.iconsBaseUrl}/256x192/${baseCurrency.substring(0, baseCurrency.length - 1).toLowerCase()}.png",
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: TextFormField(
                                      style: appTheme.textTheme.bodyMedium!
                                          .copyWith(
                                        color: Colors.white,
                                      ),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      keyboardType: TextInputType.number,
                                      cursorColor: Colors.white,
                                      onChanged: (String data) {
                                        setState(() {
                                          amount = double.parse(data);
                                        });
                                      },
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ),
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ),
                                        ),
                                        hintText: amount.toString(),
                                        hintStyle: appTheme
                                            .textTheme.bodyMedium!
                                            .copyWith(
                                          color: Colors.white,
                                        ),
                                        contentPadding: EdgeInsets.all(16.sp),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Bounceable(
                                      onTap: () {
                                        showCurrencyPicker(
                                          context: context,
                                          showFlag: true,
                                          showCurrencyName: true,
                                          showCurrencyCode: true,
                                          favorite: ['EGP', 'USD', 'EUR'],
                                          onSelect: (Currency currency) {
                                            setState(() {
                                              baseCurrency = currency.code;
                                              baseCurrencyController.text =
                                                  baseCurrency;
                                            });
                                          },
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          baseCurrency.toString(),
                                          style: appTheme.textTheme.bodyMedium!
                                              .copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.all(31.sp),
                                child: Bounceable(
                                  onTap: () {
                                    showCurrencyPicker(
                                      context: context,
                                      showFlag: true,
                                      showCurrencyName: true,
                                      showCurrencyCode: true,
                                      favorite: ['EGP', 'USD', 'EUR'],
                                      onSelect: (Currency currency) {
                                        setState(() {
                                          widget.convertCurrencyController
                                              .text = currency.code;
                                          convertCurrency = currency.code;
                                        });
                                      },
                                    );
                                  },
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        "${AppConstants.iconsBaseUrl}/256x192/${convertCurrency.substring(0, convertCurrency.length - 1).toLowerCase()}.png",
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                state.convertedAmount.toString(),
                                style: appTheme.textTheme.bodyMedium!.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Bounceable(
                                onTap: () {
                                  showCurrencyPicker(
                                    context: context,
                                    showFlag: true,
                                    showCurrencyName: true,
                                    showCurrencyCode: true,
                                    favorite: ['EGP', 'USD', 'EUR'],
                                    onSelect: (Currency currency) {
                                      setState(() {
                                        widget.convertCurrencyController.text =
                                            currency.code;
                                        convertCurrency = currency.code;
                                      });
                                    },
                                  );
                                },
                                child: Text(
                                  convertCurrency,
                                  style:
                                      appTheme.textTheme.bodyMedium!.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: cardHeight * 0.5,
                  left: mediaQuery.width * 0.42,
                  child: Bounceable(
                    onTap: () {
                      context.read<CurrencyConverterBloc>().add(
                            ConvertCurrencyEvent(
                              amount: amount,
                              baseCurrency: baseCurrency,
                              convertCurrency: convertCurrency,
                            ),
                          );
                    },
                    child: Icon(
                      Icons.currency_exchange,
                      color: Colors.white,
                      size: 45.sp,
                    ),
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
