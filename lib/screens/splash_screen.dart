import 'package:flutter/material.dart';
import 'package:healthify/screens/welcome_screen.dart';
import 'package:healthify/widgets/healthify_text.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

// memanggil splash
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

//durasi splash
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5), () {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF78B9BA), // Warna gradasi awal
              Color(0xFF008B90), // Warna gradasi akhir
            ],
            begin: Alignment.topCenter, // Posisi awal gradasi
            end: Alignment.bottomCenter, // Posisi akhir gradasi
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const HealthifyText(),
                const SizedBox(
                    height: 1), // Jarak antara 'Healthify' dan teks berikutnya
                Text(
                  'Your Path to Holistic Wellness Starts Here.',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color.fromRGBO(146, 36, 19, 1),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
