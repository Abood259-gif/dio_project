import 'dart:async';
import 'dart:typed_data';

import 'package:dio_project/models/firebace_user_model.dart';
import 'package:dio_project/repository/auth_repository.dart';
import 'package:dio_project/repository/supabace_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<void> login({required String email, required String password}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.login(email: email, password: password);
    });
  }

  Future<void> signup({required String email, required String password}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.signUp(email: email, password: password);
    });
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.signInWithGoogle();
    });
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.sendPasswordResetEmail(email: email);
    });
  }

  Future<void> updateProfileImage(Uint8List bytes) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authRepository = ref.read(authRepositoryProvider);
      final currentUser = authRepository.currentUser;

      if (currentUser == null) {
        throw Exception('No user signed in');
      }

      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final path = 'profiles/${currentUser.uid}/$fileName';

      // 1. Upload file bytes to Supabase
      final supabaseRepository = ref.read(supabaseRepositoryProvider);
      final publicUrl = await supabaseRepository.uploadImage(bytes, path);

      // 2. Update Firebase Auth user profile
      await authRepository.updateProfileImage(publicUrl);
    });
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.logout();
    });
  }
}

final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, void>(
  AuthNotifier.new,
);

final authstateChange = StreamProvider<AppUser?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
});