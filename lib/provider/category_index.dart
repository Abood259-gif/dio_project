import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedCategoryIndex extends AutoDisposeNotifier<int> {
  @override
  int build() {
    return 0;
  }

  void setSelectedCategoryIndex(int index) {
    state = index;
  }
}

final selectedCategoryIndexProvider =
    NotifierProvider.autoDispose<SelectedCategoryIndex, int>(() {
      return SelectedCategoryIndex();
    });
