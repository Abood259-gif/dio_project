import 'package:dio/dio.dart';
import 'package:dio_project/core/keys.dart';
import 'package:dio_project/service/storge/auth_storage.dart';


class AuthInterceptor extends QueuedInterceptor {
  final Dio _dio;
  final AuthStorage authStorage;

  Future<String?>? _refreshTokenFuture;

  AuthInterceptor({
    required Dio dio,
    required this.authStorage,
  }) : _dio = dio;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await authStorage.getToken(StorageKeys.accessToken);

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
    final requestOptions = err.requestOptions;

    if (err.response?.statusCode == 401 &&
        !_isRefreshRequest(requestOptions)) {
      try {
      
        _refreshTokenFuture ??= _refreshYourToken();

        final newAccessToken = await _refreshTokenFuture;

        if (newAccessToken != null) {
          final newHeaders = Map<String, dynamic>.from(
            requestOptions.headers,
          );

          newHeaders['Authorization'] = 'Bearer $newAccessToken';

          final retryRequest = requestOptions.copyWith(
            headers: newHeaders,
          );

          final response = await _dio.fetch(retryRequest);

          return handler.resolve(response);
        }
      } catch (e) {
        await _handleLogout();
      }
    }

    handler.next(err);
  }

  bool _isRefreshRequest(RequestOptions options) {
    return options.path.contains('/auth/refresh');
  }

  Future<String?> _refreshYourToken() async {
    try {
      final refreshToken =
          await authStorage.getToken(StorageKeys.refreshToken);

      if (refreshToken == null || refreshToken.isEmpty) {
        return null;
      }

     
      final refreshDio = Dio(
        BaseOptions(
          baseUrl: 'https://api.escuelajs.co/api/v1/auth/',
        ),
      );

      final response = await refreshDio.post(
        'refresh-token',
        data: {
          'refreshToken': refreshToken,
        },
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['access_token'];
        final newRefreshToken = response.data['refresh_token'];

        await authStorage.saveToken(
          StorageKeys.accessToken,
          newAccessToken,
        );

        if (newRefreshToken != null) {
          await authStorage.saveToken(
            StorageKeys.refreshToken,
            newRefreshToken,
          );
        }

        return newAccessToken;
      }

      return null;
    } catch (e) {
      return null;
    } finally {
      _refreshTokenFuture = null;
    }
  }

  Future<void> _handleLogout() async {
    await authStorage.deleteToken(StorageKeys.accessToken);
    await authStorage.deleteToken(StorageKeys.refreshToken);
  }
}