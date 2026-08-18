import 'package:dio/dio.dart';
import 'package:dio_project/service/interceptors/error_interceptor.dart';
import 'package:dio_project/service/interceptors/logging_interceptor.dart';
import 'package:dio_project/service/interceptors/retry_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.escuelajs.co/api/v1/',
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 3),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );
 
    dio.interceptors.
    addAll([LoggingInterceptor() ,  ErrorInterceptor() , RetryInterceptor(dio: dio)]);
  
  return dio;
});
