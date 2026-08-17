import 'package:dio/dio.dart';
import 'package:dio_project/models/category_model.dart';
import 'package:dio_project/models/product_model.dart';


class AppService {
  final Dio dio;
  AppService({required this.dio});
   Future<List<ProductModel>> fetchProducts() async {
    try {
      final response = await dio.get('products');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

   Future<List<CategoryModel>> fetchCategories() async {
    try {
      final response = await dio.get('categories');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => CategoryModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }
}
