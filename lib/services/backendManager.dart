import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yts_flutter/classes/author.dart';
import 'package:yts_flutter/classes/misc_types.dart';
import 'package:yts_flutter/classes/shiur.dart';

class BackendManager {
  // Do not instantiate this class
  BackendManager._() : assert(false);

  static Future<List<Shiur>> fetchRecentContent({int limit = 10}) {
    return FirebaseFirestore.instance
        .collection("content")
        .orderBy("date", descending: true)
        .limit(limit)
        .get()
        .then((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return Shiur.getShiurFromDoc(doc);
      }).toList();
    });
  }

  static Future<List<Shiur>> fetchContentByFilter(
      ContentFetchFilter filter, FirebaseID id,
      {int limit = 10, bool sortByRecent = true}) {
    return FirebaseFirestore.instance
        .collection("content")
        .where(filter.filterName, isEqualTo: id)
        .orderBy("date", descending: sortByRecent)
        .get()
        .then((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return Shiur.getShiurFromDoc(doc);
      }).toList();
    });
  }

  static Future<List<Author>> loadAuthors() async {
    return FirebaseFirestore.instance
        .collection('rebbeim')
        .get()
        .then((querySnapshot) {
      final results = Future.wait(querySnapshot.docs.map((doc) async {
        return await Author.getAuthorFromDoc(doc);
      }));
      return results;
    });
  }
}

enum ContentFetchFilter {
  CATEGORY("tagData.id"),
  AUTHOR("attributionID");

  const ContentFetchFilter(this.filterName);

  final String filterName;
}
