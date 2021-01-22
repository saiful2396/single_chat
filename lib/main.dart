import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

import './view/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xFFFF75431),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: ThemeData.light().textTheme.copyWith(
              bodyText1: TextStyle(
                color: Colors.white,
                fontFamily: 'BungeeInline',
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
      ),
      home: LoginScreen(),
    );
  }
}
