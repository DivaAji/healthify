import 'package:flutter/material.dart';
import 'package:healthify/screens/editProfile_screen.dart';
import 'package:healthify/widgets/button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Gambar Profil
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/kelenturan.jpg'), // Ganti dengan path gambar profil
            ),
            const SizedBox(height: 16),

            // Nama Pengguna
            Text(
              'Dappa',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Email Pengguna
            Text(
              'Dappa@healthidy.com',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),

            // Tombol Edit Profil menggunakan CustomButton
            CustomButton(
              text: 'Edit Profil',
              onPressed: () {
                // Aksi ketika tombol edit ditekan
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                );
              },
            ),

            const SizedBox(height: 16),

            // Informasi Tambahan
            Text(
              'Informasi Tambahan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Daftar Informasi
            Expanded(
              child: ListView(
                children: [
                  _buildInfoItem('Tanggal Lahir', '01 Januari 2000'),
                  _buildInfoItem('Alamat', 'Jl. Pegangsaan Timur.54'),
                  _buildInfoItem('Nomor Telepon', '+62123456789'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 16)),
          Text(value, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
        ],
      ),
    );
  }
}