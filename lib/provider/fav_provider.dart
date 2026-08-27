import 'dart:async';

import 'package:dio_project/repository/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavNotifier extends AutoDisposeAsyncNotifier<Set<int>> {
  @override
  FutureOr<Set<int>> build() {
    return {};
  }

  Future<void> toggleFav(int productId) async {
    final currentFavs = state.value ?? {};
    final isFav = currentFavs.contains(productId);
  final updatedFavs = Set<int>.from(currentFavs);
    if (isFav) {
      updatedFavs.remove(productId);
    } else {
      updatedFavs.add(productId);
    }
    state = AsyncValue.data(updatedFavs);
    try {
      
      await ref.read(producRepoProvider).getProductById(productId);
      
    } catch (e) {
      state = AsyncData(currentFavs);
      rethrow; 
    }
  }
  }

final favoriteProductsProvider =
    AsyncNotifierProvider.autoDispose<FavNotifier, Set<int>>(
 FavNotifier.new,
);
