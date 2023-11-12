import 'package:flutter/material.dart';
import 'package:yts_flutter/classes/misc_types.dart';
import 'package:yts_flutter/classes/shiur.dart';
import 'package:yts_flutter/services/backend_manager.dart';
import 'package:yts_flutter/classes/category.dart';

class CategoryPageModel extends ChangeNotifier {
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _topOfNextPage != null;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  FirebaseDoc? _topOfNextPage;
  Category category;
  // List<Category>? _subCategories;
  // List<Category>? get subCategories => _subCategories;
  BuildContext? stupidContextHack;

  List<Shiur>? _content;
  List<Shiur>? get content => _content;

  bool get isEmpty =>
      (_content?.isEmpty ?? true) && (category.children?.isEmpty ?? true);

  CategoryPageModel({required this.category});

  void initialLoad() async {
    _isLoading = true;
    notifyListeners();
    final List<Future<dynamic>> tasks = [
      _loadContent(25).then((value) {
        _content = value;
      }),
    ];
    // if (category.isParent && category.children != null) {
    //   tasks.add(loadSubcategories());
    // } else {
    //   _subCategories = [];
    // }
    await Future.wait(tasks);
    _isLoading = false;
    notifyListeners();
  }

  Future loadMore() async {
    _isLoadingMore = true;
    notifyListeners();
    await _loadContent(10).then(
      (value) {
        _content!.addAll(value);
      },
    );
    _isLoadingMore = false;
    notifyListeners();
  }

  // Future loadSubcategories() {
  //   return Future.wait(category.children!.map((childCategoryID) async {
  //     return BackendManager.fetchCategoryByID(childCategoryID).then((response) {
  //       final childCategory = response.result;

  //       return childCategory;
  //     });
  //   })).then((categories) {
  //     _subCategories = categories;
  //   });
  // }

  Future<List<Shiur>> _loadContent(int limit) async {
    // Load parent category content
    return BackendManager.fetchContentByFilter(category,
            sortByRecent: true, topOfPage: _topOfNextPage, limit: limit)
        .then((response) {
      final shiurim = response.result;
      _topOfNextPage = response.firstDocOfNextPage;
      return shiurim;
    });
  }
}
