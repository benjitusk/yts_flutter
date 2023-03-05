import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yts_flutter/Classes/Author.dart';

class Shiur {
  String attributionID;
  late Author author;
  DateTime date;
  String description;
  int duration;
  String sourcePath;
  String title;
  ShiurType type;

  static List<Shiur>? shiurim;

  Shiur({
    required this.attributionID,
    required this.date,
    required this.author,
    required this.description,
    required this.duration,
    required this.sourcePath,
    required this.title,
    required this.type,
  });

  factory Shiur.fromJson(Map<String, dynamic> json) {
    return Shiur(
      attributionID: json['attributionID'],
      author: json['author'],
      date: (json['date'] as Timestamp).toDate(),
      description: json['description'],
      duration: json['duration'] as int,
      sourcePath: json['source_path'],
      title: json['title'],
      type: ShiurType.audio,
    );
  }
}

enum ShiurType {
  audio,
  video,
}
