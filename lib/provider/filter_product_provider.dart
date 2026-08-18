import 'package:dio_project/entities/category_entity.dart';
import 'package:dio_project/entities/product_entity.dart';
import 'package:dio_project/provider/category_index.dart';
import 'package:dio_project/provider/category_provider.dart';
import 'package:dio_project/provider/product_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final filteredProductsProvider = FutureProvider.autoDispose<List<ProductEntity>>((
  ref,
) async {
  final categoryindex = ref.watch(selectedCategoryIndexProvider);
  final categoryselected = ref.watch(selectCategoryProvider).value ?? [];
  final products = ref.watch(productProvider).value ?? [];

  if (categoryindex == 0 || categoryselected.isEmpty) {
    return products;
  }
  final data =  products
      .where((item) => item.category.id == categoryselected[categoryindex].id)
      .toList();
  return data;
});
