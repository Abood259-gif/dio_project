import 'dart:developer';

import 'package:dio_project/core/keys.dart';
import 'package:dio_project/entities/product_entity.dart';
import 'package:dio_project/provider/dio_provider.dart';
import 'package:dio_project/provider/product_provider.dart';
import 'package:dio_project/service/storge/auth_storage.dart';
import 'package:dio_project/widgets/categories_stripe_widget.dart';
import 'package:dio_project/widgets/gridview_stripe_widget.dart';
import 'package:dio_project/widgets/header_wdget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dioprovider = ref.watch(dioProvider);
    final storageProvider = ref.watch(stroageprovider);
    ref.listen<AsyncValue<List<ProductEntity>>>(productProvider, (
      previous,
      next,
    ) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${next.error}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final authStorage = storageProvider;

          final dio = dioprovider;

          // 2. تخزين توكن منتهي الصلاحية عمداً بالـ Storage قبل إرسال الطلبات
          await authStorage.saveToken(
            StorageKeys.accessToken,
            "EXPIRED_TOKEN_123",
          );

          print('🚀 Sending 3 parallel requests with expired token...');

          // 3. إرسال 3 طلبات متوازية في نفس اللحظة بـ Future.wait
          try {
          Future.wait([
    dio.get('https://api.escuelajs.co/api/v1/auth/profile'),
    dio.get('https://api.escuelajs.co/api/v1/auth/profile'),
    dio.get('https://api.escuelajs.co/api/v1/auth/profile'),
  ]);

            // print(
            //   '✅ Success! Replayed ${results.length} requests successfully.',
            // );
          } catch (e) {
            print('❌ Request failed: $e');
          }
        },
      ),
      backgroundColor: const Color(0xFF212121),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isNarrow = constraints.maxWidth <= 430;
            final int columns = isNarrow ? 2 : 3;
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isNarrow ? 12 : 24,
                vertical: 14,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderWdget(),
                  const SizedBox(height: 16),
                  CategoriesStripeWidget(),
                  const SizedBox(height: 16),
                  GridviewStripeWidget(columns: columns, isNarrow: isNarrow),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
