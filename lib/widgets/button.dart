import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double horizontalPadding;
  final double verticalPadding;
  final TextStyle? textStyle;
  final IconData? icon;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.horizontalPadding = 30.0,
    this.verticalPadding = 15.0,
    this.textStyle,
    this.icon,
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
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5,
        backgroundColor: const Color.fromRGBO(0, 139, 144, 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Icon(icon, color: Colors.white), // Menampilkan ikon jika ada
          if (icon != null)
            const SizedBox(width: 10), // Memberikan jarak jika ada ikon
          Text(
            text,
            style: const TextStyle(
              fontFamily: 'Galatea',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ).merge(textStyle), // Menggabungkan gaya default dengan textStyle
          ),
        ],
      ),
    );
  }
}
