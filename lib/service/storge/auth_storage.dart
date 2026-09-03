import 'package:dio_project/service/storge/secure_storage.dart';
import 'package:dio_project/service/storge/storge_interface.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthStorage {
  final StorgeInterface storage;
  AuthStorage({required this.storage});
  Future<void> saveToken(String tokenKey, String token) async {
    await storage.writeData(key: tokenKey, value: token);
  }

  Future<String?> getToken(String tokenKey) async {
    return await storage.readData(key: tokenKey);
  }

  Future<void> deleteToken(String tokenKey) async {
    await storage.deleteData(key: tokenKey);
  }
}

final stroageprovider = Provider.autoDispose<AuthStorage>((ref) {
  final storage = ref.watch(storageProvider);
  return AuthStorage(storage: storage);
});
