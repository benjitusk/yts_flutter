import 'package:flutter/material.dart';
import 'package:yts_flutter/classes/misc_types.dart';
import 'package:yts_flutter/classes/shiur.dart';
import 'package:yts_flutter/services/backend_manager.dart';

class RecentShiurimRowModel extends ChangeNotifier {
  final List<Shiur> recentShiurim = [];
  bool isLoadingMore = false;
  FirebaseDoc? lastDoc; // For pagination
  Future<void> load() async {
    return BackendManager.fetchRecentContent(limit: 1).then((result) {
      final shiurim = result.result;
      lastDoc = result.lastDoc;
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
    return BackendManager.fetchRecentContent(limit: limit, lastDoc: lastDoc)
        .then((response) {
      final shiurim = response.result;
      lastDoc = response.lastDoc;
      recentShiurim.addAll(shiurim);
      isLoadingMore = false;
      notifyListeners();
    });
  }
}
