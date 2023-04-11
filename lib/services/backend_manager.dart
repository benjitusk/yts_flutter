import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yts_flutter/classes/author.dart';
import 'package:yts_flutter/classes/category.dart';
import 'package:yts_flutter/classes/content_filterable.dart';
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

  static Future<List<Shiur>> fetchContentByFilter(ContentFilterable filter,
      {int limit = 10, bool sortByRecent = true}) async {
    print(
        "Fetching content by filter: ${filter.filterName} = ${filter.filterID}");
    if (filter is Category && filter.children != null) {
      return await Future.wait(filter.children!.map((filterID) async {
        return await FirebaseFirestore.instance
            .collection("tags")
            .doc(filterID)
            .get()
            .then((querySnapshot) async {
          return await Category.getCategoryFromDoc(
              querySnapshot as FirebaseDoc);
        });
      }).toList())
          .then((subcategories) async {
        // First start with a List<Future<List<Shiur>>>
        // In order to get a Future<List<Shiur>>, we need to call Future.wait
        // Future.wait takes a List<Future<T>> and returns a Future<List<T>>
        // So we need to call Future.wait on each Future<List<Shiur>>
        // So, as follows, let's get our List<Future<List<Shiur>>>:

        final listOfFutureLists = subcategories.map((subcategory) {
          return fetchContentByFilter(subcategory,
              limit: limit, sortByRecent: sortByRecent);
        }).toList();

        // Now return a flattened list of the results
        return Future.wait(listOfFutureLists).then((listOfLists) {
          return listOfLists.expand((element) => element).toList();
        });
      });
    }

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
}

enum ContentFetchFilter {
  CATEGORY("tagData.id"),
  AUTHOR("attributionID");

  const ContentFetchFilter(this.filterName);

  final String filterName;
}
