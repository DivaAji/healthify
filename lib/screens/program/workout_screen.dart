import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healthify/screens/config/api_config.dart';

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
        print('Workout details fetched: $workoutDetails');
        warmups = workoutDetails
            .where((detail) => detail['sub_category'] == 'Pemanasan')
            .take(2) // Ambil hanya 2 warmups
            .toList();
        coreExercises = workoutDetails
            .where((detail) => detail['sub_category'] == 'Latihan Inti')
            .take(5) // Ambil hanya 5 latihan inti
            .toList();
        cooldowns = workoutDetails
            .where((detail) => detail['sub_category'] == 'Pendinginan')
            .take(2) // Ambil hanya 2 cooldowns
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
      print('User ID not found');
      setState(() {
        isSaving = false; // Reset flag
      });
      return;
    }

    // Gabungkan semua latihan ke dalam satu array JSON
    final allWorkouts = [
      ...warmups,
      ...coreExercises,
      ...cooldowns,
    ].map((workout) {
      return {
        'workouts_details_id': workout['workouts_details_id'],
        'day_number': 1, // Awal day_number adalah 1
        'completed': 0, // Nilai default untuk `completed`
      };
    }).toList();

    if (allWorkouts.isEmpty) {
      print('No workouts to save');
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
        print('All workouts saved successfully!');
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

  @override
  Widget build(BuildContext context) {
    String bannerImage =
        'assets/images/${widget.categoryName.toLowerCase()}.jpg';

    return Scaffold(
      appBar: AppBar(title: Text('${widget.categoryName} Program')),
      body: Column(
        children: [
          // Banner Image
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(bannerImage),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Container(
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.5),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 80),
                      Text(
                        'Latihan Program ${widget.categoryName}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          const Center(
            child: Text(
              'Panduan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(33, 50, 75, 1),
              ),
            ),
          ),

          const SizedBox(height: 4),

          const Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Text(
              'Daftar latihan',
              style:
                  TextStyle(fontSize: 16, color: Color.fromRGBO(33, 50, 75, 1)),
            ),
          ),

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

          // Mulai Program Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: saveWorkoutsToDatabase,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(33, 50, 75, 1),
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
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Column(
          children: exercises.map((detail) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
              child: ListTile(
                leading: Icon(
                  Icons.fitness_center,
                  color: Color.fromRGBO(33, 50, 75, 1),
                ),
                title: Text(
                  detail['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(33, 50, 75, 1),
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Sub Kategori: ${detail['sub_category']}'),
                    Text('Deskripsi: ${detail['description']}'),
                    Text('Durasi: ${detail['duration']} detik'),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
