import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:yts_flutter/classes/author.dart';
import 'package:yts_flutter/classes/misc_types.dart';
import 'package:yts_flutter/classes/streamable.dart';

class Shiur implements Streamable {
  String id;
  FirebaseID authorID;
  DateTime date;
  String description;
  Duration duration;
  String title;
  ShiurType type;
  String sourcePath;
  URL? cachedURL;
  URL? cachedShareURL;
  BasicAuthor get author {
    return Author.registryLookup(id: authorID) ??
        BasicAuthor(
          id: this.authorID,
          name: "Unknown",
        );
  }

  Shiur({
    required this.id,
    required this.date,
    required this.authorID,
    required this.description,
    required this.sourcePath,
    required this.duration,
    required this.title,
    required this.type,
  });

  @override
  Future<URL?> getShareLink() async {
    // if (cachedShareURL != null) return cachedShareURL;
    Uri link = Uri(
      scheme: "https",
      host: "app.toratshraga.com",
      path: "/content",
      queryParameters: {"id": id},
    );

    final dynamicLinkParams = DynamicLinkParameters(
      link: link,
      uriPrefix: "https://app.toratshraga.com/content",
      androidParameters:
          const AndroidParameters(packageName: "com.benjitusk.YTS"),
      iosParameters: const IOSParameters(
          bundleId: "com.reesedevelopment.YTS", appStoreId: "1598556472"),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: title,
        description:
            "Listen to this shiur by ${author.name} on the Torat Shraga app!",
        imageUrl: Uri.parse(
            "http://toratshraga.com/wp-content/uploads/2016/11/cropped-torat.jpg"),
      ),
      navigationInfoParameters: NavigationInfoParameters(
        forcedRedirectEnabled: true,
      ),
    );
    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParams);
    cachedShareURL = dynamicLink.toString();
    return cachedShareURL;
  }

  @override
  Future<URL?> getStreamableURL() async {
    try {
      return (await FirebaseFunctions.instance
              .httpsCallable('loadSignedUrlBySourcePath')
              .call({'sourcePath': this.sourcePath}))
          .data;
    } catch (e) {
      print(e);
      // This is the equivalent JS's Promise.resolve(null)
      return null;
    }
  }

  static Shiur getShiurFromDoc(FirebaseDoc doc) {
    final docData = doc.data()!;
    docData['id'] = doc.id;
    return Shiur(
      authorID: docData['attributionID'],
      date: (docData['date'] as Timestamp).toDate(),
      description: docData['description'],
      duration: Duration(seconds: docData['duration'] as int),
      id: docData['id'],
      title: docData['title'],
      sourcePath: docData['source_path'],
      type: ShiurType.audio,
    );
  }

  // static Future<List<Shiur>> loadShiurim(List<Author> authors) async {
  //   final QuerySnapshot<Map<String, dynamic>> querySnapshot =
  //       await FirebaseFirestore.instance
  //           .collection('content')
  //           .orderBy('date', descending: true)
  //           .limit(20)
  //           .get();
  //   return await Future.wait(querySnapshot.docs.map((doc) async {
  //     final docData = doc.data();
  //     docData['id'] = doc.id;
  //     Author? possibleAuthor = authors.firstWhereOrNull(
  //         (element) => element.id == docData["attributionID"]);
  //     final Shiur shiur = await Shiur.fromJson(docData, author: possibleAuthor);
  //     return shiur;
  //   }));
  // }
}

enum ShiurType {
  audio,
  video,
}
