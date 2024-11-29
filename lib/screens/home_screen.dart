import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healthify/screens/program/detail_program_screen.dart'; // Sesuaikan dengan file yang sesuai

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> categories = []; // Daftar kategori
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
        setState(() {
          isLoading = false;
          errorMessage = "User is not logged in.";
        });
        return;
      }

      // Mengambil data pengguna
      final userResponse = await http.get(
        Uri.parse('http://192.168.1.6:8000/api/profile'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (userResponse.statusCode != 200) {
        setState(() {
          isLoading = false;
          errorMessage =
              "Failed to fetch user details (${userResponse.statusCode}).";
        });
        return;
      }

      final userData = json.decode(userResponse.body);
      final userId = userData['user_id']; // Ambil ID user

      if (userId == null) {
        setState(() {
          isLoading = false;
          errorMessage = "User ID is null. Please check your profile data.";
        });
        return;
      }

      // Panggil API untuk mendapatkan kategori program berdasarkan ID pengguna
      final workoutResponse = await http.get(
        Uri.parse('http://192.168.1.6:8000/api/workouts/categories/$userId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (workoutResponse.statusCode == 200) {
        final data = json.decode(workoutResponse.body);

        // Check if the 'workouts' field exists and is not empty
        if (data.containsKey('workouts') && data['workouts'] != null) {
          Map<String, dynamic> workoutsData = data['workouts'];

          List<String> categoryNames = [];

          // Iterate over categories (Kelenturan, Kelincahan, etc.)
          workoutsData.forEach((categoryName, _) {
            categoryNames.add(categoryName); // Add category name to list
          });

          setState(() {
            categories = categoryNames;
            isLoading =
                false; // Ensure loading is set to false when data is fetched
          });
        } else {
          setState(() {
            isLoading = false;
            errorMessage =
                'Workouts data is not in the expected format or is empty.';
          });
        }
      } else {
        setState(() {
          isLoading = false;
          errorMessage =
              'Failed to load programs (${workoutResponse.statusCode}).';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error fetching data: $e';
      });
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
                    final categoryName = categories[index];

                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GestureDetector(
                        onTap: () {
                          // Navigasi ke halaman yang sesuai jika diperlukan
                          // Bisa ditambahkan navigasi sesuai kebutuhan
                        },
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Column(
                              children: [
                                Container(
                                  height: 150,
                                  width: screenWidth * 0.8,
                                  color: Colors
                                      .blue, // Just to represent category (adjust accordingly)
                                  child: Center(
                                    child: Text(
                                      categoryName,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
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
