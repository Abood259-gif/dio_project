


import 'package:dio_project/entities/product_entity.dart';
import 'package:dio_project/models/product_model.dart';
import 'package:dio_project/repository/produc_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final product_ProudctProvider = FutureProvider<List<ProductEntity>>((ref) async {
  final productRepo = ProducRepo();
  return await productRepo.getProducts();
});