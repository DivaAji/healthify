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
                  Navigator.pop(context, updatedData); // Return updated data
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
      backgroundColor: Colors.white, // White background
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200, // You can customize the color
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back when pressed
          },
        ),
        title: const Text('Edit Profil'),
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
