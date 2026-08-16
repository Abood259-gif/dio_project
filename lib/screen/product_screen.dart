
import 'package:dio_project/entities/category_entity.dart';
import 'package:dio_project/entities/product_entity.dart';
import 'package:dio_project/provider/category_index.dart';
import 'package:dio_project/provider/category_provider.dart';
import 'package:dio_project/provider/filter_product_provider.dart';
import 'package:dio_project/provider/product_provider.dart';
import 'package:dio_project/widgets/product_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';


class ProductsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<List<ProductEntity>>>(product_ProudctProvider, (
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
    final prductasyncValue = ref.watch(product_ProudctProvider);
    final int selectedCategoryIndex = ref.watch(selectedCategoryIndexProvider);
     final Category = ref.watch(selectCategoryProvider);
      final filterdProducts = ref.watch(filterProudctProvider);
    print('Building ProductsScreen');
    return Scaffold(
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
                  const Text(
                    'Explore',
                    style: TextStyle(
                      color: Color(0xFF818181),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'All Products',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 42,
                            fontWeight: FontWeight.w800,
                            height: 1.05,
                          ),
                        ),
                      ),
                      Container(
                        height: 52,
                        width: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2D2D2D),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.tune,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      hintStyle: const TextStyle(color: Color(0xFF8B8B8B)),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF8B8B8B),
                      ),
                      filled: true,
                      fillColor: const Color(0xFF2D2D2D),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFF3B3B3B)),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFF5A5A5A)),
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 48,
                    child: Category.when(
                      data: (categorys) {
                        return ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final bool isSelected =
                                index == selectedCategoryIndex;
                            return GestureDetector(
                              onTap: () {
                                ref
                                    .read(
                                      selectedCategoryIndexProvider.notifier,
                                    )
                                    .setSelectedCategoryIndex(index);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 22,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF4565C6)
                                      : const Color(0xFF2F2F2F),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Center(
                                  child: Text(
                                    categorys[index].name,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : const Color(0xFFA3A3A3),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 10),
                          itemCount: categorys.length,
                        );
                      },
                      loading: () => Skeletonizer(
                        child: SizedBox(
                          height: 48,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Container(
                                width: 100,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2F2F2F),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 10),
                            itemCount: 5,
                          ),
                        ),
                      ),
                      error: (error, stackTrace) => Center(
                        child: Text(
                          'Error loading categories: $error',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: prductasyncValue.when(
                      data: (productlist) {
                        return GridView.builder(
                          itemCount: filterdProducts.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: columns,
                                crossAxisSpacing: isNarrow ? 10 : 12,
                                mainAxisSpacing: isNarrow ? 10 : 12,
                                childAspectRatio: isNarrow ? 0.64 : 0.68,
                              ),
                          itemBuilder: (context, index) {
                            final ProductEntity product = filterdProducts[index];
                            return ProductCard(
                              onAddToCart: () {
                                print(
                                  'Adding product to cart: ${product.name}',
                                );
                               
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
                        enabled: true, // تفعيل تأثير الـ Skeleton
                        child: GridView.builder(
                          itemCount:
                              6, // عدد العناصر الوهمية التي تريد عرضها أثناء التحميل
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: columns,
                                crossAxisSpacing: isNarrow ? 10 : 12,
                                mainAxisSpacing: isNarrow ? 10 : 12,
                                childAspectRatio: isNarrow ? 0.64 : 0.68,
                              ),
                          itemBuilder: (context, index) {
                            // نمرر نفس كارت المنتج المعتاد، لكن ببيانات وهمية (Dummy Data)
                            return ProductCard(
                              onAddToCart: () {},
                              onTap: () {},
                              product: ProductEntity(
                                id: 1,
                                name:
                                    'اسم منتج وهمي للعرض فقط', // طول النص يحدد طول شريط الـ Skeleton
                                description: 'وصف وهمي',
                                price: 99.99,
                                images: ['https://cdn-icons-png.flaticon.com/512/5821/5821423.png'], // صورة وهمية
                                slug: 'slug',
                                category: CategoryEntity(id: 1, name: 'فئة وهمية', slug: 'slug', image: ''),
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
                              style: TextStyle(
                                
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                               
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}