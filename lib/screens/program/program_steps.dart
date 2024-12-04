import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:healthify/screens/config/api_config.dart';

class ProgramSteps extends StatefulWidget {
  final int userId;
  final int workoutsId;
  final int currentStep;

  const ProgramSteps({
    super.key,
    required this.userId,
    required this.workoutsId,
    required this.currentStep,
  });

  @override
  _ProgramStepsState createState() => _ProgramStepsState();
}

class _ProgramStepsState extends State<ProgramSteps> {
  late int _currentStep;
  late List<Map<String, dynamic>> steps = [];
  int _start = 7;
  late Timer _initialTimer;
  bool _isCountdownFinished = false;
  int _timerDuration = 45;
  late Timer _timer;
  bool _isPaused = false;
  YoutubePlayerController? _youtubeController;

  @override
  void initState() {
    super.initState();
    _currentStep = widget.currentStep;
    _loadWorkoutSteps();
    _startInitialTimer();
  }

  Future<void> _loadWorkoutSteps() async {
    final response = await http.get(
      Uri.parse(ApiConfig.workoutsStepsEndpoint(
        widget.userId, // userId
        widget.workoutsId, // workoutsId
        1, // dayNumber (misalnya, untuk hari pertama)
      )),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        steps = List<Map<String, dynamic>>.from(data);
        _timerDuration = steps[_currentStep]['duration'] ?? 45;
      });

      // Initialize video player for the current step's video
      _initializeVideoPlayer();
    } else {
      print("Failed to load workout steps: ${response.body}");
    }
  }

  void _initializeVideoPlayer() {
    if (steps.isNotEmpty && steps[_currentStep]['video_link'] != null) {
      final videoLink = steps[_currentStep]['video_link'];
      final videoId = YoutubePlayer.convertUrlToId(videoLink);

      if (videoId != null) {
        _youtubeController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: YoutubePlayerFlags(autoPlay: true, mute: false),
        );
      }
    }
  }

  void _startInitialTimer() {
    _initialTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start > 0) {
        setState(() {
          _start--;
        });
      } else {
        setState(() {
          _isCountdownFinished = true;
        });
        _initialTimer.cancel();
        _startTimer();
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerDuration > 0 && !_isPaused) {
        setState(() {
          _timerDuration--;
        });
      } else if (_timerDuration == 0) {
        _timer.cancel();
        _nextStep();
      }
    });
  }

  void _nextStep() async {
    if (_currentStep < steps.length - 1) {
      setState(() {
        _currentStep++;
        _isCountdownFinished = false;
        _start = 10;
        _timerDuration = steps[_currentStep]['duration'] ?? 45;
      });

      // Delay untuk memulai countdown baru setelah update
      await Future.delayed(const Duration(milliseconds: 200));
      _startInitialTimer();

      // Hentikan video lama dan bersihkan controller sebelumnya
      if (_youtubeController != null) {
        _youtubeController?.pause();
        _youtubeController?.dispose(); // Properly dispose of the old controller
        _youtubeController = null; // Reset the controller
      }

      // Inisialisasi video baru untuk langkah selanjutnya
      _initializeVideoPlayer();

      // Update progress setelah langkah saat ini selesai
      if (_currentStep > 0) {
        final response = await http.post(
          Uri.parse(ApiConfig.updateWorkoutUserDayNumberEndpoint()),
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'user_id': widget.userId,
            'workouts_id': widget.workoutsId,
            'completed': 1,
            'workouts_details_id': steps[_currentStep - 1]
                ['workouts_details_id'],
          }),
        );

        if (response.statusCode != 200) {
          print("Failed to update workout progress");
        }
      }
    } else {
      // Handle completion of the entire workout program
      final response = await http.post(
        Uri.parse(ApiConfig.updateWorkoutUserDayNumberEndpoint()),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'user_id': widget.userId,
          'workouts_id': widget.workoutsId,
          'completed': 1,
          'workouts_details_id': steps[_currentStep]['workouts_details_id'],
        }),
      );

      if (response.statusCode == 200) {
        print("Workout program completed");
      } else {
        print("Failed to update workout completion");
      }
    }
  }

  @override
  void dispose() {
    _initialTimer.cancel();
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (steps.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Step ${_currentStep + 1}'),
      ),
      body: Column(
        children: [
          if (_youtubeController != null)
            YoutubePlayer(
              controller: _youtubeController!,
              showVideoProgressIndicator: true,
            ),
          const SizedBox(height: 35),
          Text(
            'Ambil posisi untuk gerakan: ${steps[_currentStep]['name']}',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              steps[_currentStep]['description'],
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 40),
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
                  '$_start',
                  style: const TextStyle(fontSize: 50, color: Colors.white),
                ),
              ),
            )
          else
            Column(
              children: [
                Text(
                  '00:${_timerDuration.toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 50, color: Colors.red),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _nextStep,
                  child: Text(
                    _currentStep == steps.length - 1 ? 'Selesai' : 'Lanjutkan',
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
