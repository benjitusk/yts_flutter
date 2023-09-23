import 'package:flutter/material.dart';
import 'package:yts_flutter/classes/author.dart';
import 'package:yts_flutter/classes/misc_types.dart';
import 'package:yts_flutter/classes/shiur.dart';
import 'package:yts_flutter/services/backend_manager.dart';

class RabbiPageModel extends ChangeNotifier {
  RabbiPageModel({required this.rabbi});

  final Author rabbi;
  List<Shiur> get content => _content;
  List<Shiur> _content = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool get isloading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  FirebaseDoc? _topOfNextPage;
  bool get hasMore => _topOfNextPage != null;
  bool get isLoading => _isLoading;

  void loadMore() async {
    _isLoadingMore = true;
    notifyListeners();
    await _load(10);
    _isLoadingMore = false;
    notifyListeners();
  }

  void initialLoad() async {
    _isLoading = true;
    notifyListeners();
    await _load(25);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _load(int amount) async {
    return BackendManager.fetchContentByFilter(this.rabbi,
            topOfPage: _topOfNextPage)
        .then((response) {
      final newContent = response.result;
      _topOfNextPage = response.firstDocOfNextPage;
      _content.addAll(newContent);
      _isLoading = false;
    });
  }
}
