import 'package:flutter/material.dart';
import 'package:healthify/widgets/button.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Controller untuk mengelola input teks
    final TextEditingController nameController = TextEditingController(text: 'Dappa');
    final TextEditingController emailController = TextEditingController(text: 'Dappa@healthidy.com');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
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

            // Form untuk mengedit nama
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Form untuk mengedit email
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Tombol Simpan
            CustomButton(
              onPressed: () {
                // Aksi ketika tombol simpan ditekan
                print('Profile updated: ${nameController.text}, ${emailController.text}');
                Navigator.pop(context); // Kembali ke halaman profil
              },
              text: 'Simpan',
            ),
          ],
        ),
      ),
    );
  }
}