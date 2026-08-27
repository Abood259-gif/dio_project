import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio_project/entities/product_entity.dart';
import 'package:dio_project/provider/base_pagination_provider.dart';
import 'package:dio_project/repository/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchProductsProvider extends BasePaginationProvider {
  CancelToken? _cancelToken;
  String _searchQuery = '';
  @override
  Future<List<ProductEntity>> build() async {
    _searchQuery = ref.watch(searchQueryProvider);
    ref.onDispose(() {
      _cancelToken?.cancel('Provider disposed');
    });
    return super.build();
  }

  @override
  Future<List<ProductEntity>> fetchitems({
    required int offiset,
    required int limit,
  }) {
    if (_cancelToken != null && !_cancelToken!.isCancelled) {
      _cancelToken!.cancel(
        'Request cancelled by new search query: $_searchQuery',
      );
      log('Request cancelled by new search query: $_searchQuery');
    }
    _cancelToken = CancelToken();
    final productRepo = ref.read(producRepoProvider);
    return productRepo.getPaginatedProducts(
      offset: offiset,
      limit: limit,
      searchQuery: _searchQuery,
      canceltoken: _cancelToken
    );
  }
}

final searchProductsProvider =
    AsyncNotifierProvider.autoDispose<
      SearchProductsProvider,
      List<ProductEntity>
    >(SearchProductsProvider.new);

final searchQueryProvider = StateProvider<String>((ref) => '');
