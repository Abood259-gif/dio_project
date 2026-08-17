


import 'package:dio_project/entities/product_entity.dart';

abstract class ProductRepositoryInterface {
  Future<List<ProductEntity>> getProducts() ;
}
