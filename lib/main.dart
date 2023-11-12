import 'package:yts_flutter/utils.dart';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:yts_flutter/classes/audio_manager.dart';
import 'package:yts_flutter/widgets/helpers/Constants.dart';
import 'package:yts_flutter/widgets/screens/Onboarding/onboarding.dart';
import 'package:yts_flutter/widgets/screens/Player/mini_player.dart';
import 'package:yts_flutter/widgets/screens/HomeScreen/Rebbeim/rabbi_page.dart';
import 'package:yts_flutter/widgets/screens/Settings/settings_screen.dart';
import 'package:yts_flutter/widgets/screens/Bookmarks/favorites_screen.dart';
import 'package:yts_flutter/widgets/screens/HomeScreen/home_screen.dart';
import 'package:yts_flutter/widgets/screens/HomeScreen/home_screen_modal.dart';
import 'package:yts_flutter/widgets/screens/LoadingScreen/loading_screen.dart';
import 'package:yts_flutter/widgets/screens/News/news_screen.dart';
import 'package:yts_flutter/widgets/screens/Search/search_screen.dart';

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

class AppBody extends StatelessWidget {
  AppBody({
    super.key,
  });

  final homeScreenModel = HomeScreenModel();

  @override
  Widget build(BuildContext context) {
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
                  Tab(icon: Icon(Icons.bookmark), text: "Saved"),
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
      ListenableBuilder(
        listenable: homeScreenModel,
        builder: (context, _) {
          if (homeScreenModel.isFirstLaunch) {
            return Onboarding(
              onFinished: () => homeScreenModel.setFirstLaunch(false),
            );
          }
          if (homeScreenModel.isLoading)
            return LoadingScreen(
              onSponsorhipLoaded: homeScreenModel.initialLoad,
            );
          return Container();
        },
      )
    ]);
  }
}
