

import 'package:dio_project/entities/category_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_entity.freezed.dart';

@freezed
abstract class ProductEntity with _$ProductEntity {
  const factory ProductEntity({
    required int id,
    required String name,
    required String slug,
    required double price,
    required String description,
    required List<String> images,
    required CategoryEntity category,
  }) = _ProductEntity;
}