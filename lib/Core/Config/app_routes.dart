import 'package:currency_converter_app/Features/CurrencyConverter/Presentation/Pages/currency_converter_home.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String initial = '/';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initial:
        return MaterialPageRoute<dynamic>(
            builder: (_) => const CurrencyConverterHome(), settings: settings);
      default:
        return MaterialPageRoute<dynamic>(
            builder: (_) => const CurrencyConverterHome(), settings: settings);
    }
  }
}
