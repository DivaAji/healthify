import 'package:flutter/material.dart';
import 'package:healthify/screens/login/login_screen.dart';
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
                    height: MediaQuery.of(context).size.height * 0.55,
                    alignment: Alignment
                        .bottomCenter, // Fokus pada bagian bawah gambar
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      'assets/images/welcome.png',
                      // fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width * 1.8,
                      height: MediaQuery.of(context).size.height * 0.55,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text(
              'Welcome to',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color.fromRGBO(33, 50, 75, 1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 1.0, bottom: 8.0),
              child: const HealthifyText(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Text(
                'Kembangkan kemampuanmu dan raih kesehatan yang optimal bersama kami. Temukan program yang tepat untuk perjalanan kesehatanmu, kapan pun dan di mana pun.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: const Color.fromRGBO(33, 50, 75, 1),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 5),
              child: CustomButton(
                text: 'Get Started >>',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
