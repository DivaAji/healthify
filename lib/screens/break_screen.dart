import 'package:flutter/material.dart';
import 'dart:async';

class BreakScreen extends StatefulWidget {
  final Widget nextScreen; // Next screen to navigate to

  const BreakScreen({super.key, required this.nextScreen});

  @override
  // ignore: library_private_types_in_public_api
  _BreakScreenState createState() => _BreakScreenState();
}

class _BreakScreenState extends State<BreakScreen> {
  int _start = 1; // Countdown starts from 20 seconds
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
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
          MaterialPageRoute(builder: (context) => widget.nextScreen),
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
        title: const Text('ISTIRAHAT'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'ISTIRAHAT',
                style: TextStyle(fontSize: 30, color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: Text(
                '00:${_start.toString().padLeft(2, '0')}', // Display countdown
                style: const TextStyle(fontSize: 100, color: Color(0xFF21324B), fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            const Text('NEXT', style: TextStyle(fontSize: 13, color: Color(0xFF21324B))),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('LATIHAN 2', style: TextStyle(fontSize: 18, color: Color(0xFF21324B), fontWeight: FontWeight.bold)),
                Text('01:00', style: TextStyle(fontSize: 18, color: Color(0xFF21324B), fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}