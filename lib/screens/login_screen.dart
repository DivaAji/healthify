import 'package:flutter/material.dart';
import 'package:healthify/screens/home_screen.dart';
import 'package:healthify/screens/register_screen.dart';
import 'package:healthify/widgets/button.dart';
import 'package:healthify/widgets/card.dart';
import 'package:healthify/widgets/healthify_text.dart';
import 'package:healthify/widgets/text_field.dart'; // Pastikan ini mengimpor CustomTextField

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/images/login_background.jpg',
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height, // Sesuaikan tinggi
            ),
          ),
          Center(
            child: SingleChildScrollView(
              // Tambahkan SingleChildScrollView agar layar dapat di-scroll
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 250), // Menurunkan card dari tengah
                child: MyCard(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // Sesuaikan ukuran card
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
                        const SizedBox(height: 15),
                        CustomTextField(
                          labelText: 'Username',
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          labelText: 'Password',
                          obscureText: true,
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
