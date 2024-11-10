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
            height: 200,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/kelenturan.jpg'), // Ganti dengan path gambar banner
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
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Row(
                        children: [
                          Icon(Icons.timer, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            '10 menit',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Back button on the banner
                Positioned(
                  top: 16,
                  left: 5,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context); // Navigate back to the previous screen
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Teks Center
          const Center(
            child: Text(
              'Panduan',
              style: TextStyle(fontSize: 20, color: Color(0xFF21324B), fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 4),

          // Teks
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Video Latihan',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Color(0xFF21324B)),
            ),
          ),

          const SizedBox(height: 16),

          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '5 Latihan',
                style: TextStyle(fontSize: 16, color: Color(0xFF21324B)),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Daftar latihan
          Expanded(
            child: ListView(
              children: [
                _buildExerciseItem('Pemanasan', '00:45'),
                _buildExerciseItem('Peregangan', '01:00'),
                _buildExerciseItem('Latihan Kekuatan', '01:30'),
                _buildExerciseItem('Pendinginan', '00:30'),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: CustomButton(
            text: 'Start',
            onPressed: () {
              // Navigasi ke halaman ExerciseScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Latihan1Screen()),
              );
            },
            // Optional: You can customize padding if needed
            horizontalPadding: 10.0,
            verticalPadding: 5.0,
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
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4.0,
                  offset: Offset(0,  2),
                ),
              ],
            ),
            child: const Icon(Icons.fitness_center, color: Colors.black),
          ),
          const SizedBox(width: 16),

          // Kolom 2: Teks Latihan dan Durasi
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exerciseName,
                  style: const TextStyle(fontSize: 18, color: Color(0xFF21324B), fontWeight: FontWeight.bold),
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