import 'package:flutter/material.dart';
import 'package:healthify/screens/home_screen.dart';
import 'package:healthify/widgets/button.dart';
import 'package:healthify/widgets/navigation_bar.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class StepsFinish extends StatefulWidget {
  const StepsFinish({super.key});

  @override
  _StepsFinishState createState() => _StepsFinishState();
}

class _StepsFinishState extends State<StepsFinish> {
  @override
  void initState() {
    super.initState();
    WakelockPlus.disable(); // Menonaktifkan wakelock saat layar dimuat
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gambar latar belakang yang menutupi seluruh layar
          Image.asset(
            'assets/images/vector.png',
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height *
                0.6, // Mengatur tinggi penuh
            width: MediaQuery.of(context).size.width, // Mengatur lebar penuh
          ),
          // Konten lainnya (jika ada)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                  Image.asset(
                    'assets/images/check.png',
                    fit: BoxFit.cover,
                    height: 320,
                    width: 320,
                  ),
                  SizedBox(height: 40),
                  Text(
                    'Latihan Selesai !',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF21324B),
                      shadows: [
                        Shadow(
                          offset: Offset(0, 1), // Bayangan teks
                          blurRadius: 3.0,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10),
                    child: Text(
                      'Selamat atas pencapaiannya',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF21324B),
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1), // Bayangan teks
                            blurRadius: 2.0,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20),
                  CustomButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyNavigationBar(),
                        ),
                      );
                    },
                    text: '>>',
                    textStyle: TextStyle(fontSize: 20),
                    horizontalPadding: 50.0,
                    verticalPadding: 10.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
