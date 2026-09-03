import 'dart:async';

import 'package:dio_project/provider/search_products_provider.dart';
import 'package:dio_project/widgets/gridview_stripe_widget.dart';
import 'package:dio_project/widgets/search_screen_header.dart';
import 'package:dio_project/widgets/search_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  void _onSearchChanged(String value) {
    _debounceTimer?.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      final query = value.trim();
      ref.read(searchQueryProvider.notifier).state = query;
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
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
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  tooltip: 'Back',
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
              ),
              const SearchScreenHeader(),
              const SizedBox(height: 16),
              SearchTextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                onSubmitted: (value) {
                  _debounceTimer?.cancel();
                  ref.read(searchQueryProvider.notifier).state = value.trim();
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Consumer(
                  builder:
                      (BuildContext context, WidgetRef ref, Widget? child) {
                        return GridviewStripeWidget(
                          hasmore: ref
                              .watch(searchProductsProvider.notifier)
                              .hasMore,
                          getProducts: () {
                            ref
                                .read(searchProductsProvider.notifier)
                                .fetchPaginatedProducts();
                          },
                          productProvider: ref.watch(searchProductsProvider),
                          columns: columns,
                          isNarrow: isNarrow,
                        );
                      },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
