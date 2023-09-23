import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:safe_device/safe_device.dart';
import 'package:yts_flutter/classes/audio_manager.dart';
import 'package:yts_flutter/widgets/helpers/Constants.dart';
import 'package:yts_flutter/widgets/mini_player.dart';
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
  final isPhysicalDevice = await SafeDevice.isRealDevice;
  AndroidProvider androidProvider =
      isPhysicalDevice ? AndroidProvider.playIntegrity : AndroidProvider.debug;
  AppleProvider appleProvider =
      isPhysicalDevice ? AppleProvider.deviceCheck : AppleProvider.debug;
  await FirebaseAppCheck.instance
      .activate(androidProvider: androidProvider, appleProvider: appleProvider);
  // Anonymously sign in
  await FirebaseAuth.instance.signInAnonymously();

  // Initialize audio service
  print("Initializing audio service");
  await AudioService.init(
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
      title: 'Yeshivat Torat Shraga',
      debugShowCheckedModeBanner: false,
      theme: UI.lightTheme,
      darkTheme: UI.darkTheme,
      themeMode: ThemeMode.system,
      home: AppBody(),
    );
  }
}

class AppBody extends StatefulWidget {
  AppBody({
    super.key,
  });

  @override
  State<AppBody> createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
  bool isLoading = true;
  final homeScreenModel = HomeScreenModel();

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    //     overlays: [SystemUiOverlay.top]);
    homeScreenModel.onFinishedLoading = () => setState(() => isLoading = false);
    return Stack(children: [
      DefaultTabController(
        length: 3,
        child: StreamBuilder(
            stream: AudioManager.instance.currentContentStream,
            builder: (context, snapshot) {
              return Scaffold(
                appBar: AppBar(
                  elevation: 4,
                  shadowColor: Theme.of(context).shadowColor,
                  title: const Text('Yeshivat Torat Shraga'),
                ),
                persistentFooterButtons:
                    snapshot.data != null ? [MiniPlayer()] : null,
                bottomNavigationBar: TabBar(tabs: [
                  Tab(icon: Icon(Icons.home), text: "Home"),
                  Tab(icon: Icon(Icons.bookmark), text: "Bookmarked"),
                  Tab(icon: Icon(Icons.article), text: "Articles"),
                ]),
                body: TabBarView(
                  children: [
                    HomeScreen(
                      model: homeScreenModel,
                    ),
                    FavoritesScreen(),
                    NewsScreen(),
                  ],
                ),
              );
            }),
      ),
      if (isLoading) const LoadingScreen(),
    ]);
  }
}
