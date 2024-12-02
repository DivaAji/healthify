import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healthify/screens/config/api_config.dart';

class DetailProgramScreen extends StatelessWidget {
  final String categoryName;
  final List<dynamic> workouts; // List of all workout details in the category

  const DetailProgramScreen({
    super.key,
    required this.categoryName,
    required this.workouts,
  });

  // Function to get user_id from SharedPreferences
  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userIdString = prefs.getString('user_id');
    if (userIdString != null) {
      print('User ID retrieved: $userIdString');
      return int.tryParse(userIdString); // Convert string to int
    }
    print('User ID not found in SharedPreferences');
    return null; // Return null if not found
  }

  // Function to get the access token from SharedPreferences
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // Function to select a workout category and send request to the backend
  Future<void> selectCategoryProgram(int workoutsId) async {
    final userId = await getUserId(); // Get user_id from SharedPreferences
    if (userId == null) {
      print('User ID tidak ditemukan');
      return;
    }

    final url = Uri.parse(ApiConfig.selectProgramEndpoint);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'user_id': userId,
        'workouts_id': workoutsId,
        'completed': 0, // Status completed 0 for not completed
      }),
    );

    if (response.statusCode == 201) {
      print('Program berhasil dipilih dan ditambahkan ke workouts_user!');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('category_selected_$workoutsId', true);
    } else {
      print('Terjadi kesalahan: ${response.body}');
    }
  }

  // Dialog confirmation when selecting a category
  void _showStartDialog(BuildContext context, int workoutsId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Mulai Program'),
          content: Text('Apakah Anda siap untuk memulai program ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Tidak'),
            ),
            TextButton(
              onPressed: () async {
                await selectCategoryProgram(workoutsId); // Select the category
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pop(context); // Go back to the previous screen
              },
              child: Text('Ya'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String bannerImage = 'assets/images/${categoryName.toLowerCase()}.jpg';

    return Scaffold(
      body: Column(
        children: [
          // Banner
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
                // Gradient overlay
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
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(height: 80),
                      Text(
                        'Latihan Program $categoryName',
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

          // Divider
          Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey.shade300,
          ),

          const SizedBox(height: 16),

          // Guide Text
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
          Flexible(
            child: workouts.isNotEmpty
                ? ListView.builder(
                    itemCount: workouts.length,
                    itemBuilder: (context, index) {
                      final workout = workouts[index];
                      final workoutDetails = workout['workouts_details'];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        workout['category'],
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromRGBO(33, 50, 75, 1),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: workoutDetails.length,
                                        itemBuilder: (context, detailsIndex) {
                                          final detail =
                                              workoutDetails[detailsIndex];
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 10),
                                            child: Card(
                                              elevation: 2,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              child: ListTile(
                                                leading: Icon(
                                                  Icons.fitness_center,
                                                  color: Color.fromRGBO(
                                                      33, 50, 75, 1),
                                                ),
                                                title: Text(
                                                  detail['name'],
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromRGBO(
                                                        33, 50, 75, 1),
                                                  ),
                                                ),
                                                subtitle: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        'Sub Kategori: ${detail['sub_category']}'),
                                                    Text(
                                                        'Deskripsi: ${detail['description']}'),
                                                    Text(
                                                        'Durasi: ${detail['duration']} detik'),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      Align(
                                        alignment: Alignment
                                            .bottomCenter, // Centers the button at the bottom
                                        child: Padding(
                                          padding: const EdgeInsets.all(
                                              16.0), // Adds padding around the button
                                          child: ElevatedButton(
                                            onPressed: () {
                                              _showStartDialog(context,
                                                  workout['workouts_id']);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Color.fromRGBO(
                                                  33,
                                                  50,
                                                  75,
                                                  1), // Background color
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 20,
                                                  horizontal:
                                                      40), // Larger button size
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    30), // Larger radius for a more rounded button
                                              ),
                                              elevation:
                                                  10, // Adds elevation for floating effect
                                            ),
                                            child: const Text(
                                              'Pilih Program',
                                              style: TextStyle(
                                                fontSize:
                                                    18, // Increase font size
                                                fontWeight: FontWeight.bold,
                                                color: Colors
                                                    .white, // White text for contrast
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const Center(child: Text('Tidak ada latihan tersedia.')),
          ),
        ],
      ),
    );
  }
}
