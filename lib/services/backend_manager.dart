import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yts_flutter/classes/sponsorship.dart';
import 'package:yts_flutter/classes/streamable.dart';
import 'package:yts_flutter/classes/author.dart';
import 'package:yts_flutter/classes/category.dart';
import 'package:yts_flutter/classes/content_filterable.dart';
import 'package:yts_flutter/classes/misc_types.dart';
import 'package:yts_flutter/classes/shiur.dart';

class BackendManager {
  // Do not instantiate this class
  BackendManager._()
      : assert(false,
            "Do not. Instantiate. This. Class. Just don't, okay? It's a bad idea. Trust me on this one.");
  static Future<List<Shiur>> fetchRecentContent({int limit = 100}) {
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

  static Future<List<Shiur>> fetchContentByFilter(ContentFilterable filter,
      {int limit = 10, bool sortByRecent = true}) async {
    return FirebaseFirestore.instance
        .collection("content")
        .where(filter.filterName, isEqualTo: filter.filterID)
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

  static Future<List<Category>> loadCategories() async {
    return FirebaseFirestore.instance
        .collection('tags')
        .where("isParent", isEqualTo: true)
        .get()
        .then((querySnapshot) {
      final results = Future.wait(querySnapshot.docs.map((doc) async {
        return await Category.getCategoryFromDoc(doc);
      }));
      return results;
    });
  }

  static Future<Category> fetchCategoryByID(FirebaseID categoryID) {
    return FirebaseFirestore.instance
        .collection('tags')
        .doc(categoryID)
        .get()
        .then((doc) {
      return Category.getCategoryFromDoc(doc);
    });
  }

  static Future<List<Streamable>> fetchContentByIDs(
      List<FirebaseID> contentIDs) async {
    if (contentIDs.isEmpty) {
      return [];
    }
    return FirebaseFirestore.instance
        .collection("content")
        .where(FieldPath.documentId, whereIn: contentIDs)
        .get()
        .then((querySnapshot) async {
      return querySnapshot.docs
          .map((doc) => Shiur.getShiurFromDoc(doc))
          .toList();
    });
  }

  static Future<Sponsorship?> fetchCurrentSponsorship() async {
    Query query = FirebaseFirestore.instance
        .collection("sponsorships")
        .where("dateEnd", isGreaterThanOrEqualTo: Timestamp.now());

    return query.get().then((querySnapshot) {
      if (querySnapshot.docs.isEmpty) {
        return null;
      }
      return querySnapshot.docs
          .map((doc) {
            return Sponsorship.getSponsorshipFromDoc(doc);
          })
          .where((s) => s.dateBegin.isBefore(DateTime.now()))
          .firstOrNull;
    });
  }
}

enum ContentFetchFilter {
  CATEGORY("tagData.id"),
  AUTHOR("attributionID");

  const ContentFetchFilter(this.filterName);

  final String filterName;
}
