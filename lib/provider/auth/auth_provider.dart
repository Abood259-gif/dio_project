import 'dart:async';
import 'package:dio_project/core/keys.dart';
import 'package:dio_project/provider/auth/authe_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio_project/repository/auth_repository.dart';

class AuthNotifier extends AsyncNotifier<AuthState> {
  @override
  FutureOr<AuthState> build() async {
    final repo = ref.watch(authRepositoryProvider);
    final bool loggedIn = await repo.isLoggedIn();
    if (loggedIn) {
      return AuthAuthenticated();
    }
    return AuthUnauthenticated();
  }

  Future<void> login({required String email, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(authRepositoryProvider)
          .login(email: email, password: password);
      return AuthAuthenticated();
    });
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      repo.logout();
      return AuthUnauthenticated();
    });
  }
}

final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
