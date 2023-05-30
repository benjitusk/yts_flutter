import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:yts_flutter/classes/misc_types.dart';

class FavoritesManager {
  static final FavoritesManager _instance = FavoritesManager._internal();
  final List<FirebaseID> _favorites = [];
  List<FirebaseID> get favorites => _favorites;
  factory FavoritesManager() {
    return _instance;
  }

  FavoritesManager._internal() {
    _init();
  }

  Future<void> _init() async {
    // Load data from disk
    final prefs = await SharedPreferences.getInstance();
    _favorites.addAll(prefs.getStringList('favorites') ?? []);
    _favoritesStream.add(null);
  }

  StreamController<void> _favoritesStream = StreamController<void>.broadcast();
  Stream<void> get favoritesStream => _favoritesStream.stream;
  // List<String> get favorites => _favorites;

  void _flush() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favorites', _favorites);
  }

  void add(FirebaseID? id) {
    if (id == null) return;
    _favorites.add(id);
    _favoritesStream.add(null);
    _flush();
  }

  void clear() {
    _favorites.clear();
    _favoritesStream.add(null);
    _flush();
  }

  void remove(FirebaseID? id) {
    if (id == null) return;
    _favorites.remove(id);
    _favoritesStream.add(null);
    _flush();
  }

  void toggle(FirebaseID? id) {
    if (id == null) return;
    if (isFavorite(id)) {
      remove(id);
    } else {
      add(id);
    }
  }

  bool isFavorite(FirebaseID? id) {
    if (id == null) return false;
    return _favorites.contains(id);
  }
}
