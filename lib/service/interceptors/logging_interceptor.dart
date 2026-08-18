import 'dart:developer';

import 'package:dio/dio.dart';

class LoggingInterceptor extends Interceptor {
  static const String duration_key = 'duration';
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[duration_key] = Stopwatch()..start();
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logDetails(
      method: response.requestOptions.method,
      url: response.requestOptions.uri.toString(),
      statusCode: response.statusCode,
      requestOptions: response.requestOptions,
      isError: false,
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler  handler) {
    _logDetails(
      method: err.requestOptions.method,
      url: err.requestOptions.uri.toString(),
      statusCode: err.response?.statusCode,
      requestOptions: err.requestOptions,
      isError: true,
    );
    handler.next(err);
  }

  void _logDetails({
    required String method,
    required String url,
    required int? statusCode,
    required RequestOptions requestOptions,
    required bool isError,
  }) {
    final sw = requestOptions.extra[duration_key] as Stopwatch?;
    final duration = sw?.elapsedMilliseconds ?? 0;
    final status = statusCode != null ? '$statusCode' : 'N/A';
    final label = isError ? '❌ [ERROR]' : '✅ [SUCCESS]';

    log(
      '$label | Method: $method | URL: $url | Status: $status | Duration: ${duration}ms',
      name: 'NetworkLog',
    );
  }
}
