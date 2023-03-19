import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:yts_flutter/Classes/Author.dart';
import 'package:yts_flutter/Classes/Category.dart';
import 'package:yts_flutter/Classes/NewsArticle.dart';
import 'package:yts_flutter/Classes/Shiur.dart';
import 'package:yts_flutter/theme.dart';
import 'package:yts_flutter/widgets/screens/HomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // App Check
  await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.debug,
      appleProvider: AppleProvider.debug,
      webRecaptchaSiteKey: "recaptcha-v3-site-key");
  // Anonymously sign in
  await FirebaseAuth.instance.signInAnonymously();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: generateTheme(context),
      home: AppBody(),
    );
  }
}

class AppBody extends StatefulWidget {
  const AppBody({
    super.key,
  });

  @override
  State<AppBody> createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
  final List<Author> rebbeim = [];
  final List<Shiur> recentShiurim = [];
  final List<String> featuredImageURLs = [];
  final List<Category> categories = [];
  final List<NewsArticle> articles = [];
  final List<Shiur> favorites = [];

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  void _loadData() {
    // Log a clearly identifiable message
    // that we're making production API calls
    Author.loadAuthors().then((authors) {
      rebbeim.clear();
      // Sort by last name
      authors.sort((lhs, rhs) =>
          lhs.name.split(" ").last.compareTo(rhs.name.split(" ").last));
      Author.authors = authors;
      setState(() {
        rebbeim.addAll(authors);
      });
    }).then((_) {
      Shiur.loadShiurim(rebbeim).then((shiurim) {
        recentShiurim.clear();
        setState(() {
          recentShiurim.addAll(shiurim);
        });
      });
    });

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
    Category.loadCategories().then((categories) {
      this.categories.clear();
      setState(() {
        this.categories.addAll(categories);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Yeshivat Torat Shraga'),
          bottom: const TabBar(
            tabs: [
              Tab(
                // icon: Icon(Icons.home),
                text: "Home",
              ),
              Tab(text: "Favorites"),
              Tab(text: "News"),
              Tab(icon: Icon(Icons.settings)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            HomePage(
                rebbeim: rebbeim,
                categories: categories,
                featuredImageURLs: featuredImageURLs,
                recentShiurim: recentShiurim),
            Placeholder(),
            Placeholder(),
            Placeholder(),
          ],
        ),
      ),
    );
  }
}
