import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:yts_flutter/classes/misc_types.dart';

const MISC_ID = "NKwXl5QXmOe6rlQ9J3kW";

class Category {
  final FirebaseID id;
  final String hiddenName;
  final String? imageURL;
  final String displayName;

  Category(
      {required this.hiddenName,
      required this.imageURL,
      required this.displayName,
      required this.id});

  static Future<List<Category>> loadCategories() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("tags")
        .where("isParent", isEqualTo: true)
        .get();
    final categoryFutures = snapshot.docs.map((doc) async {
      final id = doc.id;
      final String? url = doc.id == MISC_ID
          ? null
          : await FirebaseStorage.instance
              .ref("assets/${doc.id}")
              .getDownloadURL()
              .catchError((e) {
              print("Error fetching assets/${doc.id}");
              return "";
            });
      return Category(
        hiddenName: doc.data()['name'],
        imageURL: url,
        displayName: doc.data()['displayName'],
        id: id,
      );
    });
    return Future.wait(categoryFutures);
  }
}
