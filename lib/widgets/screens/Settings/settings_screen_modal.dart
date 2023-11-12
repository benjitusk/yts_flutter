import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  void setDevMode(bool value, BuildContext ctx) async {
    if (_prefs == null) return;
    if (value) {
      final permissions = await FirebaseMessaging.instance.requestPermission();
      if (permissions.authorizationStatus == AuthorizationStatus.authorized) {
        FirebaseMessaging.instance.subscribeToTopic('debug');
      } else {
        value = false;
        showDialog(
            context: ctx,
            builder: (context) => AlertDialog(
                  title: Text("Notifications required"),
                  content: Text(
                      "Developer mode requires notifications to be enabled. Please enable notifications in your device settings and try again."),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text("OK"))
                  ],
                ));
      }
    } else {
      FirebaseMessaging.instance.unsubscribeFromTopic('debug');
    }
    _isDevModeEnabled = value;
    notifyListeners();
    _prefs?.setBool('devMode', value);
  }

  void setNotifications(bool value, BuildContext ctx) async {
    if (_prefs == null) return;
    if (value) {
      final permissions = await FirebaseMessaging.instance.requestPermission();
      if (permissions.authorizationStatus == AuthorizationStatus.authorized) {
        FirebaseMessaging.instance.subscribeToTopic('all');
      } else {
        value = false;
        showDialog(
            context: ctx,
            builder: (context) => AlertDialog(
                  title: Text("Notifications required"),
                  content: Text(
                      "Notifications cannot be enabled. Please enable notifications in your device settings and try again."),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text("OK"))
                  ],
                ));
      }
    } else {
      FirebaseMessaging.instance.unsubscribeFromTopic('all');
    }
    _isNotificationsEnabled = value;
    notifyListeners();
    _prefs?.setBool('notifications', value);
  }
}
