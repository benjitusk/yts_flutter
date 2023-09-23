import 'package:flutter/material.dart';
import 'package:yts_flutter/classes/misc_types.dart';
import 'package:yts_flutter/classes/shiur.dart';
import 'package:yts_flutter/services/backend_manager.dart';

class RecentShiurimRowModel extends ChangeNotifier {
  final List<Shiur> recentShiurim = [];
  bool isLoadingMore = false;
  FirebaseDoc? _topOfNextPage; // For pagination
  Future<void> load() async {
    return BackendManager.fetchRecentContent(limit: 25).then((result) {
      final shiurim = result.result;
      _topOfNextPage = result.firstDocOfNextPage;
      recentShiurim.clear();
      recentShiurim.addAll(shiurim);
      notifyListeners();
    });
  }

  Future<void> loadMore(int limit) async {
    if (isLoadingMore) {
      return;
    }
    isLoadingMore = true;
    notifyListeners();
    return BackendManager.fetchRecentContent(
            limit: limit, topOfPage: _topOfNextPage)
        .then((response) {
      final shiurim = response.result;
      _topOfNextPage = response.firstDocOfNextPage;
      recentShiurim.addAll(shiurim);
      isLoadingMore = false;
      notifyListeners();
    });
  }
}
