import 'package:currency_converter_app/Core/Config/app_theme.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Domain/Entities/convert_rate_entity.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Presentation/Bloc/currency_converter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

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

  @override
  void initState() {
    super.initState();
    endDate = DateTime.now();
    startDate = endDate.subtract(const Duration(days: 7));
    _fetchHistoricalData();
  }

  void _fetchHistoricalData() {
    context.read<CurrencyConverterBloc>().add(
          GetHistoricalRatesEvent(
            ConvertRateEntity(
              baseCurrency: widget.baseCurrency,
              convertCurrency: widget.targetCurrency,
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
              '${widget.baseCurrency} to ${widget.targetCurrency}',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 8.h),
            BlocBuilder<CurrencyConverterBloc, CurrencyConverterState>(
              builder: (context, state) {
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 48.sp,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'Error loading historical data',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16.sp,
                            ),
                          ),
                          TextButton(
                            onPressed: _fetchHistoricalData,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (state is LoadedHistoricalRatesState) {
                  return Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 200.h,
                          child: LineChart(
                            LineChartData(
                              gridData: const FlGridData(show: false),
                              titlesData: FlTitlesData(
                                leftTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      if (value.toInt() >= 0 &&
                                          value.toInt() < state.rates.length) {
                                        return Padding(
                                          padding: EdgeInsets.only(top: 8.h),
                                          child: Text(
                                            DateFormat('MM/dd').format(
                                              state.rates[value.toInt()].from!,
                                            ),
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                        );
                                      }
                                      return const SizedBox();
                                    },
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: state.rates
                                      .asMap()
                                      .entries
                                      .map((entry) => FlSpot(
                                            entry.key.toDouble(),
                                            entry.value.rate,
                                          ))
                                      .toList(),
                                  isCurved: true,
                                  color: AppColors.primaryColor,
                                  barWidth: 2,
                                  isStrokeCapRound: true,
                                  dotData: const FlDotData(show: false),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    color: AppColors.primaryColor.withOpacity(0.1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Expanded(
                          child: ListView.builder(
                            itemCount: state.rates.length,
                            itemBuilder: (context, index) {
                              final rate = state.rates[index];
                              return ListTile(
                                title: Text(
                                  DateFormat('MMM dd, yyyy')
                                      .format(rate.from!),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                trailing: Text(
                                  rate.rate.toStringAsFixed(6),
                                  style: TextStyle(
                                    color: AppColors.primaryColor,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDateRangePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppColors.darkBlue,
        child: Padding(
          padding: EdgeInsets.all(16.sp),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SfDateRangePicker(
                initialSelectedRange: PickerDateRange(startDate, endDate),
                selectionMode: DateRangePickerSelectionMode.range,
                maxDate: DateTime.now(),
                onSelectionChanged: (args) {
                  if (args.value is PickerDateRange) {
                    final range = args.value as PickerDateRange;
                    if (range.startDate != null && range.endDate != null) {
                      setState(() {
                        startDate = range.startDate!;
                        endDate = range.endDate!;
                      });
                    }
                  }
                },
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  SizedBox(width: 8.w),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _fetchHistoricalData();
                    },
                    child: const Text('Apply'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
