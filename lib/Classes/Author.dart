import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Author {
  String name;
  String profilePictureURL;
  Author({required this.name, required this.profilePictureURL});

  static Future<List<Author>> loadAuthors() async {
    // Use Future.wait to run multiple async functions in parallel.
    // This will return a list of all the authors in the database.

    // Step 1: Get a list of all the documents in the "authors" collection
    // Step 2: For each document, get the url using the filename
    // Step 3: Create an Author object with the name and url

    // Step 1: Get a list of all the documents in the "authors" collection
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("rebbeim").get();

    // Step 2: For each document, get the url using the filename
    List<Future<Author>> authorFutures = querySnapshot.docs.map((doc) async {
      // Create a new Author object with the name and url
      return FirebaseStorage.instance
          .ref()
          .child("profile-pictures")
          .child(doc["profile_picture_filename"])
          .getDownloadURL()
          .then((url) => Author(name: doc["name"], profilePictureURL: url));
    }).toList();

    // Step 3: Create an Author object with the name and url
    return Future.wait(authorFutures);
  }
}
