



import 'package:dio_project/entities/category_entity.dart';
import 'package:dio_project/repository/category_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



final selectCategoryProvider = FutureProvider<List<CategoryEntity>>((ref) async {
  final categoryRepo = ref.watch(categoryRepoProvider);
  final List<CategoryEntity> data = await  categoryRepo.fetchCategories();
   final List<CategoryEntity> resault  = [CategoryEntity(id: 0, name: 'All', slug: '', image: ''),
 ...data];
  return resault; 
});