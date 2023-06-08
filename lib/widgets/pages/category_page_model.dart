import 'package:flutter/material.dart';
import 'package:yts_flutter/classes/shiur.dart';
import 'package:yts_flutter/services/backend_manager.dart';
import 'package:yts_flutter/classes/category.dart';

class CategoryPageModel extends ChangeNotifier {
  bool get isLoading => _subCategories == null || _content == null;
  Error? _error = Error();
  Error? get error => _error;
  Category category;
  List<Category>? _subCategories;
  List<Category>? get subCategories => _subCategories;
  BuildContext? stupidContextHack;

  List<Shiur>? _content;
  List<Shiur>? get content => _content;

  bool get isEmpty =>
      (_content?.isEmpty ?? true) && (_subCategories?.isEmpty ?? true);

  CategoryPageModel({required this.category}) {
    // fetchContent();
  }

  void loadContent() async {
    _error = null;
    _subCategories = null;
    _content = null;
    notifyListeners();
    if (category.isParent && category.children != null) {
      // Load child categories
      Future.wait(category.children!.map((childCategoryID) async {
        return BackendManager.fetchCategoryByID(childCategoryID)
            .then((response) {
          final childCategory = response.result;

          return childCategory;
        });
      })).then((categories) {
        _subCategories = categories;
        notifyListeners();
      });
    } else {
      _subCategories = [];
      notifyListeners();
    }

    // Load parent category content
    BackendManager.fetchContentByFilter(category, sortByRecent: true)
        .then((response) {
      final shiurim = response.result;
      _content = shiurim;
      notifyListeners();
    });
  }
  // void showAlertDialog() {
  //   if (stupidContextHack == null) {
  //     return;
  //   }
  //   showDialog(
  //     context: stupidContextHack!,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Error'),
  //       content: Text(error.toString()),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.of(context).pop(),
  //           child: const Text('OK'),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
