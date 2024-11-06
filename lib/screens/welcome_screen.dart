import 'package:flutter/material.dart';
import 'package:healthify/screens/login_screen.dart';
import 'package:healthify/widgets/healthify_text.dart';
import 'package:healthify/widgets/button.dart'; // Impor kelas CustomButton

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Untuk membuat layar bisa di-scroll jika konten terlalu panjang
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    'assets/images/shape.png',
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height *
                        0.5, // Sesuaikan tinggi untuk proporsi yang baik
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    'assets/images/welcome.png',
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height *
                        0.4, // Sesuaikan tinggi
                  ),
                ),
              ],
            ),
            const SizedBox(height: 85),
            Text(
              'Welcome to',
              style: TextStyle(
                fontFamily: 'Galatea',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color.fromRGBO(33, 50, 75, 1),
              ),
            ),
            const SizedBox(height: 1),
            const HealthifyText(),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Temukan program yang tepat untuk perjalanan kesehatan anda, kapan pun dan di mana pun.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: const Color.fromRGBO(33, 50, 75, 1),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            CustomButton(
              text: 'Get Started >>', // Ganti teks di sini
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
