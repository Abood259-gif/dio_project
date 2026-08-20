import 'package:dio/dio.dart';
import 'package:dio_project/repository/auth_repository.dart';
import 'package:dio_project/service/network/interceptors/error_interceptor.dart';
import 'package:dio_project/service/network/interceptors/logging_interceptor.dart';
import 'package:dio_project/service/network/interceptors/retry_interceptor.dart';
import 'package:dio_project/service/network/interceptors/token_interceptor.dart';
import 'package:dio_project/service/storge/auth_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  final authStorage = ref.watch(stroageprovider);
  final authrepository = ref.watch(authRepositoryProvider);
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

  dio.interceptors.addAll([
    // IMPORTANT: Interceptor order matters for onError handling.
    // AuthInterceptor must come FIRST to handle 401 silent refresh
    // before ErrorInterceptor transforms/maps the raw DioException.
    AuthInterceptor(dio: dio, authStorage: authStorage , authRepository: authrepository),
    RetryInterceptor(dio: dio),
    ErrorInterceptor(),
    LoggingInterceptor(),
  ]);

  ref.onDispose(() => dio.close(force: true));

  return dio;
});
