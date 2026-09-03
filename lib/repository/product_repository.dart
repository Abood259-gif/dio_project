import 'package:dio/dio.dart';
import 'package:dio_project/entities/product_entity.dart';
import 'package:dio_project/provider/dio_provider.dart';
import 'package:dio_project/repository/product_repository_interface.dart';
import 'package:dio_project/service/network/app_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProducRepo implements ProductRepositoryInterface {
  final AppService appser;
  ProducRepo({required this.appser});
  @override
  Future<List<ProductEntity>> getProducts({CancelToken? cancletoken}) async {
    final products = await appser.fetchProducts(cancletoken: cancletoken);
    final List<ProductEntity> productEntities = products
        .map((productModel) => productModel.toEntity())
        .toList();
    return productEntities;
  }

  Future<List<ProductEntity>> getPaginatedProducts({
    required int offset,
    required int limit,
    String? searchQuery,
    int? categoryId,
    CancelToken? canceltoken,
  }) async {
    final products = await appser.fetchPaginatedProducts(
      offset: offset,
      limit: limit,
      searchQuery: searchQuery,
      categoryId: categoryId,
      cancletoken: canceltoken,
    );
    final List<ProductEntity> productEntities = products
        .map((productModel) => productModel.toEntity())
        .toList();
    return productEntities;
  }

  Future<ProductEntity> getProductById(
    int productId, {
    CancelToken? cancletoken,
  }) async {
    final product = await appser.fetchProductById(
      productId,
      cancletoken: cancletoken,
    );
    return product.toEntity();
  }
}

final producRepoProvider = Provider.autoDispose<ProducRepo>((ref) {
  final dio = ref.watch(dioProvider);
  return ProducRepo(appser: AppService(dio: dio));
});
