import 'package:dio_project/entities/product_entity.dart';
import 'package:dio_project/provider/base_pagination_provider.dart';
import 'package:dio_project/provider/category_index.dart';
import 'package:dio_project/repository/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductNotifier extends BasePaginationProvider {
  int? _categoryId;
  @override
  Future<List<ProductEntity>> build() async {
   _categoryId = ref.watch(selectedCategoryIndexProvider);
    super.offset = 0;
   return  super.build();
  }

  @override
  Future<List<ProductEntity>> fetchitems({
    required int offiset,
    required int limit,
  }) {
    print('Fetching products with offset: $offiset, limit: $limit');
    final productRepo = ref.read(producRepoProvider);
    return productRepo.getPaginatedProducts(
      offset: offiset,
      limit: limit,
      categoryId: _categoryId == 0 ? null : _categoryId,
    );
  }

  Future<void> refreshProducts() async {
    state = const AsyncValue.loading();
    try {
      final productRepo = ref.read(producRepoProvider);
      final products = await productRepo.getProducts();
      state = AsyncValue.data(products);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final productProvider =
    AsyncNotifierProvider.autoDispose<ProductNotifier, List<ProductEntity>>(
      ProductNotifier.new,
    );
