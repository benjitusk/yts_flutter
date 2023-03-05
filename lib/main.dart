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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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
