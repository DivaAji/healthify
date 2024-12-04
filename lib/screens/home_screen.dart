import 'package:flutter/material.dart';
import 'package:healthify/screens/login/login_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healthify/screens/program/detail_program_screen.dart';
import 'package:healthify/screens/config/api_config.dart';
import 'package:healthify/screens/program/workout_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> categories = [];
  Map<String, List<dynamic>> workoutsByCategory = {};
  bool isLoading = true;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    fetchProgramsByUserId();
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
          setState(() {
            isLoading = false;
            errorMessage = "User is not logged in.";
          });
        }
        return;
      }

      final userResponse = await http.get(
        Uri.parse(ApiConfig.profileEndpoint),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (userResponse.statusCode != 200) {
        if (mounted) {
          setState(() {
            isLoading = false;
            errorMessage =
                "Failed to fetch user details (${userResponse.statusCode}).";
          });
        }
        return;
      }

      final userData = json.decode(userResponse.body);
      final userId = userData['user_id'];

      if (userId == null) {
        if (mounted) {
          setState(() {
            isLoading = false;
            errorMessage = "User ID is null. Please check your profile data.";
          });
        }
        return;
      }

      final workoutResponse = await http.get(
        Uri.parse(ApiConfig.workoutsCategoryEndpoint(userId)),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (workoutResponse.statusCode == 200) {
        final data = json.decode(workoutResponse.body);

        if (data.containsKey('workouts') && data['workouts'] != null) {
          Map<String, dynamic> workoutsData = data['workouts'];

          List<String> categoryNames = [];
          workoutsData.forEach((categoryName, workouts) {
            categoryNames.add(categoryName);
            workoutsByCategory[categoryName] = List.from(workouts);
          });

          for (var category in categoryNames) {
            final workoutsInCategory = workoutsByCategory[category];

            if (workoutsInCategory != null) {
              for (var workout in workoutsInCategory) {
                final workoutsId = workout['workouts_id'];

                if (workoutsId == null) {
                  continue;
                }

                final statusUrl =
                    ApiConfig.checkCategoryStatusEndpoint(userId, workoutsId);
                final statusResponse = await http.get(
                  Uri.parse(statusUrl),
                  headers: {'Authorization': 'Bearer $token'},
                );

                if (statusResponse.statusCode == 200) {
                  final statusData = json.decode(statusResponse.body);

                  if (statusData['status'] == 'ongoing') {
                    workout['status'] = 'ongoing';
                  } else if (statusData['status'] == 'completed') {
                    workout['status'] = 'completed';
                  } else {
                    workout['status'] = 'not_started';
                  }
                } else {
                  workout['status'] = 'not_started';
                }
              }
            }
          }

          if (mounted) {
            setState(() {
              categories = categoryNames;
              isLoading = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              isLoading = false;
              errorMessage =
                  'Workouts data is not in the expected format or is empty.';
            });
          }
        }
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
            errorMessage =
                'Failed to load programs (${workoutResponse.statusCode}).';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = 'Error fetching data: $e';
        });
      }
    }
  }

  Widget _buildStatusBadge(String status) {
    Color badgeColor;
    IconData icon;

    switch (status) {
      case 'ongoing':
        badgeColor = Colors.green;
        icon = Icons.play_arrow;
        break;
      case 'completed':
        badgeColor = Colors.blue;
        icon = Icons.check_circle;
        break;
      case 'not_started':
      default:
        badgeColor = Colors.grey;
        icon = Icons.access_time;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 5),
          Text(
            status[0].toUpperCase() +
                status.substring(1), // Capitalize the first letter
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                            final workoutsData =
                                workoutsByCategory[categoryName];

                            if (workoutsData != null) {
                              final status = workoutsData.first['status'];
                              final workoutsId = workoutsData.first[
                                  'workouts_id']; // Ambil workoutsId dari data

                              if (status == 'ongoing') {
                                // Navigasi ke WorkoutScreen dengan workoutsId dan categoryName
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WorkoutScreen(
                                      workoutsId:
                                          workoutsId, // Kirim workoutsId
                                      categoryName:
                                          categoryName, // Kirim categoryName
                                    ),
                                  ),
                                );
                              } else {
                                // Navigasi ke DetailProgramScreen untuk status lain
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
                                    aspectRatio: 16 / 9,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/${categoryName.toLowerCase()}.jpg'),
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
                                  // Display status on the card using the new styled widget
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: _buildStatusBadge(
                                      workoutsByCategory[categoryName]
                                              ?.first['status'] ??
                                          'not_started',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ));
  }
}
