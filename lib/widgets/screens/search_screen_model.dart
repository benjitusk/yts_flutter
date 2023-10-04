import 'package:flutter/material.dart';
import 'package:yts_flutter/classes/author.dart';
import 'package:yts_flutter/classes/shiur.dart';
import 'package:yts_flutter/services/backend_manager.dart';

class ContentSearchModel with ChangeNotifier {
  static const int _maxSearchHistoryLength = 5;
  List<String> _searchHistory = [];
  List<Shiur> _shiurimResults = [];
  List<Author> _rebbeimResults = [];

  List<String> get searchHistory => _searchHistory;
  List<Shiur> get shiurimResults => _shiurimResults;
  List<Author> get rebbeimResults => _rebbeimResults;

  void _addToSearchHistory(String query) {
    if (!_searchHistory.contains(query)) {
      if (_searchHistory.length >= _maxSearchHistoryLength) {
        _searchHistory.removeAt(0);
      }
      _searchHistory.add(query);
      notifyListeners();
    }
  }

  Future<(List<Shiur>, List<Author>)> search(String query) {
    _addToSearchHistory(query);
    return BackendManager.search(query).then((response) {
      _shiurimResults = response.result.$1;
      _rebbeimResults = response.result.$2;
      print(
          "Found ${_shiurimResults.length} shiurim and ${_rebbeimResults.length} rebbeim");
      // notifyListeners();
      return response.result;
    }).catchError((error) => throw error);
  }
}
