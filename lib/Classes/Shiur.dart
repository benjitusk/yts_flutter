import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yts_flutter/Classes/Author.dart';

class Shiur {
  String attributionID;
  late BasicAuthor author;
  DateTime date;
  String description;
  int duration;
  String sourcePath;
  String title;
  ShiurType type;

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
      author: BasicAuthor(id: json['attributionID'], name: json['author']),
      //json['author'],
      date: (json['date'] as Timestamp).toDate(),
      description: json['description'],
      duration: json['duration'] as int,
      sourcePath: json['source_path'],
      title: json['title'],
      type: ShiurType.audio,
    );
  }

  static Future<List<Shiur>> loadShiurim() async {
    List<Shiur> shiurim = [];
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection('content')
            .orderBy('date', descending: true)
            .limit(20)
            .get();
    for (final doc in querySnapshot.docs) {
      final Shiur shiur = Shiur.fromJson(doc.data());
      shiurim.add(shiur);
    }
    return shiurim;
  }
}

enum ShiurType {
  audio,
  video,
}
