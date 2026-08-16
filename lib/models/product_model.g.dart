// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductModel _$ProductModelFromJson(Map<String, dynamic> json) =>
    _ProductModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      slug: json['slug'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      images: json['images'] == null ? const [] : _parseImages(json['images']),
      category: CategoryModel.fromJson(
        json['category'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$ProductModelToJson(_ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'slug': instance.slug,
      'price': instance.price,
      'description': instance.description,
      'images': instance.images,
      'category': instance.category,
    };
