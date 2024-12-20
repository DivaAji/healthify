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
  final _oldPasswordController = TextEditingController();

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
    // If oldPassword is empty, show error
    if (oldPassword.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Masukkan password anda.'),
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

    // Fetch stored values from SharedPreferences
    String? storedUsername = prefs.getString('username');
    String? storedEmail = prefs.getString('email');

    // Create Map for request body, only send changed data
    final Map<String, dynamic> bodyData = {
      'oldPassword': oldPassword, // Always send oldPassword
    };

    // Only include fields in the request if they have changed
    if (username != storedUsername && username.isNotEmpty) {
      bodyData['username'] = username;
    }
    if (email != storedEmail && email.isNotEmpty) {
      bodyData['email'] = email;
    }
    if (height.isNotEmpty) {
      bodyData['height'] = height;
    }
    if (weight.isNotEmpty) {
      bodyData['weight'] = weight;
    }

    // Proceed with API call only if there's any data to update
    if (bodyData.length == 1) {
      // Only oldPassword is present, no other data changed
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Tidak ada perubahan'),
            content: const Text('Tidak ada data yang diubah.'),
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

    // Send request to API
    final response = await http.put(
      Uri.parse(ApiConfig.profileEndpoint),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(bodyData),
    );

    // Handle API response
    if (response.statusCode == 200) {
      final updatedData = json.decode(response.body);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Berhasil'),
            content: const Text('Data profil telah diperbarui'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Navigator.pop(
                      context, true); // Return updated data to ProfileScreen
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else if (response.statusCode == 302) {
      final errorMessage =
          "Username atau Email telah digunakan. Silahkan coba yang lain.";
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Kesalahan'),
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
            content: Text('Gagal mengupdate profil'),
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Edit Profile'),
      ),
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
                                  controller: _oldPasswordController,
                                  decoration: const InputDecoration(
                                    labelText: 'Masukkan Password',
                                    prefixIcon: Icon(Icons.lock),
                                  ),
                                  obscureText: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Masukkan password lama';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    oldPassword = value;
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  initialValue: username,
                                  decoration: const InputDecoration(
                                    labelText: 'Username',
                                    prefixIcon: Icon(Icons.person),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Masukkan username';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    username = value;
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  initialValue: email,
                                  decoration: const InputDecoration(
                                    labelText: 'Email',
                                    prefixIcon: Icon(Icons.email),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Masukkan email';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    email = value;
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  initialValue: height,
                                  decoration: const InputDecoration(
                                    labelText: 'Tinggi Badan (cm)',
                                    prefixIcon: Icon(Icons.height),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Masukkan Tinggi Badan';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    height = value;
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  initialValue: weight,
                                  decoration: const InputDecoration(
                                    labelText: 'Berat Badan (kg)',
                                    prefixIcon: Icon(Icons.fitness_center),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Masukkan Berat Badan';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    weight = value;
                                  },
                                ),
                                const SizedBox(height: 16),
                                CustomButton(
                                  onPressed: () {
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      updateProfile();
                                    }
                                  },
                                  text: 'Simpan',
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
