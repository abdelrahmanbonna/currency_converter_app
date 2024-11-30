import 'package:currency_converter_app/Core/Services/dependancy_injection_service.dart';
import 'package:currency_converter_app/Features/CurrencyConverter/Presentation/Blocs/CurrencyConverter/currency_converter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_routes.dart';
import 'app_theme.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void showSnackBar(String message) {
  ScaffoldMessenger.of(navigatorKey.currentState!.context).showSnackBar(
    SnackBar(
      content: Center(
        child: Text(
          message,
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      designSize: const Size(393, 844),
      builder: (_, __) {
        return BlocProvider(
          create: (context) =>
              DependencyInjectionService().sl<CurrencyConverterBloc>(),
          child: MaterialApp(
            theme: appTheme,
            navigatorKey: navigatorKey,
            initialRoute: AppRoutes.initial,
            onGenerateRoute: AppRoutes.generateRoute,
            debugShowCheckedModeBanner: false,
            builder: EasyLoading.init(),
          ),
        );
      },
    );
  }
}
