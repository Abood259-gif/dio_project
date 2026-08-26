import 'package:dio_project/provider/search_products_provider.dart';
import 'package:dio_project/widgets/gridview_stripe_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(searchQueryProvider);
    return SafeArea(
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
                const SizedBox(height: 16),
                Expanded(
                  child: GridviewStripeWidget(
                    hasmore: ref.watch(searchProductsProvider.notifier).hasMore,
                    getProducts: () {
                      ref
                          .read(searchProductsProvider.notifier)
                          .fetchPaginatedProducts();
                    },
                    productProvider: ref.watch(searchProductsProvider),
                    columns: columns,
                    isNarrow: isNarrow,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
