import 'package:flutter/material.dart';
import 'package:healthify/screens/program/day/latihan/latihan1_screen.dart';
import 'package:healthify/widgets/button.dart';

class Day1Screen extends StatelessWidget {
  final int day;

  const Day1Screen({Key? key, required this.day}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Banner
          Container(
            height: 300,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/kelenturan.jpg'), // Ganti dengan path gambar banner
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  bottom: 20,
                  left: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Latihan Hari $day',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.timer, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            'Durasi: 10 menit',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Teks Center
          Center(
            child: Text(
              'Panduan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 4),

          // Teks
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
          //   child: Text(
          //     'Video Latihan',
          //     textAlign: TextAlign.center,
          //     style: TextStyle(fontSize: 16),
          //   ),
          // ),

          // const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              '5 Latihan', //jumlah latihan disesuikan database
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16),
            ),
          ),

          // Daftar latihan
          Expanded(
            child: ListView(
              children: [
                _buildExerciseItem('Pemanasan', '5 menit'),
                _buildExerciseItem('Peregangan', '10 menit'),
                _buildExerciseItem('Latihan Kekuatan', '15 menit'),
                _buildExerciseItem('Pendinginan', '5 menit'),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: CustomButton(
            text: 'Start',
            onPressed: () {
              // Navigasi ke halaman Latihan1Screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Latihan1Screen()),
              );
            },
            horizontalPadding:
                10.0, // Mengatur padding horizontal jika diperlukan
            verticalPadding: 10.0,
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseItem(String exerciseName, String duration) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          // Kolom 1: Ikon
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color(0xFF78B9BA),
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Icon(Icons.fitness_center, color: Colors.black),
          ),
          const SizedBox(width: 16),

          // Kolom 2: Teks Latihan dan Durasi
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exerciseName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  duration,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
