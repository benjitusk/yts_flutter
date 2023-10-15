import 'package:audio_service/audio_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:safe_device/safe_device.dart';
import 'package:yts_flutter/classes/audio_manager.dart';
import 'package:yts_flutter/firebase_options.dart';

class Constants {
  static double MarqueeVelocity = 35.0;
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

Future<void> initApp() async {
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
  await FirebaseAnalytics.instance
      .logAppOpen(callOptions: AnalyticsCallOptions(global: true));
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
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("onMessage: ${message}");
  });
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("onMessageOpenedApp: $message");
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}
