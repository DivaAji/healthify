import 'package:flutter/material.dart';
import 'package:healthify/screens/profile_screen.dart';
import 'package:healthify/screens/program/kelenturan_screen.dart';
import 'package:healthify/screens/program/kelincahan_screen.dart';
import 'package:healthify/screens/program/keseimbangan_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PROGRAM'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Sedang Berlangsung',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // Gambar histori program
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset(
              'assets/images/login_background.jpg', // Ganti dengan path gambar histori program
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Pilihan Program',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // Pilihan Program
          Expanded(
            child: ListView(
              children: const [
                ProgramCard(
                  title: 'Kelincahan',
                  imageUrl: 'assets/images/login_background.jpg', // Ganti dengan path banner kelincahan
                  nextPage: KelincahanScreen(title: 'Kelincahan'),
                ),
                ProgramCard(
                  title: 'Keseimbangan',
                  imageUrl: 'assets/images/login_background.jpg', // Ganti dengan path banner keseimbangan
                  nextPage: KeseimbanganScreen(title: 'Keseimbangan'),
                ),
                ProgramCard(
                  title: 'Kelenturan',
                  imageUrl: 'assets/images/login_background.jpg', // Ganti dengan path banner kelenturan
                  nextPage: KelenturanScreen(title: 'Kelenturan'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProgramCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final Widget nextPage;

  const ProgramCard({Key? key, required this.title, required this.imageUrl, required this.nextPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => nextPage),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Image.asset(
              imageUrl, // Menggunakan Image.asset untuk gambar lokal
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

