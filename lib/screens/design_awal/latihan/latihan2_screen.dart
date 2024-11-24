import 'package:flutter/material.dart';
import 'dart:async';

// Halaman baru yang akan dituju
class Latihan2Screen extends StatefulWidget {
  @override
  _Latihan2ScreenState createState() => _Latihan2ScreenState();
}

class _Latihan2ScreenState extends State<Latihan2Screen> {
  int _start = 3; // Waktu countdown mulai dari 45 detik
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
        _navigateToNextPage(); // Navigasi ke halaman baru
      }
    });
  }

  void _pauseTimer() {
    setState(() {
      _isPaused = !_isPaused; // Toggle pause state
    });
  }

  void _navigateToNextPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HalamanSelesai()), // Ganti dengan halaman tujuan
    );
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
                image: AssetImage('assets/images/banner.png'), // Ganti dengan path gambar banner
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

          // Progress Bar dan Button Pause dalam satu Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 20,
                  backgroundColor: Colors.grey[300],
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 10), // Jarak antara progress bar dan tombol
              ElevatedButton(
                onPressed: _pauseTimer,
                child: Text(_isPaused ? 'Resume' : 'Pause'),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// Halaman tujuan setelah countdown selesai
class HalamanSelesai extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selesai'),
      ),
      body: Center(
        child: Text(
          'Countdown telah selesai!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}