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
  String oldPassword = '';

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
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text(
                'Failed to fetch profile data. Please try again later.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> updateProfile() async {
    // Jika password lama kosong, beri pesan error
    if (oldPassword.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please enter your old password.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    if (token == null) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    // Buat Map untuk body request, hanya kirim data yang berubah
    final Map<String, dynamic> bodyData = {};

    bodyData['oldPassword'] = oldPassword;

    // Hanya kirim data username dan email jika mereka berubah
    if (username != '') {
      bodyData['username'] = username;
    }
    if (email != '') {
      bodyData['email'] = email;
    }

    // Kirim request ke API
    final response = await http.put(
      Uri.parse(ApiConfig.profileEndpoint),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(bodyData),
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
                  Navigator.pop(context); // Tutup dialog
                  Navigator.pop(
                      context, updatedData); // Kembalikan data ke ProfileScreen
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else if (response.statusCode == 302) {
      final errorMessage =
          "Username atau email sudah digunakan. Silahkan gunakan yang lain.";

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Validasi error'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else if (response.statusCode == 422) {
      final errorData = json.decode(response.body);
      String errorMessage = "Validation error:\n";
      if (errorData['errors'] != null) {
        errorData['errors'].forEach((key, value) {
          if (key == 'username') {
            errorMessage += "Username is already taken\n";
          } else if (key == 'email') {
            errorMessage += "Email is already taken\n";
          } else {
            errorMessage += "${value[0]}\n";
          }
        });
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Validation Error'),
            content: Text(errorMessage.trim()),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
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
            content: Text(
                'Failed to update profile. Server responded with status code: ${response.statusCode}.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
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
                                TextFormField(
                                  initialValue: username,
                                  decoration: const InputDecoration(
                                      labelText: 'Username'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Masukkan username anda';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) => username = value,
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  initialValue: email,
                                  decoration:
                                      const InputDecoration(labelText: 'Email'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Masukkan email anda';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) => email = value,
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  initialValue: height,
                                  decoration: const InputDecoration(
                                      labelText: 'Tinggi badan (cm)'),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Masukkan tinggi badan anda (cm)';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) => height = value,
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  initialValue: weight,
                                  decoration: const InputDecoration(
                                      labelText: 'Berat badan (kg)'),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Masukkan berat badan anda (kg)';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) => weight = value,
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: 'Masukkan password anda'),
                                  obscureText: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Masukkan password lama anda';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) => oldPassword = value,
                                ),
                                const SizedBox(height: 16),
                                CustomButton(
                                  onPressed: () {
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      updateProfile();
                                    }
                                  },
                                  text: 'Simpan Perubahan',
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
}
