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
  String username = 'Username';
  String email = 'email@example.com';
  String height = '165';
  String weight = '50';
  String gender = 'Perempuan';
  String profileImagePath = 'assets/images/profile_picture.png'; // Default image path
  String ageRange = '18-30'; // Menambahkan rentang usia
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
    String? token = prefs.getString('jwt_token'); // Retrieve token

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
    await prefs.remove('jwt_token'); // Remove the token
    Navigator.pushReplacementNamed(context, '/login'); // Redirect to login
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
              color: Color(0xFF21324B), // Adjust the color as needed
              fontSize: 16,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Picture
            GestureDetector(
              onTap: () {
                // Optionally, you can add functionality to edit the profile picture here
              },
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(profileImagePath),
              ),
            ),
            const SizedBox(height: 16),

            // Username
            Text(
              username,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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
                    builder: (context) => EditProfilScreen(
                      username: username,
                      email: email,
                      height: height,
                      weight: weight,
                      gender: gender,
                      profileImagePath: profileImagePath,
                      ageRange: ageRange, // Mengirimkan rentang usia
                    ),
                  ),
                );

                // Update the state with the new data
                if (updatedData != null) {
                  setState(() {
                    username = updatedData['username'];
                    email = updatedData['email'];
                    height = updatedData['height'];
                    weight = updatedData['weight'];
                    gender = updatedData['gender'];
                    profileImagePath = updatedData['profileImagePath'];
                    ageRange = updatedData['ageRange']; // Mengupdate rentang usia
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
                    _buildInfoItem('Rentang Usia', ageRange), // Menampilkan rentang usia
                    _buildInfoItem('Indeks Masa Tubuh', 'Ideal'),
                  ],
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/login_background.jpg'), // Your image asset path
                  fit: BoxFit.cover, // Cover the whole screen
                ),
              ),
              child: Center(
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      elevation: 8.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: Colors
                          .white, // Set the card background color to white
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                              style: TextStyle(
                                  fontSize: 18, color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 16),

                            // Additional Information Section
                            Text(
                              'Informasi Tambahan',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
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
                                    _buildInfoItem(
                                        'Kategori IMB',
                                        getBmiCategory(
                                            bmi)), // Added BMI category
                                  ],
                                ),
                              ),
                            ),

                            // Edit Profile Button - Positioned at the bottom of the card
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Center(
                                child: CustomButton(
                                  text: 'Edit Profil',
                                  onPressed: () async {
                                    final updatedData = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditProfilScreen(),
                                      ),
                                    );

                                    if (updatedData != null) {
                                      setState(() {
                                        username =
                                            updatedData['username'] ?? username;
                                        email = updatedData['email'] ?? email;
                                        height =
                                            updatedData['height'] ?? height;
                                        weight =
                                            updatedData['weight'] ?? weight;
                                        gender =
                                            updatedData['gender'] ?? gender;
                                        ageRange =
                                            updatedData['ageRange'] ?? ageRange;
                                      });
                                    }
                                  },
                                  verticalPadding: 10.0,
                                  textStyle: const TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
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