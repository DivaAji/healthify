import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healthify/screens/login/login_screen.dart'; // Pastikan ini mengarah ke file login Anda

class EditProfilScreen extends StatelessWidget {
  const EditProfilScreen({super.key});

  // Fungsi untuk logout
  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token'); // Hapus token yang tersimpan

    // Arahkan pengguna ke halaman login
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false, // Hapus semua rute sebelumnya
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              logout(context);
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Halaman Edit Profil',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
