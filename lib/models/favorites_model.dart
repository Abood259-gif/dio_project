


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio_project/entities/favorites_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'favorites_model.freezed.dart';
part 'favorites_model.g.dart';

@freezed
abstract class FavoriteModel with _$FavoriteModel {
  const FavoriteModel._();

  const factory FavoriteModel({
    required String productId,
    required String title,
    required String image,
    required double price,
  }) = _FavoriteModel;

  factory FavoriteModel.fromJson(Map<String, dynamic> json) =>
      _$FavoriteModelFromJson(json);

  factory FavoriteModel.fromFirestore(Map<String, dynamic> data) {
    return FavoriteModel(
      productId: data['productId'] as String,
      title: data['title'] as String,
      image: data['image'] as String,
      price: (data['price'] as num).toDouble(),
    );
  }

  FavoriteEntity toEntity() {
    return FavoriteEntity(
      productId: productId,
      title: title,
      image: image,
      price: price,
    );
  }

  factory FavoriteModel.fromProductEntity(dynamic product) {
    return FavoriteModel(
      productId: product.id.toString(),
      title: product.name ?? product.title,
      image: product.image,
      price: (product.price as num).toDouble(),
    );
  }

  Map<String, dynamic> toFirestoreMap() {
    return {
      'productId': productId,
      'title': title,
      'image': image,
      'price': price,
      'addedAt': FieldValue.serverTimestamp(),
    };
  }
}