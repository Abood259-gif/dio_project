



import 'package:dio_project/entities/category_entity.dart';
import 'package:dio_project/repository/ctegory_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



final selectCategoryProvider = FutureProvider<List<CategoryEntity>>((ref) async {
  final categoryRepo = ref.watch(categoryRepoProvider);
  return await categoryRepo.fetchCategory();
});