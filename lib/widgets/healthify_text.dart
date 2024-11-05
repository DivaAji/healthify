import 'package:flutter/material.dart';

class HealthifyText extends StatelessWidget {
  final double fontSize; // Ubah menjadi double untuk ukuran font

  const HealthifyText({Key? key, this.fontSize = 48}) : super(key: key); // Gunakan default value

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontFamily: 'Galatea',
          fontSize: fontSize, // Gunakan parameter fontSize
          fontWeight: FontWeight.w700,
          height: 1.25,
          shadows: [
            Shadow(
              color: Colors.black.withOpacity(0.25), // Bayangan
              offset: Offset(0, 4),
              blurRadius: 4,
            ),
          ],
        ),
        children: <TextSpan>[
          // Kata "Health"
          TextSpan(
            text: 'Health',
            style: TextStyle(color: const Color(0xFF21324B)), 
          ),
          // Kata 'ify'
          TextSpan(
            text: 'ify',
            style: TextStyle(color: const Color(0xFFE94D1F)), // Warna untuk 'ify'
          ),
        ],
      ),
    );
  }
}
