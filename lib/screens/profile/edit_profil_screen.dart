import 'dart:io';
import 'package:flutter/material.dart';
import 'package:healthify/widgets/button.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilScreen extends StatefulWidget {
  final String username;
  final String email;
  final String height;
  final String weight;
  final String gender;
  final String profileImagePath;
  final String ageRange; // Menambahkan field untuk rentang umur

  const EditProfilScreen({
    Key? key,
    required this.username,
    required this.email,
    required this.height,
    required this.weight,
    required this.gender,
    required this.profileImagePath,
    required this.ageRange, // Menambahkan parameter untuk rentang umur
  }) : super(key: key);

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
  final _formKey = GlobalKey<FormState>();
  late String username;
  late String email;
  late String height;
  late String weight;
  late String gender;
  late String profileImagePath;
  late String ageRange; // Menambahkan variabel untuk rentang umur
  String username = '';
  String email = '';
  String height = '';
  String weight = '';

  bool isLoading = true;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    username = widget.username;
    email = widget.email;
    height = widget.height;
    weight = widget.weight;
    gender = widget.gender;
    profileImagePath = widget.profileImagePath;
    ageRange = widget.ageRange; // Menginisialisasi rentang umur
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        profileImagePath = image.path; // Memperbarui path gambar profil
      });
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token'); // Retrieve token

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
                  Navigator.pop(context, updatedData); // Return updated data
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to update profile: ${response.body}'),
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
          // Content on top of background image
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        elevation: 8.0, // Optional shadow for the card
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
                                // Username
                                TextFormField(
                                  initialValue: username,
                                  decoration: const InputDecoration(
                                      labelText: 'Username'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your username';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    username = value;
                                  },
                                ),
                                const SizedBox(height: 16),

                                // Email
                                TextFormField(
                                  initialValue: email,
                                  decoration:
                                      const InputDecoration(labelText: 'Email'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    email = value;
                                  },
                                ),
                                const SizedBox(height: 16),

                                // Height
                                TextFormField(
                                  initialValue: height,
                                  decoration: const InputDecoration(
                                      labelText: 'Height (cm)'),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your height';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    height = value;
                                  },
                                ),
                                const SizedBox(height: 16),

                                // Weight
                                TextFormField(
                                  initialValue: weight,
                                  decoration: const InputDecoration(
                                      labelText: 'Weight (kg)'),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your weight';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    weight = value;
                                  },
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Edit Profile Picture
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: profileImagePath.isNotEmpty
                      ? FileImage(File(profileImagePath))
                      : AssetImage('assets/images/default_profile.png') as ImageProvider,
                ),
              ),
              const SizedBox(height: 16),

              // Field Nama Pengguna
              TextFormField(
                initialValue: username,
                decoration: const InputDecoration(labelText: 'Nama Pengguna'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Silakan masukkan nama pengguna';
                  }
                  return null;
                },
                onChanged: (value) {
                  username = value;
                },
              ),
              const SizedBox(height: 16),

              // Field Email
              TextFormField(
                initialValue: email,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Silakan masukkan email';
                  }
                  return null;
                },
                onChanged: (value) {
                  email = value;
                },
              ),
              const SizedBox(height: 16),

              // Field Tinggi Badan
              TextFormField(
                initialValue: height,
                decoration: const InputDecoration(labelText: 'Tinggi Badan (cm)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Silakan masukkan tinggi badan';
                  }
                  return null;
                },
                onChanged: (value) {
                  height = value;
                },
              ),
              const SizedBox(height: 16),

              // Field Berat Badan
              TextFormField(
                initialValue: weight,
                decoration: const InputDecoration(labelText: 'Berat Badan (kg)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Silakan masukkan berat badan';
                  }
                  return null;
                },
                onChanged: (value) {
                  weight = value;
                },
              ),
              const SizedBox(height: 16),

              // Field Jenis Kelamin (tidak bisa diubah)
              TextFormField(
                enabled: false,
                initialValue: gender,
                decoration: const InputDecoration(labelText: 'Jenis Kelamin'),
              ),
              const SizedBox(height: 16),

              // Field Rentang Umur
              TextFormField(
                initialValue: ageRange,
                decoration: const InputDecoration(labelText: 'Rentang Umur'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Silakan masukkan rentang umur';
                  }
                  return null;
                },
                onChanged: (value) {
                  ageRange = value;
                },
              ),
              const SizedBox(height: 16),

              // Tombol Simpan
              CustomButton(
                text: 'Simpan',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Return updated data to ProfileScreen
                    Navigator.pop(context, {
                      'username': username,
                      'email': email,
                      'height': height,
                      'weight': weight,
                      'gender': gender,
                      'profileImagePath': profileImagePath,
                      'ageRange': ageRange, // Mengembalikan rentang umur
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
