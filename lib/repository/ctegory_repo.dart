import 'package:dio_project/entities/category_entity.dart';
import 'package:dio_project/models/category_model.dart';
import 'package:dio_project/provider/dio_provider.dart';
import 'package:dio_project/service/app_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CtegoryRepo {
  final AppService appService;
  CtegoryRepo({required this.appService});
  Future<List<CategoryEntity>> fetchCategory() async {
    final List<CategoryModel> response = await appService.fetchCategories();
    final data = response
        .map((categoryModel) => categoryModel.toEntity())
        .toList();
    return data;
  }
}
final categoryRepoProvider = Provider<CtegoryRepo>((ref) {
  final dio = ref.watch(dioProvider);
  return CtegoryRepo(appService: AppService(dio: dio));
});
