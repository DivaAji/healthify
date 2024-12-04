import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:healthify/screens/config/api_config.dart';
import 'package:healthify/screens/program/steps_finish.dart'; // Pastikan file ini sudah ada.

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
  Timer? _timer;
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
        widget.userId,
        widget.workoutsId,
        1,
      )),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        steps = List<Map<String, dynamic>>.from(data);
        _timerDuration = steps[_currentStep]['duration'] ?? 45;
      });
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
        if (mounted) {
          setState(() {
            _start--;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isCountdownFinished = true;
          });
        }
        _initialTimer.cancel();
        _startTimer();
      }
    });
  }

  void _startTimer() {
    _timer?.cancel(); // Pastikan timer sebelumnya dihentikan
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerDuration > 0 && !_isPaused) {
        if (mounted) {
          setState(() {
            _timerDuration--;
          });
        }
      } else if (_timerDuration == 0) {
        _timer?.cancel();
        _nextStep();
      }
    });
  }

  void _nextStep() async {
    if (_currentStep < steps.length - 1) {
      setState(() {
        _currentStep++;
        _isCountdownFinished = false;
        _start = 7;
        _timerDuration = steps[_currentStep]['duration'] ?? 45;
      });

      await Future.delayed(const Duration(milliseconds: 200));
      _startInitialTimer();

      if (_youtubeController != null) {
        _youtubeController?.pause();
        _youtubeController?.dispose();
        _youtubeController = null;
      }

      _initializeVideoPlayer();

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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => StepsFinish(),
          ),
        );
      } else {
        print("Failed to update workout completion");
      }
    }
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _skipStep() {
    if (!_isCountdownFinished) {
      setState(() {
        _isCountdownFinished = true;
        _timerDuration = steps[_currentStep]['duration'] ?? 45;
      });
    } else {
      _nextStep();
    }
  }

  @override
  void dispose() {
    _initialTimer.cancel();
    _timer?.cancel();
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (steps.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF008B90),
        title: Text(
          'Langkah ${_currentStep + 1}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          if (_youtubeController != null)
            YoutubePlayer(
              controller: _youtubeController!,
              showVideoProgressIndicator: true,
            ),
          const SizedBox(height: 20),
          Text(
            'Gerakan: ${steps[_currentStep]['name']}',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              steps[_currentStep]['description'],
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(),
          if (!_isCountdownFinished)
            Column(
              children: [
                Text(
                  '$_start',
                  style:
                      const TextStyle(fontSize: 50, color: Color(0xFF008B90)),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _skipStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF008B90),
                  ),
                  child: const Text(
                    'Skip',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                Text(
                  '00:${_timerDuration.toString().padLeft(2, '0')}',
                  style:
                      const TextStyle(fontSize: 50, color: Color(0xFF008B90)),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _togglePause,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF78B9BA),
                      ),
                      child: Text(
                        _isPaused ? 'Lanjutkan' : 'Pause',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _skipStep,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF008B90),
                      ),
                      child: const Text(
                        'Skip',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          const Spacer(),
        ],
      ),
    );
  }
}
