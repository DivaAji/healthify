import 'package:flutter/material.dart';

class ProgramIndicator extends StatelessWidget {
  final String name;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final double fontSize;

  ProgramIndicator({
    required this.name,
    this.margin = const EdgeInsets.only(left: 20), // Default value
    this.padding = const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0), // Default value
    this.fontSize = 16.0, // Default value
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(33, 50, 75, 1),
        borderRadius: BorderRadius.circular(7),
      ),
      margin: margin, // Menggunakan variabel margin
      padding: padding, // Menggunakan variabel padding
      child: Text(
        name,
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Galatea',
          fontSize: fontSize, // Menggunakan variabel fontSize
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
