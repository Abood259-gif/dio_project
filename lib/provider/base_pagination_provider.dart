import 'package:dio_project/entities/product_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class BasePaginationProvider
    extends AutoDisposeAsyncNotifier<List<ProductEntity>> {
  int _offset = 0;
  final int _limit = 20;
  bool _hasMore = true;
  bool _isFetching = false;
bool get hasMore => _hasMore;
set offset(int value) => _offset = value;
  Future<List<ProductEntity>> fetchitems({
    required int offiset,
    required int limit,
   
  });

  @override
  Future<List<ProductEntity>> build() async {
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
    final products = await fetchitems(
      offiset: _offset,
      limit: _limit
    );
    try {
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
}
