import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import image_picker
import 'package:http/http.dart' as http;
import 'package:healthify/screens/login_screen.dart';
import 'package:healthify/screens/ageInput_screen.dart';
import 'package:healthify/widgets/button.dart';
import 'package:healthify/widgets/card.dart';
import 'package:healthify/widgets/text_field.dart';
import 'package:healthify/widgets/dropdown_button.dart'; // Import CustomDropdownButton

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  String selectedGender = '';
  String ageInputOption = 'Manual';
  XFile? _imageFile; // Variable untuk menyimpan gambar yang diambil

  final ImagePicker _picker = ImagePicker(); // Inisialisasi image picker

  Future<void> registerUser() async {
    try {
      final data = {
        'username': usernameController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'gender': selectedGender,
        'weight': weightController.text,
        'height': heightController.text,
        'age': ageController.text,
      };

      final response = await http.post(
        Uri.parse('http://192.168.64.21:8000/api/user'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        print("Response body: ${response.body}");
        if (responseData.containsKey('data') &&
            responseData['data'].containsKey('user_id')) {
          int userId = responseData['data']
              ['user_id']; // Use 'user_id' from the response
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AgeinputScreen(userId: userId),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('ID pengguna tidak ditemukan.')),
          );
        }
      } else {
        print("Unexpected status code: ${response.statusCode}");
        print("Response body: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registrasi gagal! Silakan coba lagi.')),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan. Silakan coba lagi.')),
      );
    }
  }

  // Fungsi untuk mengambil gambar dari kamera
  Future<void> _takePicture() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _imageFile = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/images/login_background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.2,
                left: 20.0,
                right: 20.0,
              ),
              child: MyCard(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Daftar Akun',
                          style: TextStyle(
                            fontFamily: 'Galatea',
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(33, 50, 75, 1),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 13),
                        CustomTextField(
                          controller: usernameController,
                          labelText: 'Username',
                          keyboardType: TextInputType.name,
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          controller: passwordController,
                          labelText: 'Password',
                          obscureText: true,
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          controller: confirmPasswordController,
                          labelText: 'Konfirmasi Password',
                          obscureText: true,
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          controller: emailController,
                          labelText: 'Email',
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 15),
                        CustomDropdownButton(
                          labelText: 'Jenis Kelamin',
                          selectedValue: selectedGender,
                          items: ['Laki-laki', 'Perempuan'],
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedGender = newValue!;
                            });
                          },
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          labelText: 'Berat Badan',
                          controller: weightController,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          labelText: 'Tinggi Badan',
                          controller: heightController,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          text: 'Next',
                          onPressed:
                              registerUser, // Calls registerUser and navigates upon success
                          horizontalPadding: 50.0,
                          verticalPadding: 10.0,
                        ),
                      ],
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
