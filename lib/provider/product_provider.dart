import 'package:dio_project/entities/product_entity.dart';
import 'package:dio_project/provider/base_pagination_provider.dart';
import 'package:dio_project/provider/category_index.dart';
import 'package:dio_project/provider/category_provider.dart';
import 'package:dio_project/repository/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductNotifier extends BasePaginationProvider {
  int? _categoryId;
 
  @override
  Future<List<ProductEntity>> build() async {
 listenSelf((previous, next) {
      ref.read(hasmoreProvider.notifier).state = hasMore;
    });
    final categoryIndex = ref.watch(selectedCategoryIndexProvider);
    final categoryList = ref.watch(selectCategoryProvider).value ?? [];
    if (categoryIndex > 0 && categoryIndex < categoryList.length) {
      _categoryId = categoryList[categoryIndex].id;
    } else {
      _categoryId = null;
    }
    return super.build();
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
      categoryId: _categoryId,
    );
  }
}

final productProvider =
    AsyncNotifierProvider.autoDispose<ProductNotifier, List<ProductEntity>>(
      ProductNotifier.new,
    );
final hasmoreProvider = StateProvider.autoDispose<bool>((ref) => true);