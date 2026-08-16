

import 'package:dio_project/entities/category_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'category_model.freezed.dart';
part 'category_model.g.dart';

@freezed
 abstract class CategoryModel with _$CategoryModel {
  const CategoryModel._();
  const factory CategoryModel({
    required int id,
    required String name,
    required String slug,
    required String image,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);


  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      name: name,
      slug: slug,
      image: image,
    );
  }
}