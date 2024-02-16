import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../Config/app_constants.dart';

/// Handles all the http network calls over the network
class NetworkService {
  static NetworkService? _this;

  factory NetworkService(Dio dioClient) {
    _this ??= NetworkService._(dioClient);
    return _this!;
  }

  final Dio unAuthedDio;

  final String _baseURL = AppConstants.baseUrl;

  NetworkService._(this.unAuthedDio) {
    unAuthedDio.options.baseUrl = _baseURL;
    unAuthedDio.options.connectTimeout = const Duration(milliseconds: 30000);

    initializeInterceptors();
  }

  /// initializing interceptors to handle api calls and to log the requests/responses
  void initializeInterceptors() {
    unAuthedDio.interceptors.clear();

    unAuthedDio.interceptors.add(
      InterceptorsWrapper(
        onRequest:
            (RequestOptions requestOptions, RequestInterceptorHandler handler) {
          requestOptions.queryParameters['apikey'] = AppConstants.apiKey;
          debugPrint("url: ${requestOptions.uri.path}");
          debugPrint("headers: ${requestOptions.headers}");
          debugPrint("headers: ${requestOptions.queryParameters}");
          debugPrint("body: ${requestOptions.data}");
          handler.next(requestOptions);
        },
        onResponse:
            (Response<dynamic> response, ResponseInterceptorHandler handler) {
          debugPrint("status code: ${response.statusCode}");
          debugPrint("response: ${response.data}");
          handler.next(response);
        },
        onError: (DioException error, ErrorInterceptorHandler errorHandler) {
          EasyLoading.dismiss();
          debugPrint("error status code: ${error.response?.statusCode}");
          debugPrint("error: ${error.response?.data}");
          debugPrint("errorMessage: ${error.message}");

          errorHandler.next(error);
        },
      ),
    );
  }
}
