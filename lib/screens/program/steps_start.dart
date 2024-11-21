import 'package:flutter/material.dart';
import 'package:healthify/screens/program/steps_finish.dart';
import 'dart:async';
import 'package:healthify/widgets/button.dart';

class ProgramSteps extends StatefulWidget {
  final List<Map<String, String>> steps; // Daftar langkah latihan
  final int currentStep; // Langkah awal (dapat disesuaikan)

  const ProgramSteps({
    super.key,
    required this.steps,
    required this.currentStep,
  });

  @override
  _ProgramStepsState createState() => _ProgramStepsState();
}

class _ProgramStepsState extends State<ProgramSteps> {
  late int _currentStep; // Menyimpan langkah saat ini
  int _start = 7; // Waktu hitung mundur awal sebelum latihan dimulai
  late Timer _initialTimer; // Timer untuk hitung mundur awal
  bool _isCountdownFinished = false; // Menandai apakah hitung mundur selesai

  int _timerDuration = 5; // Waktu latihan per langkah (menjadi 45 detik)
  late Timer _timer; // Timer untuk waktu latihan per langkah
  bool _isPaused = false; // Status apakah timer sedang dijeda

  @override
  void initState() {
    super.initState();
    _currentStep = widget.currentStep; // Inisialisasi langkah saat ini
    _startInitialTimer(); // Mulai hitung mundur awal
  }

  // Fungsi untuk memulai hitung mundur awal (7 detik)
  void _startInitialTimer() {
    _initialTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start > 0) {
        setState(() {
          _start--; // Kurangi waktu hitung mundur setiap detik
        });
      } else {
        setState(() {
          _isCountdownFinished = true; // Tandai hitung mundur selesai
        });
        _initialTimer.cancel(); // Hentikan timer awal
        _startTimer(); // Mulai timer untuk latihan
      }
    });
  }

  // Fungsi untuk memulai timer latihan (45 detik)
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerDuration > 0 && !_isPaused) {
        setState(() {
          _timerDuration--; // Kurangi waktu setiap detik
        });
      } else if (_timerDuration == 0) {
        _timer.cancel(); // Hentikan timer jika waktu habis
        _nextStep(); // Pindah ke langkah berikutnya
      }
    });
  }

  // Fungsi untuk menjeda atau melanjutkan timer
  void _pauseTimer() {
    setState(() {
      _isPaused = !_isPaused; // Toggle status pause/resume
    });
  }

  // Fungsi untuk pindah ke langkah berikutnya
  void _nextStep() {
    if (_currentStep < widget.steps.length - 1) {
      setState(() {
        _currentStep++; // Langkah bertambah
        _isCountdownFinished = false; // Reset status hitung mundur
        _start = 10; // Reset hitung mundur awal
        _timerDuration = 5; // Reset timer latihan ke 45 detik
        _startInitialTimer(); // Mulai lagi hitung mundur awal
      });
    } else {
      // Jika langkah terakhir selesai, arahkan ke halaman StepsFinish
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const StepsFinish(),
        ),
      );
    }
  }

  @override
  void dispose() {
    // Pastikan semua timer dihentikan ketika widget dihancurkan
    _initialTimer.cancel();
    if (_isCountdownFinished) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Hitung progress untuk LinearProgressIndicator (perbaikan)
    double progress =
        (_timerDuration / 5); // Progress berdasarkan timer yang benar

    // Data langkah saat ini
    final currentStepData = widget.steps[_currentStep];

    return Scaffold(
      appBar: AppBar(
        title: Text('Step ${_currentStep + 1}'), // Menampilkan nomor langkah
      ),
      body: Column(
        children: [
          // Banner gambar langkah
          Container(
            height: 300,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(currentStepData['image']!), // Gambar langkah
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 35),

          // Jika hitung mundur belum selesai, tampilkan pesan persiapan
          if (!_isCountdownFinished)
            Column(
              children: const [
                Text(
                  'Siap untuk memulai?',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  'Ambil posisi untuk gerakan:',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          const SizedBox(height: 15),

          // Nama langkah latihan
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              currentStepData['step']!, // Nama langkah
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 40),

          // Tampilkan countdown (waktu tersisa) atau progress latihan
          if (!_isCountdownFinished)
            Center(
              child: Container(
                width: 125,
                height: 125,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$_start', // Hitung mundur awal
                  style: const TextStyle(
                    fontSize: 50,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          else
            Column(
              children: [
                Text(
                  '00:${_timerDuration.toString().padLeft(2, '0')}', // Waktu tersisa
                  style: const TextStyle(fontSize: 50, color: Colors.red),
                ),
                const SizedBox(height: 20),
                // Linear progress latihan
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: LinearProgressIndicator(
                    value:
                        progress, // Progress bar berdasarkan waktu yang tersisa
                    minHeight: 80,
                    backgroundColor: Colors.grey[300],
                    color: const Color(0xFFE94D1F),
                  ),
                ),
                const SizedBox(height: 20),
                // Tombol pause/resume
                CustomButton(
                  onPressed: _pauseTimer,
                  text: _isPaused ? 'Resume' : 'Pause',
                  icon: _isPaused ? Icons.play_arrow : Icons.pause,
                  horizontalPadding: 20.0,
                  verticalPadding: 15.0,
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
