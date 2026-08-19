import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio_project/core/keys.dart';
import 'package:dio_project/service/storge/auth_storage.dart';

class AuthInterceptor extends QueuedInterceptor {
  final Dio _dio;
  final AuthStorage authStorage;
  AuthInterceptor({required Dio dio, required this.authStorage}) : _dio = dio;
  int _refreshCount = 0;
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.path == 'login' || options.path == 'refresh-token') {
      return handler.next(options);
    }
    final accessToken = await authStorage.getToken(StorageKeys.accessToken);
    options.extra[StorageKeys.accessToken] = accessToken;
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final response = err.response;
    final requestOptions = err.requestOptions;
    if (response?.statusCode == 401 &&
        requestOptions.extra[StorageKeys.accessToken] ==
            await authStorage.getToken(StorageKeys.accessToken)) {
      final refreshToken = await authStorage.getToken(StorageKeys.refreshToken);
      log('🔄 REFRESH #${++_refreshCount}');
      final responsRefresh = Dio(
        BaseOptions(
          baseUrl: 'https://api.escuelajs.co/api/v1/auth/',
          connectTimeout: Duration(seconds: 5),
          receiveTimeout: Duration(seconds: 3),
          headers: {'Content-Type': 'application/json'},
        ),
      );
      try {
        final refreshResponse = await responsRefresh.post(
          'refresh-token',
          data: {'refreshToken': refreshToken},
        );
        final newAccessToken =
            refreshResponse.data[ApiKeys.accessToken] as String;
        final newRefreshToken =
            refreshResponse.data[ApiKeys.refreshToken] as String;
        await authStorage.saveToken(StorageKeys.accessToken, newAccessToken);
        await authStorage.saveToken(StorageKeys.refreshToken, newRefreshToken);
        log('the new access token is : $newAccessToken');
      } on DioException catch (e) {
        return handler.next(e);
      }
    }
    if (response?.statusCode == 401) {
      final newAccessToken = await authStorage.getToken(
        StorageKeys.accessToken,
      );
      final updateheder = Map<String, dynamic>.from(requestOptions.headers)
        ..['Authorization'] = 'Bearer $newAccessToken';
      final updateRequestOptions = requestOptions.copyWith(
        headers: updateheder,
      );
      try {
        final newResponse = await _dio.fetch(updateRequestOptions);
        return handler.resolve(newResponse);
      } on DioException catch (e) {
        return handler.next(e);
      }
    }
    handler.next(err);
  }
}
