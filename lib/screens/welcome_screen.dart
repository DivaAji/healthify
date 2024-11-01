import 'package:flutter/material.dart';
import 'package:healthify/screens/login_screen.dart';
import 'package:healthify/widgets/healthify_text.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  'assets/images/shape.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  'assets/images/welcome.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),
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
            child: Container(
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
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(17),
              ),
              backgroundColor: const Color.fromRGBO(0, 139, 144, 1),
            ),
            child: Text(
              'Get Started >>',
              style: TextStyle(
                fontFamily: 'Galatea',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
