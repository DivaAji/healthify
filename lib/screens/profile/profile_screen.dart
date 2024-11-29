import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healthify/screens/profile/edit_profil_screen.dart';
import 'package:healthify/widgets/button.dart';

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
  String profilePicture = 'assets/images/profile_picture.png'; // Default image

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token'); // Retrieve token

    if (token == null) {
      setState(() {
        isLoading = false;
      });
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    final response = await http.get(
      Uri.parse(
          'http://192.168.1.6:8000/api/profile'), // Ensure this matches the endpoint
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        username = data['username'] ?? 'Unknown';
        email = data['email'] ?? 'Unknown';
        gender = data['gender'] ?? 'Unknown';
        height = data['height']?.toString() ?? 'Unknown';
        weight = data['weight']?.toString() ?? 'Unknown';
        ageRange = data['ageRange'] ?? 'Unknown';
        bmi = data['bmi'] != null ? data['bmi'].toString() : 'Unknown';
        profilePicture =
            data['profile_picture'] ?? 'assets/images/profile_picture.png';
        isLoading = false;
      });
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
    await prefs.remove('jwt_token'); // Remove the token
    Navigator.pushReplacementNamed(context, '/login'); // Redirect to login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PROFIL'),
        automaticallyImplyLeading: false, // No back button
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: logout,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Profile Picture
                  GestureDetector(
                    onTap: () {
                      // You can add functionality for changing the picture
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: profilePicture.startsWith('http')
                          ? NetworkImage(profilePicture) // URL image
                          : AssetImage(profilePicture)
                              as ImageProvider, // Local image
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Username
                  Text(
                    username,
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // Email
                  Text(
                    email,
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),

                  // Edit Profile Button
                  CustomButton(
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
                          profilePicture =
                              updatedData['profileImagePath'] ?? profilePicture;
                          ageRange = updatedData['ageRange'] ?? ageRange;
                        });
                      }
                    },
                    verticalPadding: 10.0,
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),

                  // Additional Information
                  Text(
                    'Informasi Tambahan',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // Info List
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                        children: [
                          _buildInfoItem('Jenis Kelamin', gender),
                          _buildInfoItem('Tinggi Badan', height),
                          _buildInfoItem('Berat Badan', weight),
                          _buildInfoItem('Rentang Usia', ageRange),
                          _buildInfoItem('Indeks Masa Tubuh', bmi),
                        ],
                      ),
                    ),
                  ),
                ],
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
          Text(title, style: const TextStyle(fontSize: 16)),
          Text(value, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
        ],
      ),
    );
  }
}
