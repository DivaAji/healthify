import 'package:flutter/material.dart';
import 'dart:async';
import 'package:healthify/screens/break_screen.dart';
import 'package:healthify/screens/program/day/latihan/latihan2_screen.dart';
import 'package:healthify/widgets/button.dart';

class Latihan1Screen extends StatefulWidget {
  const Latihan1Screen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _Latihan1ScreenState createState() => _Latihan1ScreenState();
}

class _Latihan1ScreenState extends State<Latihan1Screen> {
  int _start = 1; // Countdown starts from 1 second
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Start the timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start > 0) {
        setState(() {
          _start--;
        });
      } else {
        _timer.cancel(); // Stop the timer when countdown reaches 0
        // Navigate to the next screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HalamanBaru()),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Stop the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latihan 1', style: TextStyle(color: Color(0xFF21324B))),
      ),
      body: Column(
        children: [
          // Banner
          Container(
            height: 200,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/kelenturan.jpg'), // Change to your banner image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Center Text
          const Center(
            child: Text(
              'PERSIAPAN',
              style: TextStyle(fontSize: 48, color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),

          // Countdown Circle
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              alignment: Alignment.center,
              child: Text(
                '$_start',
                style: const TextStyle(
                  fontSize: 36,
                  color: Colors.white,
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
  int _start = 3; // Countdown starts from 3 seconds
  late Timer _timer;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start > 0 && !_isPaused) {
        setState(() {
          _start--;
        });
      } else if (_start == 0) {
        _timer.cancel(); // Stop the timer when countdown reaches 0
        if (mounted) { // Ensure the widget is still mounted
          print("Countdown finished, navigating to Latihan2Screen");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BreakScreen(nextScreen: Latihan2Screen(),)),
          );
        }
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
    _timer.cancel(); // Stop the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress = _start / 3; // Calculate the progress based on the countdown duration

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'LATIHAN 1/4',
          style: TextStyle(color: Color(0xFF21324B), fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Banner
          Container(
            height: 200,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/kelenturan.jpg'), // Change to your banner image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Center Text
          const Center(
            child: Text(
              'PEMANASAN',
              style: TextStyle(fontSize: 24, color: Color(0xFF21324B), fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 5),

          // Countdown Timer
          Center(
            child: Text(
              '00:${_start.toString().padLeft(2, '0')}',
              style: const TextStyle(
                fontSize: 100,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Progress Bar
          LinearProgressIndicator(
            value: progress,
            minHeight: 50,
            backgroundColor: Colors.grey[300],
            color: Colors.red,
          ),
          const SizedBox(height: 20),

          // Pause Button
          CustomButton(
            text: _isPaused ? 'Resume' : 'Pause',
            onPressed: _pauseTimer,
          ),
        ],
      ),
    );
  }
}