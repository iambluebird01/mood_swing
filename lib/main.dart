import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MoodSwingApp());
}

class MoodSwingApp extends StatefulWidget {
  static _MoodSwingAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MoodSwingAppState>();

  @override
  _MoodSwingAppState createState() => _MoodSwingAppState();
}

class _MoodSwingAppState extends State<MoodSwingApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme(bool isDarkMode) {
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoodSwing',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 16),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.teal,
      ),
      themeMode: _themeMode,
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
