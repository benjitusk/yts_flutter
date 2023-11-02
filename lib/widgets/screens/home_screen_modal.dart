import 'package:flutter/material.dart';
import 'package:yts_flutter/widgets/screens/HomeScreen/categories_row_model.dart';
import 'package:yts_flutter/widgets/screens/HomeScreen/rebbeim_row_model.dart';
import 'package:yts_flutter/widgets/screens/HomeScreen/recent_shiurim_row_model.dart';
import 'package:yts_flutter/widgets/screens/HomeScreen/slideshow_row_model.dart';

class HomeScreenModel extends ChangeNotifier {
  final RecentShiurimRowModel recentShiurimModel = RecentShiurimRowModel();
  final RebbeimRowModel rebbeimRowModel = RebbeimRowModel();
  final CategoriesRowModel categoriesRowModel = CategoriesRowModel();
  final SlideshowRowModel slideshowRowModel = SlideshowRowModel();
  bool _isLoading = true;
  bool _didInitialLoad = false;
  bool get isLoading => _isLoading;

  Future<VoidCallback> _loadAll() async {
    if (!_isLoading) {
      _isLoading = true;
      notifyListeners();
    }
    return Future.wait([
      rebbeimRowModel.load().then((_) => recentShiurimModel.load()),
      slideshowRowModel.load(),
      categoriesRowModel.load()
    ]).then((_) {
      return () {
        _isLoading = false;
        notifyListeners();
      };
    });
  }

  Future<VoidCallback> initialLoad() async {
    print("HomeScreenModel initialLoad: $_didInitialLoad");
    if (!_didInitialLoad) {
      _didInitialLoad = true;
      return _loadAll();
    }
    return () {};
  }

  void setLoadingState(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }
}
