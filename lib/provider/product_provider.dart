




import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio_project/entities/product_entity.dart';
import 'package:dio_project/repository/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductNotifier extends AutoDisposeAsyncNotifier<List<ProductEntity>> {
  @override
 Future<List<ProductEntity>> build() async {
    final productRepo = ref.watch(producRepoProvider);
    CancelToken cancelToken = CancelToken();
    ref.onDispose(() {
      log('ProductNotifier disposed and cancelToken canceled');
      cancelToken.cancel ();
    });
     return await productRepo.getProducts();
  }
  Future<void> refreshProducts() async {
    state = const AsyncValue.loading();
    try {
      final productRepo = ref.watch(producRepoProvider);
      final products = await productRepo.getProducts();
      state = AsyncValue.data(products);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final productProvider = 
AsyncNotifierProvider.autoDispose<ProductNotifier,List<ProductEntity>>(ProductNotifier.new);
