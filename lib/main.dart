import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:inspection/pages/carDetails.dart';
import 'package:inspection/pages/finalVerdict.dart';
import 'package:inspection/pages/homePage.dart';
// import 'package:inspection/pages/inspectionPage.dart';
import 'package:inspection/pages/loginPage.dart';
import 'package:inspection/pages/profilePage.dart';
import 'package:inspection/pages/settingsPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
      routes: {
        '/home': (context) => const Homepage(),
        '/profile': (context) => const ProfilePage(),
        '/login': (context) => const LoginPage(),
        '/settings': (context) => const SettingsPage(),
        '/inspection': (context) => const InspectionPage(),
        '/finalverdict': (context) => const Finalverdict(),
      },
    );
  }
}
