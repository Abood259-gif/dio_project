



import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedCategoryIndex extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  void setSelectedCategoryIndex(int index) {
    state = index;
  }
}

final selectedCategoryIndexProvider = NotifierProvider<SelectedCategoryIndex, int>(() {
  return SelectedCategoryIndex();
});