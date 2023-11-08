import 'package:audio_service/audio_service.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:safe_device/safe_device.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yts_flutter/classes/audio_manager.dart';
import 'package:yts_flutter/firebase_options.dart';

typedef CallbackCallback = Future<VoidCallback> Function();

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

Widget ShragaLogo(
    {bool dark = false, double? height = null, bool animated = false}) {
  final fileExtension = animated ? 'gif' : 'png';
  final colorSpecification = dark ? 'white' : 'black';
  return Image(
    image: AssetImage('assets/Shraga_$colorSpecification.$fileExtension'),
    height: height,
  );
}

bool isDarkTheme(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark;
}

Future<void> onSponsorshipPromptClick() async {
  await launchUrl(Uri(
      path: "office@toratshraga.com",
      scheme: "mailto",
      queryParameters: {"subject": "Sponsorship Inquiry"}));
}

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    required this.gradient,
    this.style,
  });

  final String text;
  final TextStyle? style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}

Widget AutoMarqueeText(String text, {TextStyle? style, double? velocity}) {
  return AutoSizeText(
    text,
    maxLines: 1,
    style: style,
    overflowReplacement: Marquee(
      text: text,
      style: style,
      velocity: velocity ?? 50,
      startAfter: const Duration(seconds: 1),
      blankSpace: 20,
      fadingEdgeStartFraction: 0.1,
      fadingEdgeEndFraction: 0.1,
      pauseAfterRound: const Duration(seconds: 1),
    ),
  );
}
