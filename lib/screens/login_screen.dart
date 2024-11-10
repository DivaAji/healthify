import 'package:flutter/material.dart';
import 'package:dio/dio.dart'; // Import dio untuk HTTP request
import 'package:healthify/screens/home_screen.dart';
import 'package:healthify/screens/register_screen.dart';
import 'package:healthify/widgets/button.dart';
import 'package:healthify/widgets/card.dart';
import 'package:healthify/widgets/healthify_text.dart';
import 'package:healthify/widgets/text_field.dart'; // Pastikan ini mengimpor CustomTextField

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
          usernameController.text = response.data['username'] ??
              ''; // Ganti 'name' sesuai data yang diterima
          passwordController.text = response.data['password'] ??
              ''; // Ganti 'password' sesuai data yang diterima
        });
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
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
                    top: 150), // Menurunkan card agar lebih rendah
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
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(33, 50, 75, 1),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        const CustomTextField(
                          labelText: 'Username',
                          controller:
                              usernameController, // Isi controller dengan data
                        ),
                        const SizedBox(height: 15),
                        const CustomTextField(
                          labelText: 'Password',
                          obscureText: true,
                          controller:
                              passwordController, // Isi controller dengan data
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          text: 'Login',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                            );
                          },
                          horizontalPadding:
                              50.0, // Mengatur padding horizontal
                          verticalPadding: 10.0, // Mengatur padding vertical
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Belum punya akun?',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(33, 50, 75, 1),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
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
                              fontSize: 15,
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
