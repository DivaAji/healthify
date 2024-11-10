import 'package:flutter/material.dart';

class MyDetailProgram extends StatelessWidget {
  final String programName;
  final String programImage;

  const MyDetailProgram({
    Key? key,
    required this.programName,
    required this.programImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(programName),
      ),
      body: Center(
        child: Column(
          children: [
            Image.asset(
              'assets/images/$programImage',
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity,
            ),
            SizedBox(height: 20),
            Text(
              programName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            // Tambahkan informasi detail lainnya di sini
          ],
        ),
      ),
    );
  }
}
