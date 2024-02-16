import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_routes.dart';
import 'app_theme.dart';

/// This key is used to make redirections outside the pages
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      designSize: const Size(393, 844),
      builder: (_, __) {
        return MaterialApp(
          theme: appTheme,
          navigatorKey: navigatorKey,
          initialRoute: AppRoutes.initial,
          onGenerateRoute: AppRoutes.generateRoute,
          debugShowCheckedModeBanner: false,
          builder: EasyLoading.init(),
        );
      },
    );
  }
}
