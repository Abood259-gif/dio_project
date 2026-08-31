

import 'package:dio_project/entities/favorites_entity.dart';
import 'package:dio_project/provider/fav_provider.dart';
import 'package:dio_project/widgets/favorite_gridview_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<List<FavoriteEntity>>>(favoritesProvider, (
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

    return SafeArea(
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
                const Text(
                  'Favorites',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: FavoriteGridviewWidget(
                    favoritesState: ref.watch(favoritesProvider),
                    columns: columns,
                    isNarrow: isNarrow,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}