class EndPointsPaths {
  // API Configuration
  static const String apiKey = 'f913b0a987ac2f63f720';

  // Real-time currency conversion
  static String convertEndPoint = '/api/v7/convert';

  // Historical currency rates
  static String historicalDataEndPoint = '/api/v7/convert';

  // Get list of available currencies
  static String currenciesEndPoint = '/api/v7/currencies';
  // Query parameters
  static const String compactParam = 'compact=ultra';
  static const String apiKeyParamName = 'apiKey';
}
