import 'package:flutter/material.dart';
import 'package:healthify/screens/profile/edit_profil_screen.dart';
import 'package:healthify/widgets/button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PROFIL'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Gambar Profil
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(
                  'assets/images/profile_picture.png'), //gambar dari scan
            ),
            const SizedBox(height: 16),

            // Nama Pengguna
            Text(
              'Username',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Email Pengguna
            Text(
              'email@example.com',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),

            // Tombol Edit Profil
            CustomButton(
              text: 'Edit Profil',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EditProfilScreen()),
                );
              },
              verticalPadding: 10.0,
              textStyle: const TextStyle(fontSize: 18),
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: [
                    _buildInfoItem('Jenis Kelamin', 'Perempuan'),
                    _buildInfoItem('Tinggi Badan', '165'),
                    _buildInfoItem('Berat Badan', '50'),
                    _buildInfoItem('Rentang usia', '18-30'),
                    _buildInfoItem('Indeks Masa Tubuh',
                        'Ideal'), //ideal, underweight, atau overweight

                    //Rumus perhitungan indeks masa tubuh

                    //IMT = berat badan (kg) / tinggi badan (m)

                    // Kategori IMT (WHO untuk Asia Tenggara):
                    // < 18,5: Berat badan kurang (underweight)
                    // 18,5 - 22,9: Normal (ideal)
                    // 23 - 24,9: Berat badan berlebih (overweight)
                    // ≥ 25: Obesitas
                  ],
                ),
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
