import 'package:cloud_firestore/cloud_firestore.dart';

class NewsArticle {
  final String body;
  final String author;
  final Timestamp date;
  final String title;

  static List<NewsArticle>? newsArticles;

  NewsArticle({
    required this.body,
    required this.author,
    required this.date,
    required this.title,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      body: json['body'] as String,
      author: json['author'] as String,
      date: json['date'] as Timestamp,
      title: json['title'] as String,
    );
  }
}
