import 'package:flutter/material.dart';
import 'package:music_player/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:music_player/ui.dart';
import 'firebase_options.dart';


Future<void> main() async {
  await Firebase.initializeApp(

    options: DefaultFirebaseOptions.currentPlatform,

);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginPage(),
      routes: {
        '/music': (context) => MusicPlayerPage(),
      },
    );
  }
}