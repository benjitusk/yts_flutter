import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:collection/collection.dart';
import 'package:yts_flutter/Classes/Author.dart';
import 'package:yts_flutter/Classes/Streamable.dart';

class Shiur implements Streamable {
  String attributionID;
  late BasicAuthor author;
  DateTime date;
  String description;
  Duration duration;
  String playbackUrl;
  String title;
  ShiurType type;

  Shiur({
    required this.attributionID,
    required this.date,
    required this.author,
    required this.description,
    required this.duration,
    required this.playbackUrl,
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
      duration: Duration(seconds: json['duration'] as int),
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
      final url = await FirebaseFunctions.instance
          .httpsCallable('loadSignedUrlBySourcePath')
          .call({'sourcePath': docData['source_path']});
      docData['url'] = url.data;
      final Shiur shiur = Shiur.fromJson(docData);
      Author? possibleAuthor = authors
          .firstWhereOrNull((element) => element.id == shiur.attributionID);
      if (possibleAuthor != null) shiur.author = possibleAuthor;
      return shiur;
    }));
  }
}

enum ShiurType {
  audio,
  video,
}
