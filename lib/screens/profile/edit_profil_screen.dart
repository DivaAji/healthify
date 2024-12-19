import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healthify/screens/config/api_config.dart';
import 'package:healthify/widgets/button.dart';

class EditProfilScreen extends StatefulWidget {
  const EditProfilScreen({Key? key}) : super(key: key);

  @override
  _EditProfilScreenState createState() => _EditProfilScreenState();
}

class _EditProfilScreenState extends State<EditProfilScreen> {
  String username = '';
  String email = '';
  String height = '';
  String weight = '';
  bool isLoading = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    if (token == null) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    final response = await http.get(
      Uri.parse(ApiConfig.profileEndpoint),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        username = data['username'] ?? '';
        email = data['email'] ?? '';
        height = data['height']?.toString() ?? '';
        weight = data['weight']?.toString() ?? '';
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      showErrorDialog('Failed to fetch profile data.');
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
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

  Future<void> updateProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    if (token == null) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    final response = await http.put(
      Uri.parse(ApiConfig.profileEndpoint),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'username': username,
        'email': email,
        'height': height,
        'weight': weight,
      }),
    );

    if (response.statusCode == 200) {
      final updatedData = json.decode(response.body);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('Profile updated successfully'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, updatedData);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      showErrorDialog('Failed to update profile: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Image.asset(
            'assets/images/login_background.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        color: Colors.white.withOpacity(0.8),
                        elevation: 8.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  'Edit Profil',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF21324B),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Username
                                _buildTextFormField(
                                  label: 'Username',
                                  icon: Icons.person,
                                  initialValue: username,
                                  onChanged: (value) => username = value,
                                ),
                                const SizedBox(height: 16),

                                // Email
                                _buildTextFormField(
                                  label: 'Email',
                                  icon: Icons.email,
                                  initialValue: email,
                                  onChanged: (value) => email = value,
                                ),
                                const SizedBox(height: 16),

                                // Height
                                _buildTextFormField(
                                  label: 'Height (cm)',
                                  icon: Icons.height,
                                  initialValue: height,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) => height = value,
                                ),
                                const SizedBox(height: 16),

                                // Weight
                                _buildTextFormField(
                                  label: 'Weight (kg)',
                                  icon: Icons.monitor_weight,
                                  initialValue: weight,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) => weight = value,
                                ),
                                const SizedBox(height: 16),

                                // Save Button
                                CustomButton(
                                  text: 'Save Changes',
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      updateProfile();
                                    }
                                  },
                                  verticalPadding: 10.0,
                                  textStyle: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildTextFormField({
  required String label,
  required IconData icon,
  required String initialValue,
  required Function(String) onChanged,
  TextInputType keyboardType = TextInputType.text,
}) {
  return TextFormField(
    initialValue: initialValue,
    keyboardType: keyboardType,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(
        icon,
        color: const Color(0xFF21324B), // Icon color
      ),
      labelStyle: TextStyle(
        color: const Color(0xFF21324B), // Label text color
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
          color: const Color(0xFF21324B), // Default border color
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
          color: const Color(0xFF21324B), // Border color when not focused
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
          color: const Color(0xFF21324B), // Border color when focused
        ),
      ),
      filled: true,
      fillColor: Colors.white.withOpacity(0),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter your $label';
      }
      return null;
    },
    onChanged: onChanged,
  );
  }
}
