import 'package:dio/dio.dart';
import 'package:dio_project/app_routs.dart';
import 'package:dio_project/core/keys.dart';
import 'package:dio_project/screen/product_screen.dart';
import 'package:dio_project/service/network/interceptors/token_interceptor.dart';
import 'package:dio_project/service/storge/auth_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  runApp(const ProviderScope(child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: approute,
    );
  }
}
