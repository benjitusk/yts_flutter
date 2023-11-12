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
  final List<Category>? children;
  final List<FirebaseID>? subCategories;
  FirebaseID get filterID => this.id;
  String get filterName => "tagData.id";

  Category(
      {required this.hiddenName,
      required this.imageURL,
      required this.displayName,
      required this.id,
      required this.isParent,
      this.subCategories = null,
      this.children = null});

  Category copyWith(
      {String? hiddenName,
      String? imageURL,
      String? displayName,
      FirebaseID? id,
      bool? isParent,
      List<Category>? children,
      List<FirebaseID>? subCategories}) {
    return Category(
        hiddenName: hiddenName ?? this.hiddenName,
        imageURL: imageURL ?? this.imageURL,
        displayName: displayName ?? this.displayName,
        id: id ?? this.id,
        isParent: isParent ?? this.isParent,
        children: children ?? this.children,
        subCategories: subCategories ?? this.subCategories);
  }

  static Future<Category> getCategoryFromDoc(FirebaseDoc doc) async {
    final docData = doc.data()!;
    final String? url = (doc.id == MISC_ID || docData['isParent'] != true)
        ? null
        : await FirebaseStorage.instance
            .ref("assets/${doc.id}")
            .getDownloadURL()
            .catchError((e) {
            print("Error fetching assets/${doc.id}");
            return "";
          });
    final subcategories = docData['subCategories'] as List<dynamic>?;
    // I _promise_ subcategories is List<String>?. I just need to convince Dart.
    final children = subcategories?.cast<String>();

    return Category(
        hiddenName: docData['name'],
        imageURL: url,
        displayName: docData['displayName'],
        id: doc.id,
        isParent: docData['isParent'] ?? false,
        subCategories: children);
  }

  static Set<Category> _categoryRegistry = {};
  static Set<Category> get categoryRegistry => _categoryRegistry;
  static void addToRegistry(List<Category> categories) {
    _categoryRegistry.addAll(categories);
  }

  bool operator ==(Object other) {
    return other is Category && other.id == this.id;
  }

  @override
  int get hashCode => id.hashCode;

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
