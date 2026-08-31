


import 'package:dio_project/entities/favorites_entity.dart';
import 'package:dio_project/provider/fav_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteGridviewWidget extends ConsumerWidget {
  const FavoriteGridviewWidget({
    super.key,
    required this.favoritesState,
    required this.columns,
    required this.isNarrow,
  });

  final AsyncValue<List<FavoriteEntity>> favoritesState;
  final int columns;
  final bool isNarrow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return favoritesState.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
      error: (e, _) => Center(
        child: Text('Failed to load favorites', style: TextStyle(color: Colors.white.withOpacity(0.7))),
      ),
      data: (favorites) {
        if (favorites.isEmpty) {
          return Center(
            child: Text(
              'No favorites yet',
              style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 16),
            ),
          );
        }
        return GridView.builder(
          itemCount: favorites.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.68,
          ),
          itemBuilder: (context, index) {
            final favorite = favorites[index];
            return _FavoriteCard(favorite: favorite);
          },
        );
      },
    );
  }
}

class _FavoriteCard extends ConsumerWidget {
  const _FavoriteCard({required this.favorite});
  final FavoriteEntity favorite;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.network(favorite.image, fit: BoxFit.cover, width: double.infinity),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  favorite.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.favorite, color: Colors.redAccent, size: 22),
                      onPressed: () {
                        ref
                            .read(favoriteActionsProvider.notifier)
                            .removeFavorite(favorite.productId);
                      },
                    ),
                    Text(
                      '\$${favorite.price}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}