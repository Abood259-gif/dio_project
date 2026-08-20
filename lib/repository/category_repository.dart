import 'package:dio_project/entities/category_entity.dart';
import 'package:dio_project/models/category_model.dart';
import 'package:dio_project/provider/dio_provider.dart';
import 'package:dio_project/service/network/app_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryRepository {
  final AppService appService;
  CategoryRepository({required this.appService});
  Future<List<CategoryEntity>> fetchCategories() async {
    final List<CategoryModel> response = await appService.fetchCategories();
    final data = response
        .map((categoryModel) => categoryModel.toEntity())
        .toList();
    return data;
  }
}
final categoryRepoProvider = Provider<CategoryRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return CategoryRepository(appService: AppService(dio: dio));
});
