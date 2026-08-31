

import 'package:freezed_annotation/freezed_annotation.dart';
part 'favorites_entity.freezed.dart';

@freezed
abstract class FavoriteEntity with _$FavoriteEntity {
  const factory FavoriteEntity({
    required String productId,
    required String title,
    required String image,
    required double price,
  }) = _FavoriteEntity;
}