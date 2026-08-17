
import 'package:dio_project/entities/category_entity.dart';
import 'package:dio_project/entities/product_entity.dart';
import 'package:dio_project/provider/category_index.dart';
import 'package:dio_project/provider/category_provider.dart';
import 'package:dio_project/provider/filter_product_provider.dart';
import 'package:dio_project/provider/product_provider.dart';
import 'package:dio_project/widgets/categories_stripe_widget.dart';
import 'package:dio_project/widgets/gridview_stripe_widget.dart';
import 'package:dio_project/widgets/header_wdget.dart';
import 'package:dio_project/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';


class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref)  {
    ref.listen<AsyncValue<List<ProductEntity>>>(productProvider, (
      previous,
      next,
    ) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${next.error}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
    return Scaffold(
      backgroundColor: const Color(0xFF212121),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isNarrow = constraints.maxWidth <= 430;
            final int columns = isNarrow ? 2 : 3;
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isNarrow ? 12 : 24,
                vertical: 14,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderWdget() , 
                  const SizedBox(height: 16),
                 CategoriesStripeWidget() ,
                  const SizedBox(height: 16),
                GridviewStripeWidget(columns: columns, isNarrow: isNarrow),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}