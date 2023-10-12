import 'package:flow_app/screen/login.dart';

import 'screen/session_page.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'providers/firebase.dart'; // Make sure this import path is correct
import 'package:provider/provider.dart';
import 'providers/game_code.dart';
import './screen/code_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AudioURLProvider()),
        ChangeNotifierProvider(create: (context) => ImageURLProvider()),
        ChangeNotifierProvider(create: (context) => PromptProvider()),
        ChangeNotifierProvider(create: (context) => GameCodeProvider()),
        // ... other providers
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
      ),
      home: StartPage(),
    );
  }
}
