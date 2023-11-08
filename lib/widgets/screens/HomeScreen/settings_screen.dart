import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yts_flutter/utils.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final bloc = SettingsBloc();
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: bloc,
        builder: (context, snapshot) {
          return ListView(
            padding: const EdgeInsets.all(8.0),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Settings",
                    style: Theme.of(context).textTheme.headlineMedium),
              ),
              // Spacer
              Card(
                clipBehavior: Clip.hardEdge,
                // Link to notifications settings page
                child: ListTile(
                    leading: const Icon(Icons.notifications_active),
                    trailing: const Icon(Icons.chevron_right),
                    title: const Text("Notifications"),
                    subtitle: const Text("Manage notifications from YTS"),
                    onTap: () {
                      FirebaseMessaging.instance.requestPermission();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Scaffold(
                                appBar: AppBar(title: Text("Notifications")),
                                body: ListenableBuilder(
                                    listenable: bloc,
                                    builder: (context, snapshot) {
                                      return ListView(
                                        padding: const EdgeInsets.all(8.0),
                                        children: [
                                          Card(
                                            child: ListTile(
                                              leading: const Icon(
                                                  Icons.notifications),
                                              title:
                                                  const Text("Notifications"),
                                              subtitle: const Text(
                                                  "Manage notifications from YTS"),
                                              trailing: Switch(
                                                // This bool value toggles the switch.
                                                value:
                                                    bloc.isNotificationsEnabled,
                                                onChanged:
                                                    bloc.setNotifications,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                              )));
                    }),
              ),
              Card(
                  clipBehavior: Clip.hardEdge,
                  child: ListTile(
                      leading: const Icon(Icons.cloud_upload_rounded),
                      title: const Text("Upload a shiur"),
                      subtitle: const Text(
                          "Submit a shiur to be uploaded to the app"),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => null)),
              Card(
                  clipBehavior: Clip.hardEdge,
                  child: ListTile(
                      leading: const Icon(Icons.card_giftcard),
                      title: const Text("Sponsor learning at Yeshiva"),
                      subtitle: const Text(
                          "Sponsor the learning in Yeshiva and on the app"),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: onSponsorshipPromptClick)),
              Card(
                  clipBehavior: Clip.hardEdge,
                  child: ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: const Text("About"),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Scaffold(
                                appBar: AppBar(title: Text("About")),
                                body: _AboutPage(
                                  bloc: bloc,
                                ),
                              )))))
            ],
          );
        });
  }
}

class _AboutPage extends StatelessWidget {
  final SettingsBloc bloc;
  const _AboutPage({required this.bloc});
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: bloc,
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
            child: Column(
              // As big as the screen
              mainAxisSize: MainAxisSize.max,
              children: [
                Card(
                    clipBehavior: Clip.hardEdge,
                    child: ListTile(
                      leading:
                          // ColorFiltered(
                          //   colorFilter: ColorFilter.mode(
                          //       Theme.of(context).colorScheme.onBackground, BlendMode.srcATop),
                          //   child:
                          ShragaLogo(dark: isDarkTheme(context)),
                      // ),
                      title: Text("Yeshivat Torat Shraga"),
                      subtitle: Text("Developed by Benji Tusk"),
                      onLongPress: () =>
                          bloc.setDevMode(!bloc.isDevModeEnabled),
                    )),
                Spacer(),
                // Version number
                Row(
                  children: [
                    Text(getCopyrightText(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.5))),
                    Spacer(),
                    FutureBuilder<PackageInfo>(
                      future: PackageInfo.fromPlatform(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.done:
                            return Align(
                              alignment: Alignment.bottomCenter,
                              child: bloc.isDevModeEnabled
                                  ? GradientText(
                                      'Version: ${snapshot.data?.version} (${snapshot.data?.buildNumber}) DEV',
                                      gradient: LinearGradient(colors: [
                                        Colors.blue.shade400,
                                        Colors.blue.shade900,
                                      ]))
                                  : Text(
                                      'Version: ${snapshot.data?.version} (${snapshot.data?.buildNumber})',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground
                                                  .withOpacity(0.5)),
                                    ),
                            );
                          default:
                            return const SizedBox();
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  String getCopyrightText() {
    final year = DateTime.now().year;
    String copyRightText = "© Benji Tusk 2023";
    if (year > 2023) {
      return copyRightText + "-$year";
    } else {
      return copyRightText;
    }
  }
}

class SettingsBloc extends ChangeNotifier {
  SharedPreferences? _prefs;
  bool _isDevModeEnabled = false;
  bool get isDevModeEnabled => _isDevModeEnabled;
  bool _isNotificationsEnabled = false;
  bool get isNotificationsEnabled => _isNotificationsEnabled;

  SettingsBloc() {
    SharedPreferences.getInstance().then((prefs) {
      _isDevModeEnabled = prefs.getBool('devMode') ?? false;
      _isNotificationsEnabled = prefs.getBool('notifications') ?? false;
      notifyListeners();
      _prefs = prefs;
    });
  }

  void setDevMode(bool value) async {
    if (_prefs == null) return;
    _isDevModeEnabled = value;
    notifyListeners();
    _prefs?.setBool('devMode', value);
  }

  void setNotifications(bool value) async {
    if (_prefs == null) return;
    _isNotificationsEnabled = value;
    notifyListeners();
    if (value) {
      final permissions = await FirebaseMessaging.instance.requestPermission();
      if (permissions.authorizationStatus == AuthorizationStatus.authorized) {
        print("Notifications enabled");
        FirebaseMessaging.instance.subscribeToTopic('all');
      } else {
        // TODO: Show a dialog explaining why we need notifications
      }
    } else {
      print("Notifications disabled");
      FirebaseMessaging.instance.unsubscribeFromTopic('all');
    }
    _prefs?.setBool('notifications', value);
  }
}
