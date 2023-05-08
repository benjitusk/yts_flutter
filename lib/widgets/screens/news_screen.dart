import 'package:flutter/material.dart';
import 'package:yts_flutter/classes/news_article.dart';
import 'package:yts_flutter/widgets/cards/news_card.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key, required this.articles});
  final List<NewsArticle> articles;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.separated(
        itemBuilder: (context, index) {
          return NewsCard(article: articles[index]);
        },
        itemCount: articles.length,
        separatorBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(),
          );
        },
      ),
    );
  }
}
