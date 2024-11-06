import 'dart:ui'; // Import ini diperlukan untuk BackdropFilter
import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  final Widget child; // Menambahkan properti child

  const MyCard({super.key, required this.child}); // Ubah konstruktor

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:
          BorderRadius.all(Radius.circular(20)), // Menambahkan border radius
      child: BackdropFilter(
        filter: ImageFilter.blur(
            sigmaX: 10.0, sigmaY: 10.0), // Mengurangi sedikit tingkat blur
        child: Container(
          width: 300, // Lebar card
          height: 400, // Tinggi card
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7), // Warna putih lebih terang
            border: Border.all(
              color: Colors.white.withOpacity(0.9), // Border lebih solid
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black
                    .withOpacity(0.1), // Warna bayangan lebih lembut
                blurRadius: 8, // Radius blur bayangan
                offset: Offset(0, 4), // Posisi bayangan
              ),
            ],
          ),
          child: child, // Gunakan child di sini
        ),
      ),
    );
  }
}
