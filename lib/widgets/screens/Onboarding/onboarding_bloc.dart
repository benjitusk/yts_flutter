import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class OnboardingBloc extends ChangeNotifier {
  bool _isNotificationsEnabled = false;
  bool get isNotificationsEnabled => _isNotificationsEnabled;
  void enableNotifications(BuildContext ctx) async {
    showDialog(
        context: ctx,
        builder: (context) => AlertDialog(
              title: Text("Enable notifications?"),
              content: Text(
                  "You can opt in to receive notifications about new shiurim and other updates. You can change this setting at any time in the settings page."),
              actions: [
                TextButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      final permissions =
                          await FirebaseMessaging.instance.requestPermission();
                      if (permissions.authorizationStatus ==
                          AuthorizationStatus.authorized) {
                        FirebaseMessaging.instance.subscribeToTopic('all');
                        _isNotificationsEnabled = true;
                        notifyListeners();
                      } else {
                        showDialog(
                            context: ctx,
                            builder: (context) => AlertDialog(
                                  title: Text("Notifications required"),
                                  content: Text(
                                      "Notifications are required to receive updates. Please enable notifications in your device settings and try again."),
                                  actions: [
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: Text("OK"))
                                  ],
                                ));
                      }
                    },
                    child: Text("OK")),
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("Cancel"))
              ],
            ));
  }
}
