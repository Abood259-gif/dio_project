

import 'package:dio_project/service/storge/secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  final secureStorage = const FlutterSecureStorage();
  return secureStorage;
});