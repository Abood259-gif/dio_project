import 'package:dio/dio.dart';
import 'package:dio_project/core/keys.dart';
import 'package:dio_project/provider/auth/auth_dio_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthRemote {
  final Dio authDio;

  AuthRemote({required this.authDio});

  Future<({String accessToken, String refreshToken})> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await authDio.post(
        'login',
        data: {'email': email, 'password': password},
      );
      return (
        accessToken: response.data[Keys.accessToken] as String,
        refreshToken: response.data[Keys.refreshToken] as String,
      );
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<({String accessToken, String refreshToken})> refreshToken({
    required String refreshToken,
  }) async {
    try {
      final response = await authDio.post(
        'refresh-token',
        data: {Keys.refreshToken : refreshToken},
      );
      return (
        accessToken: response.data[Keys.accessToken] as String,
        refreshToken: response.data[Keys.refreshToken] as String,
      );
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}

final authRemoteProvider = Provider<AuthRemote>((ref) {
  final dio = ref.watch(dioAuthProvider);
  return AuthRemote(authDio: dio);
});
