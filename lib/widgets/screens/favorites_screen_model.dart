import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yts_flutter/classes/favorites_manager.dart';
import 'package:yts_flutter/classes/streamable.dart';
import 'package:yts_flutter/services/backend_manager.dart';

class FavoritesScreenModel extends ChangeNotifier {
  List<Streamable>? _favorites = null;
  List<Streamable>? get favorites => _favorites;
  StreamSubscription? _favoritesSubscription;
  FavoritesScreenModel() {
    _loadFavorites();
    _favoritesSubscription = FavoritesManager().favoritesStream.listen((_) {
      _loadFavorites();
    });
  }

  void _loadFavorites() async {
    final _favoriteIDs = FavoritesManager().favorites;
    this._favorites = await BackendManager.fetchContentByIDs(_favoriteIDs);
    notifyListeners();
  }

  @override
  void dispose() {
    _favoritesSubscription?.cancel();
    super.dispose();
  }
}
