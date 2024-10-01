import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:inspection/screens/newhomePage.dart';
import 'package:inspection/pages/loginPage.dart';
import 'package:inspection/screens/profilePage.dart';
import 'package:inspection/screens/settingsPage.dart';
import 'package:inspection/pages/finalVerdict.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  // Variable to hold the initial screen
  Widget _initialScreen = const CircularProgressIndicator();
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }
  Future<void> _checkLoginStatus() async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      if (user != null) {
        // User is signed in, show homepage
        _initialScreen = Homepage();
      } else {
        // User is not signed in, show login page
        _initialScreen = const LoginPage();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child:
              _initialScreen, // Show the initial screen based on login status
        ),
      ),
      routes: {
        '/home': (context) => Homepage(),
        '/profile': (context) => const ProfilePage(),
        '/login': (context) => const LoginPage(),
        '/settings': (context) => const SettingsPage(),
        '/finalverdict': (context) => const Finalverdict(),
      },
    );
  }
}
