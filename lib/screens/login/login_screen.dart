import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:healthify/screens/registration/register_screen.dart';
import 'package:healthify/widgets/button.dart';
import 'package:healthify/widgets/card.dart';
import 'package:healthify/widgets/healthify_text.dart';
import 'package:healthify/widgets/navigation_bar.dart';
import 'package:healthify/widgets/text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isObscured = true; // Set default to true for password fields

// Inisialisasi Dio untuk HTTP request
final Dio dio = Dio();
final TextEditingController usernameController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

// Ganti URL dengan URL backend Anda
String urlDomain =
    "http://192.168.1.6:8000/"; // Ganti dengan IP server lokal atau domain
String urlLogin = urlDomain + "api/login"; // Endpoint API untuk login

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? errorMessage;

  // Fungsi untuk validasi login dan autentikasi
  Future<void> validateLogin() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      setState(() {
        errorMessage = 'Username dan Password harus diisi!';
      });
    } else {
      setState(() {
        errorMessage = null;
      });
      // Kirim request ke backend untuk login dan mendapatkan token
      try {
        Response response = await dio.post(urlLogin, data: {
          'username': usernameController.text,
          'password': passwordController.text,
        });

        if (response.statusCode == 200) {
          // Jika login berhasil, ambil token dari response
          String token = response.data['token'];

          // Simpan token di shared preferences untuk digunakan nanti
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('jwt_token', token);

          // Arahkan ke halaman utama setelah login sukses
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MyNavigationBar(),
            ),
          );
        } else {
          setState(() {
            errorMessage = 'Username atau Password salah!';
          });
        }
      } catch (e) {
        print('Login Error: $e');
        setState(() {
          errorMessage = 'Terjadi kesalahan saat login!';
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkToken();
  }

  // Fungsi untuk memeriksa token saat aplikasi dimulai
  void checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');
    if (token != null) {
      // Jika token ada, arahkan ke halaman utama
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyNavigationBar()),
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
              height: MediaQuery.of(context).size.height,
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
                          controller: usernameController,
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          labelText: 'Password',
                          obscureText: isObscured,
                          controller: passwordController,
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
                          horizontalPadding: 50.0,
                          verticalPadding: 10.0,
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

// Fungsi untuk menambahkan token ke header
Future<void> getUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token =
      prefs.getString('jwt_token'); // Ambil token dari SharedPreferences

  if (token != null) {
    // Menambahkan token ke header Authorization
    dio.options.headers = {
      'Authorization': 'Bearer $token',
    };

    try {
      Response response = await dio.get('http://192.168.1.6:8000/api/user');
      if (response.statusCode == 200) {
        // Mengolah data yang diterima
        print(response.data);
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }
}
