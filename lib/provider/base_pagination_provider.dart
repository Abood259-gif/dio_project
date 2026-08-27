import 'package:dio_project/entities/product_entity.dart';
import 'package:dio_project/repository/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class BasePaginationProvider
    extends AutoDisposeAsyncNotifier<List<ProductEntity>> {
  int _offset = 0;
  final int _limit = 20;
  bool _hasMore = true;
  bool _isFetching = false;
bool get hasMore => _hasMore;
  Future<List<ProductEntity>> fetchitems({
    required int offiset,
    required int limit,
   
  });

  @override
  Future<List<ProductEntity>> build() async {
    _offset = 0;
    _hasMore = true;
    _isFetching = false;
    ref.onDispose(() {
      print('ProductsProvider was closed successfully!');
    });
  final initialProducts = await fetchitems(
      offiset: _offset,
      limit: _limit
    );
    if (initialProducts.isEmpty || initialProducts.length < _limit) {
      _hasMore = false;
    }
    _offset += _limit;
    return initialProducts;
  }

   Future<void> fetchPaginatedProducts() async {
    if (!_hasMore || state.isLoading || _isFetching) return;
    _isFetching = true;
    state =  const AsyncLoading<List<ProductEntity>>().copyWithPrevious(state);
    try {
       final products = await fetchitems(
      offiset: _offset,
      limit: _limit
    );
      if (products.isEmpty || products.length < _limit) {
        _hasMore = false;
      }

      _offset += _limit;

      final currentList = state.value ?? [];
      state = AsyncValue.data([...currentList, ...products]);
    } catch (e, st) {
      state = AsyncValue<List<ProductEntity>>.error(
        e,
        st,
      ).copyWithPrevious(state);
    } finally {
      _isFetching = false;
    }
  }

 Future<void> refreshProducts() async {
  _offset = 0;
  _hasMore = true;
  _isFetching = false;
    state = const AsyncValue.loading();
    try {
      final productRepo = ref.read(producRepoProvider);
      final products = await productRepo.getPaginatedProducts(offset: _offset, limit: _limit);
      state = AsyncValue.data(products);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

}
