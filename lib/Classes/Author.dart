import 'package:collection/collection.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:yts_flutter/classes/content_filterable.dart';
import 'package:yts_flutter/classes/misc_types.dart';

class Author extends BasicAuthor implements ContentFilterable {
  String profilePictureURL;
  FirebaseID get filterID => this.id;
  String filterName = "attributionID";

  Author(
      {required super.name,
      required this.profilePictureURL,
      required super.id});

  bool operator ==(Object other) {
    return other is Author && other.id == this.id;
  }

  @override
  int get hashCode => id.hashCode;

  static Set<Author> _authorRegistry = {};
  static Set<Author> get authorRegistry => _authorRegistry;
  static void addToRegistry(List<Author> authors) {
    _authorRegistry.addAll(authors);
  }

  static Author? registryLookup({required FirebaseID id}) {
    return _authorRegistry.firstWhereOrNull((element) => element.id == id);
  }

  static Future<Author> getAuthorFromDoc(FirebaseDoc doc) async {
    return FirebaseStorage.instance
        .ref()
        .child("profile-pictures")
        .child(doc["profile_picture_filename"])
        .getDownloadURL()
        .then((url) =>
            Author(name: doc["name"], profilePictureURL: url, id: doc.id));
  }
}

class BasicAuthor {
  String name;
  FirebaseID id;
  BasicAuthor({required this.name, required this.id});

  factory BasicAuthor.fromJson(Map<String, dynamic> json) {
    return BasicAuthor(name: json['name'], id: json['id']);
  }
}
