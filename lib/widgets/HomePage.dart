// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:yts_flutter/Classes/Author.dart';
import 'package:yts_flutter/Classes/Shiur.dart';
import 'package:yts_flutter/widgets/Slideshow.dart';
import 'package:yts_flutter/widgets/cards/HomeRabbiCard.dart';
import 'package:yts_flutter/widgets/cards/HomeShiurCard.dart';
import 'package:yts_flutter/widgets/helpers/TextDivider.dart';

class HomePage extends StatefulWidget {
  const HomePage({key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  // This will hold the list of news titles (list of strings)
  final List<Author> rebbeim = [];
  final List<Shiur> recentShiurim = [];
  final List<String> featuredImageURLs = [];
  // Load rebbeim from Firebase when the page is loaded
  @override
  void initState() {
    super.initState();
    loadData();
  }

  // This will fetch the news titles from Firebase
  void loadData() async {
    // Log a clearly identifiable message
    // that we're making production API calls
    print("====== PRODUCTION API CALLS ======");
    print(" 1) Fetching rebbeim from Firebase");
    Author.loadAuthors().then((authors) {
      rebbeim.clear();
      // Sort by last name
      authors.sort((lhs, rhs) =>
          lhs.name.split(" ").last.compareTo(rhs.name.split(" ").last));
      Author.authors = authors;
      setState(() {
        rebbeim.addAll(authors);
      });
    });
    print(" 2) Fetching recent shiurim from Firebase");
    Shiur.loadShiurim().then((shiurim) {
      recentShiurim.clear();
      setState(() {
        recentShiurim.addAll(shiurim);
      });
    });
    print(" 3) Fetching featured pictures from Firebase");
    FirebaseFirestore.instance
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
        setState(() {
          featuredImageURLs.addAll(urls);
        });
      });
    });
    print("==================================");
  }

  @override
  Widget build(BuildContext context) {
    final sections = {
      "Recent Shiurim": SizedBox(
        height: 120,
        child: Center(
            child: ListView.separated(
          scrollDirection: Axis.horizontal,
          // Space the cards out a bit
          padding: const EdgeInsets.all(8),
          separatorBuilder: (context, index) => const SizedBox(width: 15),
          itemCount: recentShiurim.length,
          itemBuilder: (context, index) =>
              HomeShiurCard(shiur: recentShiurim[index]),
        )),
      ),
      "Rebbeim": SizedBox(
        height: 200,
        child: Center(
            child: ListView.separated(
          padding: const EdgeInsets.all(8.0),
          scrollDirection: Axis.horizontal,
          separatorBuilder: (context, index) => const SizedBox(width: 15),
          itemCount: rebbeim.length,
          itemBuilder: (context, index) => HomeRabbiCard(rabbi: rebbeim[index]),
        )),
      ),
      "Categories": SizedBox(
        height: 200,
        child: Placeholder(),
      ),
      "Featured Pictures": ImageCarousel(
        urls: featuredImageURLs,
      ),
    };
    return ListView(
      children: [
        TextButton(onPressed: loadData, child: Text("Reload")),
        ...sections
            .map((title, widget) => MapEntry(
                title,
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextDivider(text: title),
                    ),
                    widget,
                  ],
                )))
            .values
      ],
    );
  }
}
