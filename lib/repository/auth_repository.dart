import 'package:dio_project/core/keys.dart';
import 'package:dio_project/service/network/auth_remote.dart';
import 'package:dio_project/service/storge/auth_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class AuthRepository {
  final AuthStorage authStorage;
  final AuthRemote authRemote;

  AuthRepository({required this.authStorage, required this.authRemote});

  Future<void> login({required String email, required String password}) async {
    final tokens = await authRemote.login(email: email, password: password);
    await authStorage.saveToken(StorageKeys.accessToken, tokens.accessToken);
    await authStorage.saveToken(StorageKeys.refreshToken, tokens.refreshToken);
  }

Future<void> refreshToken() async {
    final refreshToken = await authStorage.getToken(StorageKeys.refreshToken);
    if (refreshToken != null) {
      final tokens = await authRemote.refreshToken(refreshToken: refreshToken);
      await authStorage.saveToken(StorageKeys.accessToken, tokens.accessToken);
      await authStorage.saveToken(StorageKeys.refreshToken, tokens.refreshToken);
    } else {
      throw Exception('Refresh token not found');
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authStorage = ref.watch(stroageprovider);
  final authRemote = ref.watch(authRemoteProvider);
  return AuthRepository(authStorage: authStorage, authRemote: authRemote);
});
