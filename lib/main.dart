import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:yts_flutter/classes/audio_manager.dart';
import 'package:yts_flutter/widgets/helpers/Constants.dart';
import 'package:yts_flutter/widgets/screens/favorites_screen.dart';
import 'package:yts_flutter/widgets/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yts_flutter/widgets/screens/home_screen_modal.dart';
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
  bool isLoading = true;
  final homeScreenModel = HomeScreenModel();

  void doStuff() {
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    homeScreenModel.onFinishedLoading = () => setState(() => isLoading = false);
    return Stack(children: [
      DefaultTabController(
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
              HomePage(
                model: homeScreenModel,
              ),
              FavoritesScreen(),
              NewsScreen(),
            ],
          ),
        ),
      ),
      if (isLoading) const LoadingScreen(),
    ]);
  }
}
