

import 'package:dio/dio.dart';
import 'package:dio_project/service/network/interceptors/error_interceptor.dart';
import 'package:dio_project/service/network/interceptors/logging_interceptor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioAuthProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.escuelajs.co/api/v1/auth/',
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 3),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  dio.interceptors.
  addAll([ErrorInterceptor() , LoggingInterceptor()]);
   ref.onDispose(() => dio.close(force: true));
  return dio;
});