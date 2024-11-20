import 'package:flutter/material.dart';
import 'package:healthify/screens/design_awal/latihan/latihan2_screen.dart';
import 'dart:async';

import 'package:healthify/widgets/button.dart';

class Latihan1Screen extends StatefulWidget {
  @override
  _Latihan1ScreenState createState() => _Latihan1ScreenState();
}

class _Latihan1ScreenState extends State<Latihan1Screen> {
  int _start = 10; // Waktu countdown mulai dari 10 detik
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Memulai timer setiap detik
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_start > 0) {
        setState(() {
          _start--;
        });
      } else {
        _timer.cancel(); // Hentikan timer ketika countdown mencapai 0
        // Navigasi ke halaman baru
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Latihan2Screen()), // Ganti dengan halaman tujuan
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Hentikan timer saat widget dihapus
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Step 1'), //disesuaikan dengan banyaknya step
      ),
      body: Column(
        children: [
          // Banner
          Container(
            height: 300,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/shape.png'), //ganti dengan gambar latihan
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 35),

          Container(
            child: Center(
                child: Column(children: [
              Text(
                'Siap untuk memulai?',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                'Ambil poisi untuk gerakan: ',
                style: TextStyle(fontSize: 20),
              ),
            ])),
          ),
          const SizedBox(height: 15),
          Text(
            'Peregangan Kaki', //disesuaikan nama step latihan
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),

          // Lingkaran dengan Angka Countdown
          Center(
            child: Container(
              width: 125, // Lebar lingkaran
              height: 125, // Tinggi lingkaran
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red, // Warna lingkaran
              ),
              alignment: Alignment.center,
              child: Text(
                '$_start',
                style: TextStyle(
                  fontSize: 50,
                  color: Colors.white, // Warna teks di dalam lingkaran
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Halaman baru yang akan dituju
class HalamanBaru extends StatefulWidget {
  @override
  _HalamanBaruState createState() => _HalamanBaruState();
}

class _HalamanBaruState extends State<HalamanBaru> {
  int _start = 45; // Waktu countdown mulai dari 45 detik
  late Timer _timer;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_start > 0 && !_isPaused) {
        setState(() {
          _start--;
        });
      } else if (_start == 0) {
        _timer.cancel(); // Hentikan timer ketika countdown mencapai 0
      }
    });
  }

  void _pauseTimer() {
    setState(() {
      _isPaused = !_isPaused; // Toggle pause state
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Hentikan timer saat widget dihapus
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress = _start / 45; // Hitung progress bar

    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Baru'),
      ),
      body: Column(
        children: [
          // Banner
          Container(
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/shape.png'), // Ganti dengan path gambar banner
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Teks Center
          Center(
            child: Text(
              'Countdown Timer',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),

          // Countdown Timer
          Center(
            child: Text(
              '00:${_start.toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 36, color: Colors.red),
            ),
          ),
          const SizedBox(height: 20),

          // Progress Bar
          LinearProgressIndicator(
            value: progress,
            minHeight: 20,
            backgroundColor: Colors.grey[300],
            color: Colors.blue,
          ),
          const SizedBox(height: 20),

          // Button Pause
          ElevatedButton(
            onPressed: _pauseTimer,
            child: Text(_isPaused ? 'Resume' : 'Pause'),
          ),
        ],
      ),
    );
  }
}
