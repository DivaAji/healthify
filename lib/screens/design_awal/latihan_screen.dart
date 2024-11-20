// berisi program yang sedang berlangsung

import 'package:flutter/material.dart';

class MyLatihan extends StatefulWidget {
  const MyLatihan({super.key});

  @override
  State<MyLatihan> createState() => _MyLatihan();
}

class _MyLatihan extends State<MyLatihan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text(
        'Ini adalah halaman Latihan',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
