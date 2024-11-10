import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:healthify/screens/register_screen.dart';

import 'package:healthify/widgets/button.dart';import 'package:healthify/widgets/card.dart';
import 'package:healthify/widgets/healthify_text.dart';
import 'package:healthify/widgets/navigation_bar.dart';
import 'package:healthify/widgets/text_field.dart';

bool isObscured = true; // Set default to true for password fields

// Inisialisasi Dio untuk HTTP request
final Dio dio = Dio();
final TextEditingController usernameController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

// Ganti URL dengan URL backend Anda
String urlDomain =
    "http://localhost:8000/"; // Ganti dengan IP server lokal atau domain
String urlGetData = urlDomain + "api/user/2"; // Endpoint API yang sesuai

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchData(); // Panggil fetchData untuk mengambil data dari API
  }

  // Fungsi untuk mengambil data dari API
  Future<void> fetchData() async {
    try {
      Response response = await dio.get(urlGetData);

      if (response.statusCode == 200) {
        // Jika data ditemukan, masukkan data ke controller
        setState(() {
          usernameController.text = response.data['username'] ?? '';
          passwordController.text = response.data['password'] ?? '';
        });
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  // Fungsi untuk validasi input
  void validateLogin() {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      setState(() {
        errorMessage = 'Username dan Password harus diisi!';
      });
    } else {
      setState(() {
        errorMessage = null;
      });
      // Arahkan ke halaman berikutnya jika valid
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MyNavigationBar(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          SizedBox.expand(
            child: Image.asset(
              'assets/images/login_background.jpg',
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height, // Sesuaikan tinggi
            ),
          ),
          // Centering the content with a scrollable card
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 250), // Menurunkan card agar lebih rendah
                child: MyCard(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const HealthifyText(fontSize: 24),
                        const SizedBox(height: 10),
                        const Text(
                          'Siap untuk memulai perjalanan kebugaran Anda? Mari masuk!',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.normal,
                            color: Color.fromRGBO(33, 50, 75, 1),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          labelText: 'Username',
                          controller:
                              usernameController, suffixIcon: null, // Isi controller dengan data
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          labelText: 'Password',
                          obscureText: isObscured, // Use isObscured here
                          controller: passwordController, suffixIcon: null,
                        ),
                        const SizedBox(height: 10),

                        // Menampilkan pesan error jika ada
                        if (errorMessage != null)
                          Text(
                            errorMessage!,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        const SizedBox(height: 10),

                        CustomButton(
                          text: 'Login',
                          onPressed: validateLogin,
                          horizontalPadding:
                              50.0, // Mengatur padding horizontal
                          verticalPadding: 10.0, // Mengatur padding vertical
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          'Belum punya akun?',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(33, 50, 75, 1),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 7),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Daftar untuk memulai!',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color.fromRGBO(0, 139, 144, 1),
                              decoration: TextDecoration.underline,
                              decorationColor: Color.fromRGBO(0, 139, 144, 1),
                            ),
                            textAlign: TextAlign.center,
                          ),
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
