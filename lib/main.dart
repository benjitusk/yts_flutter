import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:yts_flutter/classes/audio_manager.dart';
import 'package:yts_flutter/widgets/helpers/Constants.dart';
import 'package:yts_flutter/widgets/screens/favorites_screen.dart';
import 'package:yts_flutter/widgets/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yts_flutter/widgets/screens/loading_screen.dart';
import 'package:yts_flutter/widgets/screens/news_screen.dart';
import 'package:audio_service/audio_service.dart';
import 'firebase_options.dart';

late AudioHandler audioHandler;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // App Check
  await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.debug,
      appleProvider: AppleProvider.debug);
  // Anonymously sign in
  await FirebaseAuth.instance.signInAnonymously();

  // Initialize audio service
  print("Initializing audio service");
  FirebaseAppCheck.instance.getToken().then((value) => print(value));
  audioHandler = await AudioService.init(
    builder: () => AudioManager(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.benjitusk.yts_flutter',
      androidNotificationChannelName: 'YTS Flutter',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
      androidNotificationIcon: 'mipmap/ic_launcher',
      androidShowNotificationBadge: true,
      androidNotificationClickStartsActivity: true,
      // androidEnableQueue: true,
      androidResumeOnClick: true,
      // androidNotificationColor: 0xFF2196f3,
      // androidNotificationClickIntentAction: 'com.benjitusk.yts_flutter.action.toggle',
      // androidNotificationClickIntentPackage: 'com.benjitusk.yts_flutter',
      // androidNotificationClickIntentClass: 'com.benjitusk.yts_flutter.MainActivity',
    ),
  );
  print("Audio service initialized");
  // Initialize services
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: UI.lightTheme,
      darkTheme: UI.darkTheme,
      themeMode: ThemeMode.system,
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
  // final List<Author> rebbeim = [];
  // final List<Shiur> recentShiurim = [];
  // final List<String> featuredImageURLs = [];
  // final List<Category> categories = [];
  // final List<NewsArticle> articles = [];
  bool get isReady => true;
  @override
  void initState() {
    // _loadData();
    super.initState();
  }

  // void _loadData() {
  //   // Log a clearly identifiable message
  //   // that we're making production API calls
  //   BackendManager.loadAuthors().then((authors) {
  //     rebbeim.clear();
  //     // Sort by last name
  //     authors.sort((lhs, rhs) =>
  //         lhs.name.split(" ").last.compareTo(rhs.name.split(" ").last));
  //     Author.addToRegistry(authors);
  //     setState(() {
  //       rebbeim.addAll(authors);
  //     });
  //   }).then((_) {
  //     BackendManager.fetchRecentContent().then((shiurim) {
  //       recentShiurim.clear();
  //       setState(() {
  //         recentShiurim.addAll(shiurim);
  //       });
  //     });
  //   });

  //   FirebaseFirestore.instance
  //       .collection("slideshowImages")
  //       .orderBy("uploaded", descending: true)
  //       .limit(15)
  //       .get()
  //       .then((snapshot) async {
  //     Future.wait(snapshot.docs.map((doc) async {
  //       final String url = await FirebaseStorage.instance
  //           .ref("slideshow/${doc.data()['image_name']}")
  //           .getDownloadURL();
  //       return url;
  //     })).then((urls) {
  //       featuredImageURLs.clear();
  //       setState(() {
  //         featuredImageURLs.addAll(urls);
  //       });
  //     });
  //   });

  //   BackendManager.loadCategories().then((categories) {
  //     this.categories.clear();
  //     setState(() {
  //       this.categories.addAll(categories);
  //     });
  //   });
  //   NewsArticle.loadArticles().then((articles) {
  //     this.articles.clear();
  //     setState(() {
  //       this.articles.addAll(articles);
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    if (!isReady) return LoadingScreen();
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 4,
          shadowColor: Theme.of(context).shadowColor,
          title: const Text('Yeshivat Torat Shraga'),
        ),
        bottomNavigationBar: TabBar(tabs: [
          Tab(icon: Icon(Icons.home), text: "Home"),
          Tab(icon: Icon(Icons.bookmark), text: "Bookmarked"),
          Tab(icon: Icon(Icons.article), text: "Articles"),
        ]),
        body: TabBarView(
          children: [
            HomePage(),
            // rebbeim: rebbeim,
            // categories: categories,
            // featuredImageURLs: featuredImageURLs,
            // recentShiurim: recentShiurim),
            FavoritesScreen(),
            NewsScreen(),
            // Placeholder(),
          ],
        ),
      ),
    );
  }
}
