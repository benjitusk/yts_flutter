import 'package:flutter/material.dart';
import 'package:yts_flutter/classes/category.dart';
import 'package:yts_flutter/services/backend_manager.dart';

class CategoriesRowModel extends ChangeNotifier {
  final List<Category> categories = [];

  Future<void> load() async {
    return BackendManager.loadCategories().then((categories) {
      this.categories.clear();
      this.categories.addAll(categories);
    });
  }
}
