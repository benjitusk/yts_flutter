import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:yts_flutter/classes/news_article.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key, required this.articles});
  final List<NewsArticle> articles;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Text(articles[index].title);
      },
      itemCount: articles.length,
    );
  }
}
