import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healthify/screens/profile/edit_profil_screen.dart';
import 'package:healthify/widgets/button.dart';
import 'package:healthify/screens/config/api_config.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = 'Unknown';
  String email = 'Unknown';
  String gender = 'Unknown';
  String height = 'Unknown';
  String weight = 'Unknown';
  String ageRange = 'Unknown';
  String bmi = 'Unknown';

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    if (token == null) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    final response = await http.get(
      Uri.parse(ApiConfig.profileEndpoint),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (mounted) {
        setState(() {
          username = data['username'] ?? 'Unknown';
          email = data['email'] ?? 'Unknown';
          gender = data['gender'] ?? 'Unknown';
          height = data['height']?.toString() ?? 'Unknown';
          weight = data['weight']?.toString() ?? 'Unknown';
          ageRange = data['ageRange'] ?? 'Unknown';
          bmi = data['bmi'] != null ? data['bmi'].toString() : 'Unknown';
          isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text(
                'Failed to fetch profile data. Please try again later.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    Navigator.pushReplacementNamed(context, '/login');
  }

  String getBmiCategory(String bmi) {
    double bmiValue = double.tryParse(bmi) ?? 0.0;

    if (bmiValue < 18.5) {
      return 'Underweight';
    } else if (bmiValue >= 18.5 && bmiValue <= 22.9) {
      return 'Normal';
    } else if (bmiValue >= 23 && bmiValue <= 24.9) {
      return 'Overweight';
    } else if (bmiValue >= 25) {
      return 'Obesitas';
    } else {
      return 'Invalid BMI';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil',
          style: TextStyle(color: Color(0xFF21324B)),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        actions: [
          const Text(
            'Logout',
            style: TextStyle(
              color: Color(0xFF21324B),
              fontSize: 16,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: logout,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/login_background.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.5)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 59, 56, 56).withOpacity(0.33),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Gender Icon
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            child: Icon(
                              gender.toLowerCase() == 'laki-laki'
                                  ? Icons.male
                                  : Icons.female,
                              size: 60,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Username and Email
                          Text(
                            username,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            email,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Additional Information
                          Text(
                            'Informasi Tambahan',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),

                          Expanded(
                            child: ListView(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              children: [
                                _buildInfoItem('Jenis Kelamin', gender),
                                _buildInfoItem('Tinggi Badan', height),
                                _buildInfoItem('Berat Badan', weight),
                                _buildInfoItem('Rentang Usia', ageRange),
                                _buildInfoItem('Indeks Masa Tubuh', bmi),
                                _buildInfoItem(
                                  'Kategori BMI',
                                  getBmiCategory(bmi),
                                ),
                              ],
                            ),
                          ),

                          // Edit Profile Button
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: CustomButton(
                              text: 'Edit Profil',
                              onPressed: () async {
                                final updatedData = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditProfilScreen(),
                                  ),
                                );

                                if (updatedData != null) {
                                  setState(() {
                                    username = updatedData['username'] ?? username;
                                    email = updatedData['email'] ?? email;
                                    height = updatedData['height'] ?? height;
                                    weight = updatedData['weight'] ?? weight;
                                    gender = updatedData['gender'] ?? gender;
                                    ageRange = updatedData['ageRange'] ?? ageRange;
                                  });
                                }
                              },
                              verticalPadding: 10.0,
                              textStyle: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildInfoItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.8)),
          ),
        ],
      ),
    );
  }
}
