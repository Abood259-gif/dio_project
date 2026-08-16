import 'package:dio/dio.dart';
import 'package:dio_project/models/category_model.dart';
import 'package:dio_project/models/product_model.dart';
import 'package:dio_project/service/dio_handler.dart';

class AppService {
  final Dio dio = DioHandler().dio;
static const String productUrl = 'https://api.escuelajs.co/api/v1/products';
static const String categoryUrl = 'https://api.escuelajs.co/api/v1/categories';
  static Future<List<ProductModel>> fetchProducts() async {
    try {
      final response = await DioHandler().dio.get(
        productUrl,
      );
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

static Future<List<CategoryModel>> fetchCategories() async {
    try {
      final response = await DioHandler().dio.get(
       categoryUrl,
      );
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
