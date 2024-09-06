import 'package:flutter/material.dart';
import 'package:inspection/pages/carDetails.dart';
import 'package:inspection/pages/finalVerdict.dart';
import 'package:inspection/pages/homePage.dart';
import 'package:inspection/pages/inspectionPage.dart';
import 'package:inspection/pages/loginPage.dart';
import 'package:inspection/pages/profilePage.dart';
import 'package:inspection/pages/settingsPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        // '/cardetails': (context) => const CarInspectionApp(task: {
        //       'car': 'ABC123',
        //     }),
        '/finalverdict': (context) => const Finalverdict(),
      },
    );
  }
}