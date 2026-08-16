


import 'package:dio_project/entities/product_entity.dart';
import 'package:dio_project/models/category_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'product_model.freezed.dart';
part 'product_model.g.dart';
List<String> _parseImages(dynamic rawImages) {
  if (rawImages == null || rawImages is! List) return ['https://placehold.co/600x400'];
  return rawImages
      .where((item) => item != null)
      .map((item) => item.toString())
      .toList();
}

@Freezed()
 abstract class ProductModel with _$ProductModel   {
   const ProductModel._();
  const factory ProductModel({
    required int id ,
    required String title,
    required String slug,
    required double price,
  required   String description,
   @JsonKey(fromJson: _parseImages) @Default([]) List<String> images,
    required CategoryModel category,
  }) = _ProductModel;




factory ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);

ProductEntity toEntity() {
  return ProductEntity(
    id: id,
    name: title,
    slug: slug,
    category: category.toEntity(), 
    price: price, 
    description: description, 
    images: images,
  );
}

  }

