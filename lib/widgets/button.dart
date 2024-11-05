import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double horizontalPadding; // Tambahkan parameter untuk horizontal padding
  final double verticalPadding;   // Tambahkan parameter untuk vertical padding

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.horizontalPadding = 30.0, // Nilai default horizontal padding
    this.verticalPadding = 15.0,   // Nilai default vertical padding
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(17),
        ),
        backgroundColor: const Color.fromRGBO(0, 139, 144, 1),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Galatea',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
