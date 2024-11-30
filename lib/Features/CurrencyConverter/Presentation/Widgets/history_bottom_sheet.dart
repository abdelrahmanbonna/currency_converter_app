import 'package:currency_converter_app/Core/Config/app_theme.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Domain/Entities/convert_rate_entity.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Presentation/Blocs/HistoricalRates/historical_rates_bloc.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Presentation/Blocs/HistoricalRates/historical_rates_events.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Presentation/Blocs/HistoricalRates/historical_rates_states.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'dart:math' show min, max;

class HistoryBottomSheet extends StatefulWidget {
  final String baseCurrency;
  final String targetCurrency;

  const HistoryBottomSheet({
    super.key,
    required this.baseCurrency,
    required this.targetCurrency,
  });

  @override
  State<HistoryBottomSheet> createState() => _HistoryBottomSheetState();
}

class _HistoryBottomSheetState extends State<HistoryBottomSheet> {
  late DateTime startDate;
  late DateTime endDate;
  late String currentBaseCurrency;
  late String currentTargetCurrency;

  @override
  void initState() {
    super.initState();
    endDate = DateTime.now();
    startDate = endDate.subtract(const Duration(days: 7));
    currentBaseCurrency = widget.baseCurrency;
    currentTargetCurrency = widget.targetCurrency;
    _fetchHistoricalData();
  }

  @override
  void didUpdateWidget(HistoryBottomSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.baseCurrency != widget.baseCurrency || 
        oldWidget.targetCurrency != widget.targetCurrency) {
      setState(() {
        currentBaseCurrency = widget.baseCurrency;
        currentTargetCurrency = widget.targetCurrency;
      });
      _fetchHistoricalData();
    }
  }

  void _fetchHistoricalData() {
    context.read<HistoricalRatesBloc>().add(
          GetHistoricalRatesEvent(
            ConvertRateEntity(
              baseCurrency: currentBaseCurrency,
              convertCurrency: currentTargetCurrency,
              from: startDate,
              to: endDate,
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.sizeOf(context);

    return FractionallySizedBox(
      widthFactor: 1,
      heightFactor: 0.7,
      child: Container(
        width: mediaQuery.width,
        height: mediaQuery.height * 0.65,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.veryDarkBlue,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16.sp),
            topLeft: Radius.circular(16.sp),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Historical Rates',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => _showDateRangePicker(context),
                  icon: const Icon(
                    Icons.calendar_today,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              '$currentBaseCurrency to $currentTargetCurrency',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 8.h),
            BlocBuilder<HistoricalRatesBloc, HistoricalRatesState>(
              builder: (context, state) {
                if (kDebugMode) {
                  print('Current state: $state');
                  print('Historical rates: ${state.historicalRates}');
                }
                

                if (state is LoadingHistoricalRatesState) {
                  return const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (state is ErrorHistoricalRatesState) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        state.errorMessage,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  );
                }

                if (state is HistoricalRatesFetchSuccess) {
                  if (kDebugMode) {
                    print('Success state rates: ${state.historicalRates}');
                  }
                  if (state.historicalRates.isEmpty) {
                    return const Expanded(
                      child: Center(
                        child: Text(
                          'No historical data available',
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    );
                  }

                  return Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: LineChart(
                            LineChartData(
                              gridData: const FlGridData(show: false),
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 60,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        value.toStringAsFixed(3),
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 35,
                                    interval: 1,
                                    getTitlesWidget: (value, meta) {
                                      if (value.toInt() >= 0 &&
                                          value.toInt() <
                                              state.historicalRates.length) {
                                        final date = state
                                            .historicalRates[value.toInt()]
                                            .from;
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Transform.rotate(
                                            angle: -0.5,
                                            child: Text(
                                              DateFormat('MM/dd').format(date!),
                                              style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      return const Text('');
                                    },
                                  ),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: List.generate(
                                    state.historicalRates.length,
                                    (index) => FlSpot(
                                      index.toDouble(),
                                      state.historicalRates[index].rate,
                                    ),
                                  ),
                                  isCurved: true,
                                  color: Colors.blue,
                                  barWidth: 2,
                                  dotData: const FlDotData(show: false),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    color: Colors.blue.withOpacity(0.1),
                                  ),
                                ),
                              ],
                              minY: state.historicalRates
                                      .map((e) => e.rate)
                                      .reduce(min) *
                                  0.99,
                              maxY: state.historicalRates
                                      .map((e) => e.rate)
                                      .reduce(max) *
                                  1.01,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return const Expanded(
                  child: Center(
                    child: Text(
                      'Select a date range to view historical rates',
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDateRangePicker(BuildContext context) {
    final size = MediaQuery.of(context).size;
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: size.width * 0.85,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.veryDarkBlue,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SfDateRangePicker(
                selectionMode: DateRangePickerSelectionMode.range,
                initialSelectedRange: PickerDateRange(startDate, endDate),
                maxDate: DateTime.now(),
                onSelectionChanged: (args) {
                  if (args.value is PickerDateRange) {
                    final range = args.value as PickerDateRange;
                    if (range.startDate != null && range.endDate != null) {
                      setState(() {
                        startDate = range.startDate!;
                        endDate = range.endDate!;
                      });
                      _fetchHistoricalData();
                      Navigator.pop(context);
                    }
                  }
                },
                headerStyle: const DateRangePickerHeaderStyle(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                monthViewSettings: const DateRangePickerMonthViewSettings(
                  viewHeaderStyle: DateRangePickerViewHeaderStyle(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                monthCellStyle: DateRangePickerMonthCellStyle(
                  textStyle: const TextStyle(color: Colors.white70),
                  disabledDatesTextStyle:
                      TextStyle(color: Colors.white.withOpacity(0.3)),
                  todayTextStyle: const TextStyle(color: Colors.white),
                ),
                yearCellStyle: DateRangePickerYearCellStyle(
                  textStyle: const TextStyle(color: Colors.white70),
                  disabledDatesTextStyle:
                      TextStyle(color: Colors.white.withOpacity(0.3)),
                  todayTextStyle: const TextStyle(color: Colors.white),
                ),
                selectionTextStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                rangeTextStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                selectionColor: Colors.blue,
                rangeSelectionColor: Colors.blue.withOpacity(0.3),
                startRangeSelectionColor: Colors.blue,
                endRangeSelectionColor: Colors.blue,
                todayHighlightColor: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
