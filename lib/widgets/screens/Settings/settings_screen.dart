import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:yts_flutter/utils.dart';
// import 'package:yts_flutter/widgets/screens/Settings/Upload/upload_screen.dart';
import 'package:yts_flutter/widgets/screens/Settings/settings_screen_modal.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

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
                                                onChanged: (value) =>
                                                    bloc.setNotifications(
                                                        value, context),
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
                    leading: const Icon(Icons.mic_none_outlined),
                    title: const Text("Upload a shiur"),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: null,
                    enabled: false,
                    subtitle: const Text("This feature is not yet available"),
                    // () => Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => Scaffold(
                    //           appBar: AppBar(title: Text("Upload a shiur")),
                    //           body: UploadShiurScreen(),
                    //         )))
                  )),
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
                                appBar: AppBar(title: Text("Upload")),
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
                      onLongPress: () => showDialog(
                          context: context,
                          builder: (alertContext) => AlertDialog(
                                title: Text("Developer mode"),
                                content: Text("Developer mode enables extra features for testing and debugging. " +
                                    "Certain features may not work as expected, and you may receive unwanted notifications. " +
                                    "You can check the version number at the bottom of the screen to see if you are in developer mode. " +
                                    "You can ${bloc.isDevModeEnabled ? "enable" : "disable"} developer mode again at any time by holding down on the YTS card.\n\n" +
                                    "Are you sure you want to ${bloc.isDevModeEnabled ? "disable" : "enable"} developer mode?"),
                                actions: [
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.of(alertContext).pop(),
                                      child: Text("Cancel")),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(alertContext).pop();
                                        bloc.setDevMode(
                                            !bloc.isDevModeEnabled, context);
                                      },
                                      child: Text(
                                          bloc.isDevModeEnabled
                                              ? "Disable"
                                              : "Enable",
                                          style: TextStyle(
                                              color: Colors.red.shade400)))
                                ],
                              )),
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
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
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
