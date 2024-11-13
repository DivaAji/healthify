import 'package:flutter/material.dart';
import 'package:healthify/screens/faceScan_screen.dart';
import 'package:healthify/screens/splash_screen.dart';
import 'package:healthify/screens/login_screen.dart'; // Impor halaman login

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Galatea', // Terapkan font Galatea secara global
      ),
      home: FaceScan(userId: 1),
      routes: {
        '/login': (context) => LoginScreen(), // Rute untuk halaman login
      },
    );
  }
}
