import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
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
      {int limit = 100, FirebaseDoc? topOfPage}) {
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance
        .collection("content")
        .orderBy("date", descending: true)
        .limit(limit + 1); // +1 to check if there's more content
    if (topOfPage != null) {
      query = query.startAtDocument(topOfPage);
    }
    return query.get().then((querySnapshot) {
      final docs = querySnapshot.docs;
      return BackendResponse(
        firstDocOfNextPage: docs.length > limit ? docs.removeLast() : null,
        result: docs.map((doc) => Shiur.getShiurFromDoc(doc)).toList(),
      );
    }).catchError((error) => throw error);
  }

  static Future<BackendResponse<(List<Shiur>, List<Author>)>> search(
      String query) async {
    final searchParameters = {
      "searchQuery": query,
      "searchOptions": {
        "content": {
          "limit": 100,
          "includeThumbnailURLs": true,
          "includeDetailedAuthorInfo": true,
          // "startAfterDocumentID": ID
        },
        "rebbeim": {
          "limit": 100,
          "includePictureURLs": true,
          // "startAfterDocumentID", ID
        }
      }
    };

    final List<Author> authors = [];
    final List<Shiur> contents = [];

    return FirebaseFunctions.instance
        .httpsCallable("search",
            options: HttpsCallableOptions(timeout: const Duration(seconds: 5)))
        .call(searchParameters)
        .then((result) {
      final results = (result.data["results"] as Map).cast<String, List>();

      // We need to process the rebbeim and shiurim separately
      // Rebbeim:
      final List? rawRebbeim = results["rebbeim"];
      if (rawRebbeim == null) {
        throw Exception("Invalid data received from backend (missing rebbeim)");
      }
      // "name", "id", "profile_picture_url"

      rawRebbeim.forEach((rabbi) {
        if (!(rabbi.containsKey("name") &&
            rabbi.containsKey("id") &&
            rabbi.containsKey("profile_picture_url"))) {
          print("Invalid data received from backend (missing keys for rabbi)");
          return;
          // throw Exception("Invalid data received from backend");
        }
        final Author author = Author(
            name: rabbi["name"],
            id: rabbi["id"],
            profilePictureURL: rabbi["profile_picture_url"]);
        authors.add(author);
      });

      // Shiurim:
      final List? rawShiurim = results["content"];
      if (rawShiurim == null) {
        throw Exception("Invalid data received from backend (missing content)");
      }
      // guard let id = contentDocument["id"] as? FirestoreID,
      // let type = contentDocument["type"] as? String,
      // let title = contentDocument["title"] as? String,
      // let author = contentDocument["author"] as? [String: Any],
      // let description = contentDocument["description"] as? String,
      // let dateDictionary = contentDocument["date"] as? [String: Int],
      // let sourceURLString = contentDocument["source_url"] as? String,
      // let categoryDocument = contentDocument["tagData"] as? [String: Any]

      // "id", "type", "title", "author", "description", "date", "source_url", "tagData"
      rawShiurim.forEach((shiur) {
        if (!(shiur.containsKey("id") &&
            shiur.containsKey("type") &&
            shiur.containsKey("title") &&
            shiur.containsKey("attributionID") &&
            shiur.containsKey("description") &&
            shiur.containsKey("date") &&
            shiur.containsKey("source_url") &&
            shiur.containsKey("duration"))) {
          print("Invalid data received from backend (missing keys for shiur)");
          return;
          // throw Exception("Invalid data received from backend");
        }
        // final Map<String, dynamic> rawShiur = value;
        final Shiur content = Shiur(
          id: shiur["id"],
          type: shiur["type"] == "audio" ? ShiurType.audio : ShiurType.video,
          title: shiur["title"],
          authorID: shiur["attributionID"],
          description: shiur["description"],
          date: DateTime.fromMillisecondsSinceEpoch(
              shiur["date"]["_seconds"] * 1000),
          sourcePath: "", //shiur["source_url"],
          duration: Duration(seconds: shiur['duration'] as int),
        );
        content.cachedURL = shiur["source_url"];
        contents.add(content);
      });

      return BackendResponse(result: (contents, authors));
    }).catchError((error) => throw error);
  }

  static Future<BackendResponse<List<Shiur>>> fetchContentByFilter(
      ContentFilterable filter,
      {int limit = 10,
      bool sortByRecent = true,
      FirebaseDoc? topOfPage}) async {
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance
        .collection("content")
        .where(filter.filterName, isEqualTo: filter.filterID)
        .orderBy("date", descending: sortByRecent)
        .limit(limit + 1); // +1 to check if there's more content
    if (topOfPage != null) {
      query = query.startAtDocument(topOfPage);
    }
    return query.get().then((querySnapshot) {
      final docs = querySnapshot.docs;
      final firstDocOfNextPage = docs.length > limit ? docs.removeLast() : null;
      return BackendResponse(
        result: docs.map((doc) => Shiur.getShiurFromDoc(doc)).toList(),
        firstDocOfNextPage: firstDocOfNextPage,
      );
    }).catchError((error) => throw error);
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
        // .then((value) => BackendResponse(result: value))
        .catchError((error) => throw error)
        .then((parentCategories) {
      return Future.wait(parentCategories.map((parentCat) async {
        if (parentCat.subCategories == null) {
          return parentCat;
        }
        return Future.wait(parentCat.subCategories!.map((subCatID) async {
          return FirebaseFirestore.instance
              .collection('tags')
              .doc(subCatID)
              .get()
              .then((doc) async => await Category.getCategoryFromDoc(doc));
        })).then((subCategories) {
          parentCat = parentCat.copyWith(children: subCategories);
          return parentCat;
        });
      })).then((value) => BackendResponse(result: value));
    });
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
                  .firstOrNull ??
              Sponsorship.expiredSponsorship);
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
