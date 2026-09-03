import 'dart:async';

import 'package:dio_project/entities/category_entity.dart';
import 'package:dio_project/repository/category_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryNotifier extends AutoDisposeAsyncNotifier<List<CategoryEntity>> {
  @override
  FutureOr<List<CategoryEntity>> build() async {
    final categoryRepo = ref.watch(categoryRepoProvider);
    final List<CategoryEntity> data = await categoryRepo.fetchCategories();
    final List<CategoryEntity> resault = [
      CategoryEntity(id: 0, name: 'All', slug: '', image: ''),
      ...data,
    ];
    return resault;
  }

  Future<void> refreshcategory() async {
    state = const AsyncValue.loading();
    try {
      final categoryRepo = ref.watch(categoryRepoProvider);
      final List<CategoryEntity> data = await categoryRepo.fetchCategories();
      final List<CategoryEntity> resault = [
        CategoryEntity(id: 0, name: 'All', slug: '', image: ''),
        ...data,
      ];
      state = AsyncValue.data(resault);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final selectCategoryProvider =
    AsyncNotifierProvider.autoDispose<CategoryNotifier, List<CategoryEntity>>(
      CategoryNotifier.new,
    );
