import 'package:flutter/material.dart';
import 'package:yts_flutter/classes/author.dart';
import 'package:yts_flutter/classes/category.dart';

class UploadScreenBloc extends ChangeNotifier {
  final Set<Author> rebbeim = Author.authorRegistry;
  final Set<Category> categories = Category.categoryRegistry;

  Author? selectedRabbi;
  Category? selectedCategory;

  void selectRabbi(Author? rabbi) {
    selectedRabbi = rabbi;
    notifyListeners();
  }

  void selectCategory(Category? category) {
    selectedCategory = category;
    notifyListeners();
  }
}
