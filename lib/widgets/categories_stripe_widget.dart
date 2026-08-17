import 'package:dio_project/provider/category_index.dart';
import 'package:dio_project/provider/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CategoriesStripeWidget extends ConsumerWidget {
  const CategoriesStripeWidget({super.key});

  @override
  Widget build(BuildContext context , WidgetRef ref) {
     final categoriesAsync = ref.watch(selectCategoryProvider);
       final int selectedCategoryIndex = ref.watch(selectedCategoryIndexProvider);
    return SizedBox(
      height: 48,
      child: categoriesAsync.when(
        data: (categorys) {
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final bool isSelected = index == selectedCategoryIndex;
              return GestureDetector(
                onTap: () {
                  ref
                      .read(selectedCategoryIndexProvider.notifier)
                      .setSelectedCategoryIndex(index);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF4565C6)
                        : const Color(0xFF2F2F2F),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Text(
                      categorys[index].name,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFFA3A3A3),
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemCount: categorys.length,
          );
        },
        loading: () => Skeletonizer(
          child: SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  width: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2F2F2F),
                    borderRadius: BorderRadius.circular(24),
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemCount: 5,
            ),
          ),
        ),
        error: (error, stackTrace) => Center(
          child: Text(
            'Error loading categories: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
