

import 'package:dio_project/entities/category_entity.dart';

class ProductEntity {

final int id;
final String name;
final String slug;
final double price;
final String description;
final List<String> images;
final CategoryEntity category;
  ProductEntity({
    required this.id,
    required this.name,
    required this.slug,
    required this.price,
    required this.description,
    required this.images,
    required this.category,
  });

}