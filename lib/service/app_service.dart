import 'package:dio/dio.dart';
import 'package:dio_project/models/category_model.dart';
import 'package:dio_project/models/product_model.dart';


class AppService {
  final Dio dio;
  AppService({required this.dio});
   Future<List<ProductModel>> fetchProducts({CancelToken? cancletoken}) async {
    try {
      final response = await dio.get('products' ,
                        cancelToken: cancletoken
      );
        final List<dynamic> data = response.data;
        return data.map((json) => ProductModel.fromJson(json)).toList();
    } on DioException catch (e) {
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
}
