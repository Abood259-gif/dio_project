import 'dart:async';

import 'package:dio_project/entities/favorites_entity.dart';
import 'package:dio_project/repository/favorites_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteActions extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    // no initial state to load — actions only
  }

  Future<void> toggleFavorite(FavoriteEntity favorite) async {
    final repository = ref.read(favoritesRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repository.toggleFavorite(favorite));
  }

  Future<void> addFavorite(FavoriteEntity favorite) async {
    final repository = ref.read(favoritesRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repository.addFavorite(favorite));
  }

  Future<void> removeFavorite(String productId) async {
    final repository = ref.read(favoritesRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repository.removeFavorite(productId));
  }
}

final favoriteActionsProvider =
    AsyncNotifierProvider<FavoriteActions, void>(FavoriteActions.new);

final favoritesProvider = StreamProvider<List<FavoriteEntity>>((ref) {
  final repository = ref.watch(favoritesRepositoryProvider);
  return repository.watchFavorites();
});
