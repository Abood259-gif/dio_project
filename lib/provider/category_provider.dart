



import 'package:dio_project/entities/category_entity.dart';
import 'package:dio_project/repository/ctegory_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class SelectCategoryNotifier extends AsyncNotifier<List<CategoryEntity>> {
  final repo = CtegoryRepo();
  @override
  Future<List<CategoryEntity>> build() async {
    return featchCategory();
  }

Future<List<CategoryEntity>> featchCategory() async {
  await Future.delayed(const Duration(seconds: 2));
  return repo.fetchCategory();
}


}
final selectCategoryProvider = AsyncNotifierProvider<SelectCategoryNotifier, List<CategoryEntity>>(() {
  return SelectCategoryNotifier();
});