import 'package:flutter/material.dart';
import 'package:music_player/home.dart';
import 'package:music_player/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

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
      title: 'Chords Core',
      theme: ThemeData.dark(),
      initialRoute: '/login',
      routes: {
        '/login': (context) =>  SignInPage(),
        '/home': (context) =>  HomeView(),
      },
    );
  }
}
