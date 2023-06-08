import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yts_flutter/classes/backend_response.dart';
import 'package:yts_flutter/classes/news_article.dart';
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
  static Future<BackendResponse<List<Shiur>>> fetchRecentContent(
      {int limit = 100, FirebaseDoc? lastDoc}) {
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance
        .collection("content")
        .orderBy("date", descending: true)
        .limit(limit);
    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }
    return query
        .get()
        .then((querySnapshot) => BackendResponse(
            result: querySnapshot.docs
                .map((doc) => Shiur.getShiurFromDoc(doc))
                .toList(),
            lastDoc: querySnapshot.docs.lastOrNull))
        .catchError((error) => throw error);
  }

  static Future<BackendResponse<List<Shiur>>> fetchContentByFilter(
      ContentFilterable filter,
      {int limit = 10,
      bool sortByRecent = true}) async {
    return FirebaseFirestore.instance
        .collection("content")
        .where(filter.filterName, isEqualTo: filter.filterID)
        .orderBy("date", descending: sortByRecent)
        .get()
        .then((querySnapshot) => BackendResponse(
            result: querySnapshot.docs
                .map((doc) => Shiur.getShiurFromDoc(doc))
                .toList()))
        .catchError((error) => throw error);
  }

  static Future<BackendResponse<List<Author>>> loadAuthors() async {
    return FirebaseFirestore.instance
        .collection('rebbeim')
        .get()
        .then((querySnapshot) {
      return Future.wait(querySnapshot.docs
              .map((doc) async => await Author.getAuthorFromDoc(doc))
              .toList())
          .then((value) => BackendResponse(result: value));
    }).catchError((error) => throw error);
  }

  static Future<BackendResponse<List<Category>>> loadCategories() async {
    return FirebaseFirestore.instance
        .collection('tags')
        .where("isParent", isEqualTo: true)
        .get()
        .then((querySnapshot) => Future.wait(querySnapshot.docs
            .map((doc) async => await Category.getCategoryFromDoc(doc))))
        .then((value) => BackendResponse(result: value))
        .catchError((error) => throw error);
  }

  static Future<BackendResponse<Category>> fetchCategoryByID(
      FirebaseID categoryID) {
    return FirebaseFirestore.instance
        .collection('tags')
        .doc(categoryID)
        .get()
        .then((doc) async =>
            BackendResponse(result: await Category.getCategoryFromDoc(doc)))
        .catchError((error) => throw error);
  }

  static Future<BackendResponse<List<Streamable>>> fetchContentByIDs(
      List<FirebaseID> contentIDs) async {
    if (contentIDs.isEmpty) {
      return BackendResponse(result: []);
    }
    return FirebaseFirestore.instance
        .collection("content")
        .where(FieldPath.documentId, whereIn: contentIDs)
        .get()
        .then((querySnapshot) async => querySnapshot.docs
            .map((doc) => Shiur.getShiurFromDoc(doc))
            .toList())
        .then((value) => BackendResponse<List<Streamable>>(result: value))
        .catchError((error) => throw error);
  }

  static Future<BackendResponse<Sponsorship?>> fetchCurrentSponsorship() async {
    Query query = FirebaseFirestore.instance
        .collection("sponsorships")
        .where("dateEnd", isGreaterThanOrEqualTo: Timestamp.now());

    return query.get().then((querySnapshot) {
      if (querySnapshot.docs.isEmpty) {
        return BackendResponse<Sponsorship?>(result: null);
      }
      return BackendResponse(
          result: querySnapshot.docs
              .map((doc) {
                return Sponsorship.getSponsorshipFromDoc(doc);
              })
              .where((s) => s.isActive)
              .firstOrNull);
    }).catchError((error) => throw error);
  }

  static Future<BackendResponse<List<NewsArticle>>> loadArticles() async {
    return FirebaseFirestore.instance
        .collection("news")
        .get()
        .then((querySnapshot) => BackendResponse(
            result: querySnapshot.docs
                .map((doc) => NewsArticle.fromJson(doc.data()))
                .toList()))
        .catchError((error) => throw error);
  }
}

enum ContentFetchFilter {
  CATEGORY("tagData.id"),
  AUTHOR("attributionID");

  const ContentFetchFilter(this.filterName);

  final String filterName;
}
