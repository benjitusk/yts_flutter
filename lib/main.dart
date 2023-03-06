import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:yts_flutter/widgets/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // App Check
  await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.debug,
      webRecaptchaSiteKey: "recaptcha-v3-site-key");
  // Anonymously sign in
  await FirebaseAuth.instance.signInAnonymously();
  runApp(const MyApp());
}

final theme = ThemeData();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: theme.copyWith(
          colorScheme: theme.colorScheme.copyWith(
        primary: const Color(0xFF526B98),
        secondary: const Color(0xFFFCC730),
      )),

      // ThemeData(
      //   colorScheme: ColorScheme.,
      //     primarySwatch: MaterialColor(0xFF526B98, {
      //   50: Color(0xFFE8EAF6),
      //   100: Color(0xFFC5CAE9),
      //   200: Color(0xFF9FA8DA),
      //   300: Color(0xFF7986CB),
      //   400: Color(0xFF5C6BC0),
      //   500: Color(0xFF3F51B5),
      //   600: Color(0xFF3949AB),
      //   700: Color(0xFF303F9F),
      //   800: Color(0xFF283593),
      //   900: Color(0xFF1A237E),
      // })
      // ),
      home: DefaultTabController(
        length: 1,
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Yeshivat Torat Shraga'),
              // bottom: const TabBar(
              //   tabs: [
              //     Tab(icon: Icon(Icons.home)),
              //   ],
              // ),
            ),
            body: const HomePage()
            // TabBarView(
            //   children: [
            //     HomePage(),
            //   ],
            // ),
            ),
      ),
    );
  }
}
