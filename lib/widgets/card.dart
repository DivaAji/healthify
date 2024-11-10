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
          height: 420, // Tinggi card
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(
                0.3), // Warna putih lebih transparan untuk efek kaca
            border: Border.all(
              color: const Color.fromARGB(255, 255, 255, 255)
                  .withOpacity(0.3), // Border lebih tipis dengan transparansi
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 205, 205, 205)
                    .withOpacity(0.2), // Bayangan yang lebih halus
                blurRadius: 10, // Radius blur bayangan untuk efek lebih lembut
                offset: Offset(0, 4), // Posisi bayangan
              ),
            ],
          ),
          child: Stack(
            // Menambahkan Stack untuk menambahkan stroke
            children: [
              // Layer putih untuk stroke
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                          Colors.white.withOpacity(0.7), // Warna stroke putih
                      width: 1, // Lebar stroke putih
                    ),
                    borderRadius:
                        BorderRadius.circular(20), // Border radius yang sama
                  ),
                ),
              ),
              child, // Konten asli di dalam card
            ],
          ),
        ),
      ),
    );
  }
}
