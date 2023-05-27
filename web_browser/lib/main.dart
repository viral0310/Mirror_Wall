import 'package:flutter/material.dart';
import 'package:web_browser/screens/homepage.dart';
import 'package:web_browser/screens/intro_Screen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => IntroScreen(),
      '/home': (context) => HomePage(),
    },
  ));
}
