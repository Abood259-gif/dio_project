import 'package:dio_project/provider/secure_storage_provider.dart';
import 'package:dio_project/service/storge/storge_interface.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage implements StorgeInterface {
  final FlutterSecureStorage _storage;
  const SecureStorage({required this._storage});
  @override
  Future<void> writeData({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  @override
  Future<String?> readData({required String key}) async {
    return await _storage.read(key: key);
  }

  @override
  Future<void> deleteData({required String key}) async {
    _storage.delete(key: key);
  }
}

final storageProvider = Provider.autoDispose<StorgeInterface>((ref) {
  final flutterSecureStorageprovider = ref.watch(secureStorageProvider);
  return SecureStorage(storage: flutterSecureStorageprovider);
});
