import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yts_flutter/utils.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
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
                          body: ListView(
                            padding: const EdgeInsets.all(8.0),
                            children: [
                              Card(
                                child: ListTile(
                                  leading: const Icon(Icons.notifications),
                                  title: const Text("Notifications"),
                                  subtitle: const Text(
                                      "Manage notifications from YTS"),
                                  trailing: Switch(
                                    // This bool value toggles the switch.
                                    value: false,
                                    activeColor: Colors.red,
                                    onChanged: null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )));
              }),
        ),
        Card(
            clipBehavior: Clip.hardEdge,
            child: ListTile(
                leading: const Icon(Icons.cloud_upload_rounded),
                title: const Text("Upload a shiur"),
                subtitle:
                    const Text("Submit a shiur to be uploaded to the app"),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => null)),
        Card(
            clipBehavior: Clip.hardEdge,
            child: ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text("About"),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Scaffold(
                          appBar: AppBar(title: Text("About")),
                          body: _AboutPage(),
                        )))))
      ],
    );
  }
}

class _AboutPage extends StatelessWidget {
  _AboutPage();
  final bloc = AboutBloc();
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        Card(
            child: ListTile(
          leading:
              // ColorFiltered(
              //   colorFilter: ColorFilter.mode(
              //       Theme.of(context).colorScheme.onBackground, BlendMode.srcATop),
              //   child:
              ShragaLogo(dark: isDarkTheme(context)),
          // ),
          title: Text("Yeshivat Torat Shraga"),
          subtitle:
              Text("App developed by Benji Tusk (${bloc.isDevModeEnabled})"),
          onTap: () => bloc.setDevMode(!bloc.isDevModeEnabled),
        )),
      ],
    );
  }
}

class AboutBloc extends ChangeNotifier {
  bool _isDevModeEnabled = false;
  bool get isDevModeEnabled => _isDevModeEnabled;

  AboutBloc() {
    SharedPreferences.getInstance().then((prefs) {
      _isDevModeEnabled = prefs.getBool('devMode') ?? false;
      notifyListeners();
    });
  }

  void setDevMode(bool value) async {
    _isDevModeEnabled = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('devMode', value);
  }
}
