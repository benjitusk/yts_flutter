import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:yts_flutter/classes/streamable.dart';

class FavoritesManager {
  static final FavoritesManager _instance = FavoritesManager._internal();

  factory FavoritesManager() {
    return _instance;
  }

  FavoritesManager._internal() {
    _init();
  }

  Future<void> _init() async {
    // Load data from disk
    final prefs = await SharedPreferences.getInstance();
    _favorites = prefs.getStringList('favorites') ?? [];
    _favoritesStream.add(null);
  }

  List<String> _favorites = [];
  StreamController<void> _favoritesStream = StreamController<void>.broadcast();
  Stream<void> get favoritesStream => _favoritesStream.stream;
  // List<String> get favorites => _favorites;

  void _flush() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favorites', _favorites);
  }

  void add(Streamable? content) {
    if (content == null) return;
    _favorites.add(content.id);
    _favoritesStream.add(null);
    _flush();
  }

  void clear() {
    _favorites.clear();
    _favoritesStream.add(null);
    _flush();
  }

  void remove(Streamable? content) {
    if (content == null) return;
    _favorites.remove(content.id);
    _favoritesStream.add(null);
    _flush();
  }

  void toggle(Streamable? content) {
    if (content == null) return;
    if (isFavorite(content)) {
      remove(content);
    } else {
      add(content);
    }
  }

  bool isFavorite(Streamable? content) {
    if (content == null) return false;
    return _favorites.contains(content.id);
  }
}
