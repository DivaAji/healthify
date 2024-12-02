import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healthify/screens/program/detail_program_screen.dart';
import 'package:healthify/screens/config/api_config.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> categories = []; // Daftar kategori
  Map<String, List<dynamic>> workoutsByCategory =
      {}; // Menyimpan workouts berdasarkan kategori
  bool isLoading = true;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    fetchProgramsByUserId(); // Ensure data is fetched on init
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  Future<void> fetchProgramsByUserId() async {
    try {
      final token = await getToken();
      if (token == null) {
        if (mounted) {
          // Check if the widget is still mounted
          setState(() {
            isLoading = false;
            errorMessage = "User is not logged in.";
          });
        }
        return;
      }

      // Mengambil data pengguna
      final userResponse = await http.get(
        Uri.parse(ApiConfig.profileEndpoint),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (userResponse.statusCode != 200) {
        if (mounted) {
          // Check if the widget is still mounted
          setState(() {
            isLoading = false;
            errorMessage =
                "Failed to fetch user details (${userResponse.statusCode}).";
          });
        }
        return;
      }

      final userData = json.decode(userResponse.body);
      final userId = userData['user_id']; // Ambil ID user

      if (userId == null) {
        if (mounted) {
          // Check if the widget is still mounted
          setState(() {
            isLoading = false;
            errorMessage = "User ID is null. Please check your profile data.";
          });
        }
        return;
      }

      // Panggil API untuk mendapatkan kategori program berdasarkan ID pengguna
      final workoutResponse = await http.get(
        Uri.parse(ApiConfig.workoutsCategoryEndpoint(userId)),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (workoutResponse.statusCode == 200) {
        final data = json.decode(workoutResponse.body);

        // Check if the 'workouts' field exists and is not empty
        if (data.containsKey('workouts') && data['workouts'] != null) {
          Map<String, dynamic> workoutsData = data['workouts'];

          List<String> categoryNames = [];

          workoutsData.forEach((categoryName, workouts) {
            categoryNames.add(categoryName); // Add category name to list
            workoutsByCategory[categoryName] =
                List.from(workouts); // Store workouts by category
          });

          if (mounted) {
            // Check if the widget is still mounted
            setState(() {
              categories = categoryNames;
              isLoading =
                  false; // Ensure loading is set to false when data is fetched
            });
          }
        } else {
          if (mounted) {
            // Check if the widget is still mounted
            setState(() {
              isLoading = false;
              errorMessage =
                  'Workouts data is not in the expected format or is empty.';
            });
          }
        }
      } else {
        if (mounted) {
          // Check if the widget is still mounted
          setState(() {
            isLoading = false;
            errorMessage =
                'Failed to load programs (${workoutResponse.statusCode}).';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        // Check if the widget is still mounted
        setState(() {
          isLoading = false;
          errorMessage = 'Error fetching data: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('PROGRAM'),
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(
                  child: Text(errorMessage,
                      style: const TextStyle(color: Colors.red)))
              : ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final categoryName = categories[
                        index]; // Don't convert category name to lowercase here

                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GestureDetector(
                        onTap: () {
                          // Gunakan data workout yang sudah diambil untuk kategori ini
                          final workoutsData = workoutsByCategory[categoryName];

                          if (workoutsData != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailProgramScreen(
                                  categoryName: categoryName,
                                  workouts: workoutsData,
                                ),
                              ),
                            );
                          }
                        },
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Stack(
                              children: [
                                AspectRatio(
                                  aspectRatio: 16 / 9, // Menjaga rasio gambar
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/${categoryName.toLowerCase()}.jpg'), // Apply lowercase only for image path
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 10,
                                  left: 10,
                                  child: Text(
                                    categoryName,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 10,
                                          color: Colors.black,
                                          offset: Offset(2, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
