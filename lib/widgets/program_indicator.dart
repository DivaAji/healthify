import 'package:flutter/material.dart';

class ProgramIndicator extends StatelessWidget {
  final String name;

  ProgramIndicator({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(33, 50, 75, 1),
        borderRadius: BorderRadius.circular(7),
      ),
      margin: EdgeInsets.only(left: 20), 
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 10, right: 10),
      child: Text(
        name,
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Galatea',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
