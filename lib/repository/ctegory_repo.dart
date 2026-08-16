import 'package:dio_project/entities/category_entity.dart';
import 'package:dio_project/models/category_model.dart';
import 'package:dio_project/service/app_service.dart';

class CtegoryRepo {
  Future<List<CategoryEntity>> fetchCategory() async {
    final List<CategoryModel> response = await AppService.fetchCategories();
    final data = response.map((categoryModel) => categoryModel.toEntity()).toList();
    return data;
  }
}
