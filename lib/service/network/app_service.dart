import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio_project/models/category_model.dart';
import 'package:dio_project/models/product_model.dart';

class AppService {
  final Dio dio;
  AppService({required this.dio});
  Future<List<ProductModel>> fetchProducts({CancelToken? cancletoken}) async {
    try {
      final response = await dio.get('products', cancelToken: cancletoken);
      final List<dynamic> data = response.data;
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<List<ProductModel>> fetchPaginatedProducts({
    required int offset,
    required int limit,
    String? searchQuery,
    int? categoryId,
    CancelToken? cancletoken,
  }) async {
    try {
      final response = await dio.get(
        'products',
        queryParameters: {
          'offset': offset,
          'limit': limit,
          if (searchQuery != null && searchQuery.isNotEmpty)
            'title': searchQuery,
          if (categoryId != null) 'categoryId': categoryId,
        },
        cancelToken: cancletoken,
      );
      final List<dynamic> data = response.data;
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        log('Request cancelled of the search query: $searchQuery');
      }
      throw Exception(e.message);
    }
  }

  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final response = await dio.get('categories');
      final List<dynamic> data = response.data;
      return data.map((json) => CategoryModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<ProductModel> fetchProductById(
    int productId, {
    CancelToken? cancletoken,
  }) async {
    try {
      final response = await dio.get(
        'products/$productId',
        cancelToken: cancletoken,
      );
       throw Exception('Simulated 500 Server Failure');
      final data = response.data;
      return ProductModel.fromJson(data);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}
