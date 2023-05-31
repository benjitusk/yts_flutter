import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:yts_flutter/classes/author.dart';
import 'package:yts_flutter/classes/category.dart';
import 'package:yts_flutter/classes/shiur.dart';
import 'package:yts_flutter/services/backend_manager.dart';

class HomeScreenModel extends ChangeNotifier {
  List<Author> rebbeim = [];
  List<Shiur> recentShiurim = [];
  List<String> featuredImageURLs = [];
  List<Category> categories = [];
  // bool _isLoading = false;

  // This will fetch the news titles from Firebase

  HomeScreenModel() {
    _loadAll();
  }

  Future<void> _loadAll() async {
    // _isLoading = true;
    await Future.wait(
        [_loadAuthorsAndContent(), _loadFeaturedImages(), _loadCategories()]);
    // _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadAuthorsAndContent() async {
    return BackendManager.loadAuthors().then((authors) {
      rebbeim.clear();
      // Sort by last name
      authors.sort((lhs, rhs) =>
          lhs.name.split(" ").last.compareTo(rhs.name.split(" ").last));
      Author.addToRegistry(authors);
      rebbeim.addAll(authors);
    }).then((_) {
      BackendManager.fetchRecentContent().then((shiurim) {
        recentShiurim.clear();
        recentShiurim.addAll(shiurim);
        notifyListeners();
      });
    });
  }

  Future<void> _loadFeaturedImages() async {
    return FirebaseFirestore.instance
        .collection("slideshowImages")
        .orderBy("uploaded", descending: true)
        .limit(15)
        .get()
        .then((snapshot) async {
      Future.wait(snapshot.docs.map((doc) async {
        final String url = await FirebaseStorage.instance
            .ref("slideshow/${doc.data()['image_name']}")
            .getDownloadURL();
        return url;
      })).then((urls) {
        featuredImageURLs.clear();
        featuredImageURLs.addAll(urls);
      });
    });
  }

  Future<void> _loadCategories() async {
    return BackendManager.loadCategories().then((categories) {
      this.categories.clear();
      this.categories.addAll(categories);
    });
  }
}
