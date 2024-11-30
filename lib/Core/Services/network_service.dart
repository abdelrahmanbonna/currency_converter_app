import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../Config/app_constants.dart';

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

  void initializeInterceptors() {
    unAuthedDio.interceptors.clear();

    unAuthedDio.interceptors.add(
      InterceptorsWrapper(
        onRequest:
            (RequestOptions requestOptions, RequestInterceptorHandler handler) {
          requestOptions.queryParameters['apiKey'] = AppConstants.apiKey;
          handler.next(requestOptions);
        },
        onResponse:
            (Response<dynamic> response, ResponseInterceptorHandler handler) {
          handler.next(response);
        },
        onError: (DioException error, ErrorInterceptorHandler errorHandler) {
          EasyLoading.dismiss();
          errorHandler.next(error);
        },
      ),
    );
  }
}
