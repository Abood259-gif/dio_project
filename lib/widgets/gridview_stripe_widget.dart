import 'dart:developer';

import 'package:dio_project/entities/category_entity.dart';
import 'package:dio_project/entities/favorites_entity.dart';
import 'package:dio_project/entities/product_entity.dart';
import 'package:dio_project/provider/category_provider.dart';
import 'package:dio_project/provider/fav_provider.dart';
import 'package:dio_project/provider/product_provider.dart';
import 'package:dio_project/screen/welcome_screen.dart';
import 'package:dio_project/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/rendering.dart';
import 'package:skeletonizer/skeletonizer.dart';

class GridviewStripeWidget extends ConsumerStatefulWidget {
  const GridviewStripeWidget({
    super.key,
    required this.columns,
    required this.isNarrow,
    required this.productProvider,
    required this.getProducts,
    required this.hasmore,
  });

  @override
  ConsumerState<GridviewStripeWidget> createState() =>
      GridviewStripeWidgetState();
  final int columns;
  final bool isNarrow;
  final AsyncValue<List<ProductEntity>> productProvider;
  final VoidCallback getProducts;
  final bool hasmore;
}

class GridviewStripeWidgetState extends ConsumerState<GridviewStripeWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!widget.hasmore || widget.productProvider.isLoading) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 50) {
      widget.getProducts();
    }
  }

  @override
  void dispose() {
    log('Disposing GridviewStripeWidgetState and removing scroll listener');
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TEMP DEBUG — remove once favorites work, tells us exactly why a toggle failed
    ref.listen(favoriteActionsProvider, (previous, next) {
      if (next.hasError) {
        log('FAVORITE TOGGLE FAILED: ${next.error}');
      }
    });

    final favoriteIds =
        ref.watch(favoritesProvider).value?.map((f) => f.productId).toSet() ??
        <String>{};

    return widget.productProvider.when(
      skipError: true,
      data: (productlist) {
        if (productlist.isEmpty) {
          return const Center(
            child: Text(
              'No products found.',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          );
        }
        return Column(
          children: [
            Expanded(
              child: GridView.builder(
                controller: _scrollController,
                scrollCacheExtent: ScrollCacheExtent.pixels(300),
                addAutomaticKeepAlives: false,
                itemCount: productlist.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: widget.columns,
                  crossAxisSpacing: widget.isNarrow ? 10 : 12,
                  mainAxisSpacing: widget.isNarrow ? 10 : 12,
                  childAspectRatio: widget.isNarrow ? 0.64 : 0.68,
                ),
                itemBuilder: (context, index) {
                  final ProductEntity product = productlist[index];
                  final isFav = favoriteIds.contains(product.id.toString());

                  return ProductCard(
                    isFav: isFav,
                    onFavToggle: () async {
                      final favorite = FavoriteEntity(
                        productId: product.id.toString(),
                        title: product.name,
                        image: product.images.isNotEmpty
                            ? product.images.first
                            : '',
                        price: product.price,
                      );
                      await ref
                          .read(favoriteActionsProvider.notifier)
                          .toggleFavorite(favorite);

                      final actionState = ref.read(favoriteActionsProvider);
                      if (actionState.hasError && context.mounted) {
                        final messenger = ScaffoldMessenger.of(context);
                        messenger.hideCurrentSnackBar();
                        messenger.showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Failed to update favorite. Please try again.',
                            ),
                          ),
                        );
                      }
                    },
                    onAddToCart: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WelcomeScreen(),
                        ),
                      );
                    },
                    onTap: () {},
                    product: product,
                  );
                },
              ),
            ),
            widget.productProvider.isLoading
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: CircularProgressIndicator(),
                  )
                : (!widget.hasmore
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            'No more products to load.',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        )
                      : const SizedBox.shrink()),
          ],
        );
      },
      loading: () => Skeletonizer(
        enabled: true,
        child: GridView.builder(
          itemCount: 6,
          scrollCacheExtent: ScrollCacheExtent.pixels(300),
          addAutomaticKeepAlives: false,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.columns,
            crossAxisSpacing: widget.isNarrow ? 10 : 12,
            mainAxisSpacing: widget.isNarrow ? 10 : 12,
            childAspectRatio: widget.isNarrow ? 0.64 : 0.68,
          ),
          itemBuilder: (context, index) {
            return const ProductCard(
              product: ProductEntity(
                id: 1,
                name: 'اسم منتج وهمي للعرض فقط',
                description: 'وصف وهمي',
                price: 99.99,
                images: [
                  'https://cdn-icons-png.flaticon.com/512/5821/5821423.png',
                ],
                slug: 'slug',
                category: CategoryEntity(
                  id: 1,
                  name: 'فئة وهمية',
                  slug: 'slug',
                  image: '',
                ),
              ),
            );
          },
        ),
      ),
      error: (error, stackTrace) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Failed to load products.',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                ref.read(productProvider.notifier).refreshProducts();
                ref.read(selectCategoryProvider.notifier).refreshcategory();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
