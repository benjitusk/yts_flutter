import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yts_flutter/widgets/screens/HomeScreen/Categories/categories_row_model.dart';
import 'package:yts_flutter/widgets/screens/HomeScreen/Rebbeim/rebbeim_row_model.dart';
import 'package:yts_flutter/widgets/screens/HomeScreen/Recents/recent_shiurim_row_model.dart';
import 'package:yts_flutter/widgets/screens/HomeScreen/Slideshow/slideshow_row_model.dart';

class HomeScreenModel extends ChangeNotifier {
  final RecentShiurimRowModel recentShiurimModel = RecentShiurimRowModel();
  final RebbeimRowModel rebbeimRowModel = RebbeimRowModel();
  final CategoriesRowModel categoriesRowModel = CategoriesRowModel();
  final SlideshowRowModel slideshowRowModel = SlideshowRowModel();
  bool _isLoading = true;
  bool _didInitialLoad = false;
  bool _isFirstLaunch = false;
  bool get isLoading => _isLoading;
  bool get isFirstLaunch => _isFirstLaunch;

  HomeScreenModel() {
    SharedPreferences.getInstance().then((prefs) async {
      _isFirstLaunch = prefs.getBool('--isFirstLaunch') ?? true;
      notifyListeners();
    });
  }

  void setFirstLaunch(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    _isFirstLaunch = value;
    notifyListeners();
    prefs.setBool('isFirstLaunch', value);
  }

  Future<VoidCallback> _loadAll() async {
    if (!_isLoading) {
      _isLoading = true;
      notifyListeners();
    }
    return Future.wait([
      rebbeimRowModel.load().then((_) => recentShiurimModel.load()),
      slideshowRowModel.load(),
      categoriesRowModel.load(),
    ]).then((_) {
      return () {
        _isLoading = false;
        notifyListeners();
      };
    }).catchError((_) {
      print("Error loading home screen");
      return () {};
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
