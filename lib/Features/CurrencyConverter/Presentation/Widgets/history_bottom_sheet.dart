import 'package:currency_converter_app/Core/Config/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HistoryBottomSheet extends StatefulWidget {
  const HistoryBottomSheet({super.key});

  @override
  State<HistoryBottomSheet> createState() => _HistoryBottomSheetState();
}

class _HistoryBottomSheetState extends State<HistoryBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.sizeOf(context);

    return FractionallySizedBox(
      widthFactor: 1,
      heightFactor: 0.7,
      child: Container(
        width: mediaQuery.width,
        height: mediaQuery.height * 0.65,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: AppColors.veryDarkBlue,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16.sp),
            topLeft: Radius.circular(16.sp),
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //TODO finish when historical data fix arrive
          ],
        ),
      ),
    );
  }
}
