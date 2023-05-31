import 'package:flutter/material.dart';
import 'package:yts_flutter/classes/news_article.dart';
import 'package:yts_flutter/services/backend_manager.dart';

class NewsScreenModal extends ChangeNotifier {
  List<NewsArticle> articles = [];
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  NewsScreenModal() {
    _loadArticles();
  }

  Future<void> _loadArticles() async {
    _isLoading = true;
    notifyListeners();
    await BackendManager.loadArticles().then((newsArticles) {
      articles.clear();
      articles.addAll(newsArticles);
    });
    _isLoading = false;
    notifyListeners();
  }
}
