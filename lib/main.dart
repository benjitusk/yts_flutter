import 'package:yts_flutter/utils.dart';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:yts_flutter/classes/audio_manager.dart';
import 'package:yts_flutter/widgets/helpers/Constants.dart';
import 'package:yts_flutter/widgets/mini_player.dart';
import 'package:yts_flutter/widgets/pages/rabbi_page.dart';
import 'package:yts_flutter/widgets/screens/HomeScreen/settings_screen.dart';
import 'package:yts_flutter/widgets/screens/favorites_screen.dart';
import 'package:yts_flutter/widgets/screens/home_screen.dart';
import 'package:yts_flutter/widgets/screens/home_screen_modal.dart';
import 'package:yts_flutter/widgets/screens/loading_screen.dart';
import 'package:yts_flutter/widgets/screens/news_screen.dart';
import 'package:yts_flutter/widgets/screens/search_screen.dart';

late AudioHandler audioHandler;

void main() async {
  // Initialize services
  await initApp();
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
  void initState() {
    homeScreenModel.onFinishedLoading = () => setState(() => isLoading = false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    //     overlays: [SystemUiOverlay.top]);
    return Stack(children: [
      DefaultTabController(
        length: 4,
        child: StreamBuilder(
            stream: AudioManager.instance.currentContentStream,
            builder: (context, snapshot) {
              return Scaffold(
                appBar: AppBar(
                  elevation: 4,
                  shadowColor: Theme.of(context).shadowColor,
                  title: const Text('Yeshivat Torat Shraga'),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () async {
                        final result = await showSearch(
                          context: context,
                          delegate: ContentSearch(
                            // newsArticles: homeScreenModel.,
                            shiurim: homeScreenModel
                                .recentShiurimModel.recentShiurim,
                            rebbeim: homeScreenModel.rebbeimRowModel.rebbeim,
                          ),
                        );
                        if (result?.$1 != null) {
                          AudioManager().showMediaPlayer(context);
                          await AudioManager().loadContent(result!.$1!);
                          await AudioManager().play();
                        } else if (result?.$2 != null) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    RabbiPage(rabbi: result!.$2!)),
                          );
                        }
                      },
                    ),
                  ],
                ),
                persistentFooterButtons:
                    snapshot.data != null ? [MiniPlayer()] : null,
                bottomNavigationBar: TabBar(tabs: [
                  Tab(icon: Icon(Icons.home), text: "Home"),
                  Tab(icon: Icon(Icons.bookmark), text: "Bookmarked"),
                  Tab(icon: Icon(Icons.article), text: "Articles"),
                  Tab(icon: Icon(Icons.settings), text: "Settings")
                ]),
                body: TabBarView(
                  children: [
                    HomeScreen(
                      model: homeScreenModel,
                    ),
                    FavoritesScreen(),
                    NewsScreen(),
                    SettingsScreen(),
                  ],
                ),
              );
            }),
      ),
      if (isLoading) LoadingScreen(onSponsorhipLoaded: homeScreenModel.loadAll)
    ]);
  }
}
