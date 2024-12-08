import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healthify/screens/config/api_config.dart';
import 'package:healthify/screens/program/program_steps.dart'; // Import the ProgramSteps screen

class WorkoutScreen extends StatefulWidget {
  final int workoutsId;
  final String categoryName;

  WorkoutScreen({required this.workoutsId, required this.categoryName});

  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  List<dynamic> warmups = [];
  List<dynamic> coreExercises = [];
  List<dynamic> cooldowns = [];
  bool isSaving = false; // Flag untuk mencegah duplikasi

  @override
  void initState() {
    super.initState();
    fetchWorkoutDetails();
  }

  Future<void> fetchWorkoutDetails() async {
    final url = ApiConfig.workoutsDetailsEndpoint(widget.workoutsId);
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        var workoutDetails = json.decode(response.body)['workout_details'];
        warmups = workoutDetails
            .where((detail) => detail['sub_category'] == 'Pemanasan')
            .take(2)
            .toList();
        coreExercises = workoutDetails
            .where((detail) => detail['sub_category'] == 'Latihan Inti')
            .take(5)
            .toList();
        cooldowns = workoutDetails
            .where((detail) => detail['sub_category'] == 'Pendinginan')
            .take(2)
            .toList();
      });
    } else {
      throw Exception('Failed to load workout details');
    }
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userIdString = prefs.getString('user_id');
    if (userIdString != null) {
      return int.tryParse(userIdString);
    }
    return null;
  }

  Future<void> saveWorkoutsToDatabase() async {
    if (isSaving) return; // Cegah duplikasi jika sedang menyimpan
    setState(() {
      isSaving = true; // Set flag menjadi true
    });

    final userId = await getUserId();
    if (userId == null) {
      setState(() {
        isSaving = false; // Reset flag
      });
      return;
    }

    final allWorkouts = [
      ...warmups,
      ...coreExercises,
      ...cooldowns,
    ].map((workout) {
      return {
        'workouts_details_id': workout['workouts_details_id'],
        'day_number': 1,
        'completed': 0,
      };
    }).toList();

    if (allWorkouts.isEmpty) {
      setState(() {
        isSaving = false; // Reset flag
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(ApiConfig.startProgramEndpoint),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'user_id': userId,
          'workouts_id': widget.workoutsId,
          'day_number': 1,
          'workouts': allWorkouts,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProgramSteps(
              userId: userId,
              workoutsId: widget.workoutsId,
              currentStep: 0,
            ),
          ),
        );
      } else {
        print('Failed to save workouts: ${response.body}');
      }
    } catch (error) {
      print('Error saving workouts: $error');
    } finally {
      setState(() {
        isSaving = false; // Reset flag setelah selesai
      });
    }
  }

  Future<bool> checkWorkoutStatus() async {
    final userId = await getUserId();
    if (userId == null) return false;

    try {
      final response = await http.post(
        Uri.parse(ApiConfig.checkWorkoutStatusEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_id': userId,
          'workouts_id': widget.workoutsId,
        }),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        return result['exists'];
      }
    } catch (error) {
      print('Error checking workout status: $error');
    }
    return false;
  }

  Future<void> onStartProgram() async {
    final alreadySaved = await checkWorkoutStatus();

    if (alreadySaved) {
      // Tampilkan dialog jika program sudah ada
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Program Hari Ini Selesai!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.green,
            ),
          ),
          content: Text(
            'Selamat! Anda telah menyelesaikan latihan hari ini dengan luar biasa. '
            'Segera kembali dan lanjutkan perjalanan Anda besok untuk hasil yang lebih baik.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return; // Hentikan eksekusi
    }

    // Jika belum, lanjutkan menyimpan
    await saveWorkoutsToDatabase();
  }

  @override
  Widget build(BuildContext context) {
    String bannerImage =
        'assets/images/${widget.categoryName.toLowerCase()}.jpg';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.categoryName} Program',
          style: TextStyle(color: Color(0xFF21324B)), // Apply TextStyle here
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white, // Mengatur background menjadi putih
        child: Column(
          children: [
            // Banner Image Section (Header)
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(bannerImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Teks kategori program diletakkan di bawah gambar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Latihan Program ${widget.categoryName}',
                style: const TextStyle(
                  color: Colors.black, // Mengubah warna font menjadi hitam
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // List of workouts
            Expanded(
              child: warmups.isNotEmpty ||
                      coreExercises.isNotEmpty ||
                      cooldowns.isNotEmpty
                  ? ListView(
                      children: [
                        if (warmups.isNotEmpty)
                          _buildWorkoutCategory('Pemanasan', warmups),
                        if (coreExercises.isNotEmpty)
                          _buildWorkoutCategory('Latihan Inti', coreExercises),
                        if (cooldowns.isNotEmpty)
                          _buildWorkoutCategory('Pendinginan', cooldowns),
                      ],
                    )
                  : const Center(child: Text('Tidak ada latihan tersedia.')),
            ),

            // Mulai Program Button dengan warna latar belakang yang diubah
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: onStartProgram,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      (Color(0xFF008B90)), // Warna latar belakang tombol
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 10,
                ),
                child: const Text(
                  'Mulai Program',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutCategory(String category, List<dynamic> exercises) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            category,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        Column(
          children: exercises.map((detail) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Color.fromRGBO(1, 1, 1, 1)),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListTile(
                  leading: Icon(
                    Icons.fitness_center,
                    color: Colors.black87, // Warna ikon
                    size: 30,
                  ),
                  title: Text(
                    detail['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        detail['description'],
                        style: TextStyle(color: Colors.black.withOpacity(0.7)),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
