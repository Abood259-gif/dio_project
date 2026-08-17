import 'package:dio_project/entities/product_entity.dart';
import 'package:dio_project/models/category_model.dart';
import 'package:dio_project/provider/dio_provider.dart';
import 'package:dio_project/service/app_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProducRepo {
  final AppService appser;
  ProducRepo({required this.appser});
  Future<List<ProductEntity>> getProducts() async {
    try {
      final products = await appser.fetchProducts();
      final List<ProductEntity> productEntities = products
          .map((productModel) => productModel.toEntity())
          .toList();
      return productEntities;
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<List<CategoryModel>> getCategories() async {
    try {
      final categories = await appser.fetchCategories();
      return categories;
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }
}

final producRepoProvider = Provider<ProducRepo>((ref) {
 final dio =  ref.watch(dioProvider);
  return ProducRepo(appser: AppService(dio: dio));
});
