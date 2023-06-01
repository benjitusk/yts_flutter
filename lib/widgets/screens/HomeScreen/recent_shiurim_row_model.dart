import 'package:flutter/material.dart';
import 'package:yts_flutter/classes/shiur.dart';
import 'package:yts_flutter/services/backend_manager.dart';

class RecentShiurimRowModel extends ChangeNotifier {
  final List<Shiur> recentShiurim = [];

  Future<void> load() async {
    return BackendManager.fetchRecentContent().then((shiurim) {
      recentShiurim.clear();
      recentShiurim.addAll(shiurim);
      notifyListeners();
    });
  }
}
