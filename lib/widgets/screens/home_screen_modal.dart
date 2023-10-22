import 'package:flutter/material.dart';
import 'package:yts_flutter/widgets/screens/HomeScreen/categories_row_model.dart';
import 'package:yts_flutter/widgets/screens/HomeScreen/rebbeim_row_model.dart';
import 'package:yts_flutter/widgets/screens/HomeScreen/recent_shiurim_row_model.dart';
import 'package:yts_flutter/widgets/screens/HomeScreen/slideshow_row_model.dart';

class HomeScreenModel extends ChangeNotifier {
  VoidCallback? onFinishedLoading;
  final RecentShiurimRowModel recentShiurimModel = RecentShiurimRowModel();
  final RebbeimRowModel rebbeimRowModel = RebbeimRowModel();
  final CategoriesRowModel categoriesRowModel = CategoriesRowModel();
  final SlideshowRowModel slideshowRowModel = SlideshowRowModel();

  HomeScreenModel({this.onFinishedLoading = null}) {}

  Future<void> loadAll() async {
    return Future.wait([
      rebbeimRowModel.load().then((_) => recentShiurimModel.load()),
      slideshowRowModel.load(),
      categoriesRowModel.load()
    ]).then((_) {
      onFinishedLoading?.call();
      notifyListeners();
    });
  }
}
