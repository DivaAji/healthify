import 'package:flutter/material.dart';
import 'dart:async';
import 'package:healthify/screens/program/day/latihan/end_screen.dart';
import 'package:healthify/widgets/button.dart';

class Latihan4Screen extends StatefulWidget {
  const Latihan4Screen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _Latihan4ScreenState createState() => _Latihan4ScreenState();
}

class _Latihan4ScreenState extends State<Latihan4Screen> {
  int _start = 1; // Countdown starts from 1 second
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
        // Navigate to CompletionScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const CompletionScreen(
              exercises: [
                'Latihan 1: Pemanasan',
                'Latihan 2: Latihan Kekuatan',
                'Latihan 3: Latihan Ketahanan',
                'Latihan 4: Pendinginan',
              ],
            ),
          ),
        );
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
    double progress = _start / 1; // Calculate the progress based on the countdown duration

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'LATIHAN 4/4',
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