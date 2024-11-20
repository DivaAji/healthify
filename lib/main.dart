import 'package:flutter/material.dart';
import 'package:healthify/screens/profile/profile_screen.dart';
import 'package:healthify/screens/welcome/splash_screen.dart';
import 'package:healthify/screens/profile/profile_screen.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Galatea',
      ),
      home: ProfileScreen(),
      // routes: {
      //   '/login': (context) => LoginScreen(),
      // },
    );
  }
}
