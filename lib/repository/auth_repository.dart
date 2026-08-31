import 'package:dio_project/core/keys.dart';
import 'package:dio_project/models/firebace_user_model.dart';
import 'package:dio_project/service/network/app_exception.dart';
import 'package:dio_project/service/network/auth_remote.dart';
import 'package:dio_project/service/storge/auth_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final AuthStorage authStorage;
  final AuthRemote authRemote;
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<AppUser?> authStateChanges() {
    return _firebaseAuth.authStateChanges().map(_convertUser);
  }

  Stream<AppUser?> userStateChanges() {
    return _firebaseAuth.userChanges().map(_convertUser);
  }

  User? get currentUser => _firebaseAuth.currentUser;

  AppUser? get currentAppUser => _convertUser(currentUser);

  AppUser? _convertUser(User? user) =>
      user == null ? null : AppUser.fromUser(user);

  AuthRepository({
    required this.authStorage,
    required this.authRemote,
    required FirebaseAuth firebaseAuth,
  }) : _firebaseAuth = firebaseAuth;

  Future<void> login({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseCode(e.code, e.message);
    } catch (e) {
      if (e is AppException) rethrow;
      throw UnknownException(e.toString());
    }
  }

  Future<void> signUp({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseCode(e.code, e.message);
    } catch (e) {
      if (e is AppException) rethrow;
      throw UnknownException(e.toString());
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return; // User canceled sign-in
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseCode(e.code, e.message);
    } catch (e) {
      if (e is AppException) rethrow;
      throw UnknownException(e.toString());
    }
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseCode(e.code, e.message);
    } catch (e) {
      if (e is AppException) rethrow;
      throw UnknownException(e.toString());
    }
  }

  /// Updates the current user's photo URL in Firebase Auth
  Future<void> updateProfileImage(String photoUrl) async {
    try {
      final user = currentUser;
      if (user == null) {
        throw ('No user signed in');
      }

      await user.updatePhotoURL(photoUrl);
      await user.reload(); // Refresh local user state
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseCode(e.code, e.message);
    } catch (e) {
      if (e is AppException) rethrow;
      throw UnknownException(e.toString());
    }
  }

  Future<String?> getIdToken([bool forceRefresh = false]) async {
    return await currentUser?.getIdToken(forceRefresh);
  }

  Future<bool> isLoggedIn() async {
    return currentUser != null;
  }

  Future<void> logout() async {
    try {
      await Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
    } catch (_) {
      await _firebaseAuth.signOut();
    }
  }

  Future<void> refreshToken() async {
    final refreshToken = await authStorage.getToken(StorageKeys.refreshToken);
    if (refreshToken != null) {
      final tokens = await authRemote.refreshToken(refreshToken: refreshToken);
      await authStorage.saveToken(StorageKeys.accessToken, tokens.accessToken);
      await authStorage.saveToken(
        StorageKeys.refreshToken,
        tokens.refreshToken,
      );
    } else {
      throw Exception('Refresh token not found');
    }
  }
}

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authStorage = ref.watch(stroageprovider);
  final authRemote = ref.watch(authRemoteProvider);
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return AuthRepository(
    authStorage: authStorage,
    authRemote: authRemote,
    firebaseAuth: firebaseAuth,
  );
});