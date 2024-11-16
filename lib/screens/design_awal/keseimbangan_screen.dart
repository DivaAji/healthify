import 'package:flutter/material.dart';

class KeseimbanganScreen extends StatelessWidget {
  final String title;

  const KeseimbanganScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text(
          'Selamat datang di $title',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

