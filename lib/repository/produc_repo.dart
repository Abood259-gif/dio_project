

import 'package:dio_project/entities/product_entity.dart';
import 'package:dio_project/models/category_model.dart';
import 'package:dio_project/service/app_service.dart';

class ProducRepo {

Future<List<ProductEntity>> getProducts() async {
    try {
      final products = await AppService.fetchProducts();
     final List<ProductEntity> productEntities = products.map((productModel) => productModel.toEntity()).toList();
      return productEntities;
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<List<CategoryModel>> getCategories() async {
    try {
      final categories = await AppService.fetchCategories();
      return categories;
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  } 

}