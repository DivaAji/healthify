import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:healthify/screens/faceScan_screen.dart';
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
  final TextEditingController ageController =
      TextEditingController(); // Tambahkan controller untuk usia

  String selectedGender = ''; // Untuk menyimpan pilihan jenis kelamin
  String ageInputOption = 'Manual'; // Default ke input manual untuk usia

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
        Uri.parse('http://localhost:8000/api/user'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      // Tampilkan status dan respons body untuk debug
      print("Status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Asumsikan sukses pada 200 atau 201
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FaceScan()),
        );
      } else {
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
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.25),
                                offset: Offset(0, 4),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 13),
                        const Text(
                          'Bergabunglah dengan kami dalam perjalanan kebugaran Anda!',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(33, 50, 75, 1),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          labelText: 'Username',
                          keyboardType: TextInputType.name, suffixIcon: null,

                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          controller: passwordController,
                          labelText: 'Password',
                          obscureText: true, suffixIcon: null,
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          controller: confirmPasswordController,
                          labelText: 'Konfirmasi Password',
                          obscureText: true, suffixIcon: null,
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          controller: emailController,
                          labelText: 'Email',
                          keyboardType: TextInputType.text, suffixIcon: null,
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
                          keyboardType: TextInputType.number, suffixIcon: null,
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          labelText: 'Tinggi Badan',
                          controller: heightController,
                          keyboardType: TextInputType.number, suffixIcon: null,
                        ),
                        const SizedBox(height: 15),
                        CustomDropdownButton(
                          labelText: 'Input Umur',
                          selectedValue: ageInputOption,
                          items: ['Manual', 'Ambil dari Gambar'],
                          onChanged: (String? newValue) {
                            setState(() {
                              ageInputOption = newValue!;
                            });
                          },
                        ),
                        const SizedBox(height: 15),
                        if (ageInputOption == 'Manual')
                          CustomTextField(
                            labelText: 'Umur',
                            controller: ageController,
                            keyboardType: TextInputType.number, suffixIcon: null,
                          ),
                        const SizedBox(height: 20),
                        CustomButton(
                          text: 'Next',
                          onPressed: () {
                            registerUser(); // Panggil fungsi untuk menyimpan data
                          },
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
