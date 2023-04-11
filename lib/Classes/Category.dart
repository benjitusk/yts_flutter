import 'package:firebase_storage/firebase_storage.dart';
import 'package:yts_flutter/classes/content_filterable.dart';
import 'package:yts_flutter/classes/misc_types.dart';

const MISC_ID = "NKwXl5QXmOe6rlQ9J3kW";

class Category implements ContentFilterable {
  final FirebaseID id;
  final String hiddenName;
  final String? imageURL;
  final String displayName;
  final bool isParent;
  final List<FirebaseID>? children;
  FirebaseID get filterID => this.id;
  String get filterName => "tagData.id";

  Category(
      {required this.hiddenName,
      required this.imageURL,
      required this.displayName,
      required this.id,
      required this.isParent,
      this.children = null});

  static Future<Category> getCategoryFromDoc(FirebaseDoc doc) async {
    final String? url = doc.id == MISC_ID
        ? null
        : await FirebaseStorage.instance
            .ref("assets/${doc.id}")
            .getDownloadURL()
            .catchError((e) {
            print("Error fetching assets/${doc.id}");
            return "";
          });
    final docData = doc.data()!;
    final subcategories = docData['subCategories'] as List<dynamic>?;
    // I _promise_ subcategories is List<String>?. I just need to convince Dart.
    final children = subcategories?.cast<String>();

    return Category(
        hiddenName: docData['name'],
        imageURL: url,
        displayName: docData['displayName'],
        id: doc.id,
        isParent: docData['isParent'] ?? false,
        children: children);
  }

  // static Future<List<Category>> loadCategories() async {
  //   final snapshot = await FirebaseFirestore.instance
  //       .collection("tags")
  //       .where("isParent", isEqualTo: true)
  //       .get();
  //   final categoryFutures = snapshot.docs.map((doc) async {
  //     final id = doc.id;
  // final String? url = doc.id == MISC_ID
  //     ? null
  //     : await FirebaseStorage.instance
  //         .ref("assets/${doc.id}")
  //         .getDownloadURL()
  //         .catchError((e) {
  //         print("Error fetching assets/${doc.id}");
  //         return "";
  //       });
  //   });
  //   return Future.wait(categoryFutures);
  // }
}
