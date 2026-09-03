// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favorites_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FavoriteEntity {

 String get productId; String get title; String get image; double get price;
/// Create a copy of FavoriteEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FavoriteEntityCopyWith<FavoriteEntity> get copyWith => _$FavoriteEntityCopyWithImpl<FavoriteEntity>(this as FavoriteEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoriteEntity&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.title, title) || other.title == title)&&(identical(other.image, image) || other.image == image)&&(identical(other.price, price) || other.price == price));
}


@override
int get hashCode => Object.hash(runtimeType,productId,title,image,price);

@override
String toString() {
  return 'FavoriteEntity(productId: $productId, title: $title, image: $image, price: $price)';
}


}

/// @nodoc
abstract mixin class $FavoriteEntityCopyWith<$Res>  {
  factory $FavoriteEntityCopyWith(FavoriteEntity value, $Res Function(FavoriteEntity) _then) = _$FavoriteEntityCopyWithImpl;
@useResult
$Res call({
 String productId, String title, String image, double price
});




}
/// @nodoc
class _$FavoriteEntityCopyWithImpl<$Res>
    implements $FavoriteEntityCopyWith<$Res> {
  _$FavoriteEntityCopyWithImpl(this._self, this._then);

  final FavoriteEntity _self;
  final $Res Function(FavoriteEntity) _then;

/// Create a copy of FavoriteEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? title = null,Object? image = null,Object? price = null,}) {
  return _then(FavoriteEntity(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [FavoriteEntity].
extension FavoriteEntityPatterns on FavoriteEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FavoriteEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FavoriteEntity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FavoriteEntity value)  $default,){
final _that = this;
switch (_that) {
case _FavoriteEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FavoriteEntity value)?  $default,){
final _that = this;
switch (_that) {
case _FavoriteEntity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String productId,  String title,  String image,  double price)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FavoriteEntity() when $default != null:
return $default(_that.productId,_that.title,_that.image,_that.price);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String productId,  String title,  String image,  double price)  $default,) {final _that = this;
switch (_that) {
case _FavoriteEntity():
return $default(_that.productId,_that.title,_that.image,_that.price);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String productId,  String title,  String image,  double price)?  $default,) {final _that = this;
switch (_that) {
case _FavoriteEntity() when $default != null:
return $default(_that.productId,_that.title,_that.image,_that.price);case _:
  return null;

}
}

}

/// @nodoc


class _FavoriteEntity implements FavoriteEntity {
  const _FavoriteEntity({required this.productId, required this.title, required this.image, required this.price});
  

@override final  String productId;
@override final  String title;
@override final  String image;
@override final  double price;

/// Create a copy of FavoriteEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FavoriteEntityCopyWith<_FavoriteEntity> get copyWith => __$FavoriteEntityCopyWithImpl<_FavoriteEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FavoriteEntity&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.title, title) || other.title == title)&&(identical(other.image, image) || other.image == image)&&(identical(other.price, price) || other.price == price));
}


@override
int get hashCode => Object.hash(runtimeType,productId,title,image,price);

@override
String toString() {
  return 'FavoriteEntity(productId: $productId, title: $title, image: $image, price: $price)';
}


}

/// @nodoc
abstract mixin class _$FavoriteEntityCopyWith<$Res> implements $FavoriteEntityCopyWith<$Res> {
  factory _$FavoriteEntityCopyWith(_FavoriteEntity value, $Res Function(_FavoriteEntity) _then) = __$FavoriteEntityCopyWithImpl;
@override @useResult
$Res call({
 String productId, String title, String image, double price
});




}
/// @nodoc
class __$FavoriteEntityCopyWithImpl<$Res>
    implements _$FavoriteEntityCopyWith<$Res> {
  __$FavoriteEntityCopyWithImpl(this._self, this._then);

  final _FavoriteEntity _self;
  final $Res Function(_FavoriteEntity) _then;

/// Create a copy of FavoriteEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? title = null,Object? image = null,Object? price = null,}) {
  return _then(_FavoriteEntity(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
