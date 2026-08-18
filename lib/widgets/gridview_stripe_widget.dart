import 'package:dio_project/entities/category_entity.dart';
import 'package:dio_project/entities/product_entity.dart';
import 'package:dio_project/provider/category_provider.dart';
import 'package:dio_project/provider/filter_product_provider.dart';
import 'package:dio_project/provider/product_provider.dart';
import 'package:dio_project/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class GridviewStripeWidget extends ConsumerWidget {
  const GridviewStripeWidget({
    super.key,
    required this.columns,
    required this.isNarrow,
  });
  final int columns;
  final bool isNarrow;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterdProducts = ref.watch(filteredProductsProvider);
    return Expanded(
      child: filterdProducts.when(
        data: (productlist) {
          if (productlist.isEmpty) {
            return const Center(
              child: Text(
                'No products found.',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            );
          }
          return GridView.builder(
            itemCount: productlist.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: isNarrow ? 10 : 12,
              mainAxisSpacing: isNarrow ? 10 : 12,
              childAspectRatio: isNarrow ? 0.64 : 0.68,
            ),
            itemBuilder: (context, index) {
              final ProductEntity product = productlist[index];
              return ProductCard(
                onAddToCart: () {
                  print('Adding product to cart: ${product.name}');
                },
                onTap: () {
                  print('Tapped on product: ${product.name}');
                },
                product: product,
              );
            },
          );
        },
        loading: () => Skeletonizer(
          enabled: true,
          child: GridView.builder(
            itemCount: 6,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: isNarrow ? 10 : 12,
              mainAxisSpacing: isNarrow ? 10 : 12,
              childAspectRatio: isNarrow ? 0.64 : 0.68,
            ),
            itemBuilder: (context, index) {
              return ProductCard(
                onAddToCart: () {},
                onTap: () {},
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
      ),
    );
  }
}
