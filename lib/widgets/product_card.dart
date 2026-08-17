import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio_project/entities/product_entity.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onAddToCart,
  });

  final ProductEntity product;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isCompact = constraints.maxWidth < 185;
        final double titleFont = isCompact ? 16 : 18;
        final double priceFont = isCompact ? 18 : 20;
        final double addButtonSize = isCompact ? 34 : 42;

        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF2F2F2F),
            borderRadius: BorderRadius.circular(24),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    onTap();
                  },
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final cacheWidth = (constraints.maxWidth * MediaQuery.devicePixelRatioOf(context)).round();
                      return CachedNetworkImage(
                        memCacheWidth: cacheWidth,
                        fit: BoxFit.cover,
                        imageUrl: product.images.firstOrNull ?? 'https://via.placeholder.com/150',
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: titleFont,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),

                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '\$${product.price.toStringAsFixed(0)}',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: priceFont,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            onAddToCart();
                          },
                          child: Container(
                            height: addButtonSize,
                            width: addButtonSize,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2E8B57),
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: isCompact ? 22 : 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
