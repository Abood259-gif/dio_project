

import 'package:dio_project/entities/product_entity.dart';
import 'package:dio_project/provider/category_index.dart';
import 'package:dio_project/provider/category_provider.dart';
import 'package:dio_project/provider/product_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final filterProudctProvider = Provider<List<ProductEntity>>((ref)  {
  final categoryindex = ref.watch(selectedCategoryIndexProvider);
  final categoryselected =  ref.watch(selectCategoryProvider).value ?? [];
  final products = ref.watch(product_ProudctProvider).value ?? [];

if (categoryselected.isEmpty || 
      categoryindex < 0 || 
      categoryindex >= categoryselected.length) {
    return []; 
  }

  return products.where(
    (item) => item.category.name == categoryselected[categoryindex].name,
  ).toList();
});