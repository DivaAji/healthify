import 'package:flutter/material.dart';
import 'dart:async';

class Latihan1Screen extends StatefulWidget {
  @override
  _Latihan1ScreenState createState() => _Latihan1ScreenState();
}

class _Latihan1ScreenState extends State<Latihan1Screen> {
  int _start = 1; // Waktu countdown mulai dari 10 detik
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
          MaterialPageRoute(builder: (context) => HalamanBaru()), // Ganti dengan halaman tujuan
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
        title: const Text('Latihan 1'),
      ),
      body: Column(
        children: [
          // Banner
          Container(
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/shape.png'), // Ganti dengan path gambar banner
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Teks Center 1
          Center(
            child: Text(
              'Selamat datang di Latihan 1!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),

          // Teks Center 2
          Center(
            child: Text(
              'Siap untuk memulai?',
              style: TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(height: 40),

          // Lingkaran dengan Angka Countdown
          Center(
            child: Container(
              width: 100, // Lebar lingkaran
              height: 100, // Tinggi lingkaran
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red, // Warna lingkaran
              ),
              alignment: Alignment.center,
              child: Text(
                '$_start',
                style: TextStyle(
                  fontSize: 36,
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
                image: AssetImage('assets/images/shape.png'), // Ganti dengan path gambar banner
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