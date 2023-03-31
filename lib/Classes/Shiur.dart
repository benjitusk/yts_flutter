import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:collection/collection.dart';
import 'package:yts_flutter/Classes/Author.dart';
import 'package:yts_flutter/Classes/Streamable.dart';

class Shiur implements Streamable {
  String id;
  late BasicAuthor author;
  DateTime date;
  String description;
  Duration duration;
  String playbackUrl;
  String title;
  ShiurType type;

  Shiur({
    required this.id,
    required this.date,
    required this.author,
    required this.description,
    required this.duration,
    required this.playbackUrl,
    required this.title,
    required this.type,
  });

  static Future<Shiur> fromJson(Map<String, dynamic> json,
      {Author? author}) async {
    final url = await FirebaseFunctions.instance
        .httpsCallable('loadSignedUrlBySourcePath')
        .call({'sourcePath': json['source_path']});
    json['url'] = url.data;
    if (author != null) assert(author.id == json["attributionID"]);
    return Shiur(
      author: author ??
          BasicAuthor(id: json['attributionID'], name: json['author']),
      date: (json['date'] as Timestamp).toDate(),
      description: json['description'],
      duration: Duration(seconds: json['duration'] as int),
      id: json['id'],
      playbackUrl: json['url'],
      title: json['title'],
      type: ShiurType.audio,
    );
  }

  static Future<List<Shiur>> loadShiurim(List<Author> authors) async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection('content')
            .orderBy('date', descending: true)
            .limit(20)
            .get();
    return await Future.wait(querySnapshot.docs.map((doc) async {
      final docData = doc.data();
      docData['id'] = doc.id;
      Author? possibleAuthor = authors.firstWhereOrNull(
          (element) => element.id == docData["attributionID"]);
      final Shiur shiur = await Shiur.fromJson(docData, author: possibleAuthor);
      return shiur;
    }));
  }
}

enum ShiurType {
  audio,
  video,
}
