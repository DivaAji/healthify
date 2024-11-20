import 'package:flutter/material.dart';
import 'package:healthify/screens/profile/edit_profil_screen.dart';
import 'package:healthify/widgets/button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = 'Username';
  String email = 'email@example.com';
  String height = '165';
  String weight = '50';
  String gender = 'Perempuan';
  String profileImagePath = 'assets/images/profile_picture.png'; // Default image path
  String ageRange = '18-30'; // Menambahkan rentang usia

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
            // Profile Picture
            GestureDetector(
              onTap: () {
                // Optionally, you can add functionality to edit the profile picture here
              },
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(profileImagePath),
              ),
            ),
            const SizedBox(height: 16),

            // Username
            Text(
              username,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Email
            Text(
              email,
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),

            // Edit Profile Button
            CustomButton(
              text: 'Edit Profil',
              onPressed: () async {
                final updatedData = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfilScreen(
                      username: username,
                      email: email,
                      height: height,
                      weight: weight,
                      gender: gender,
                      profileImagePath: profileImagePath,
                      ageRange: ageRange, // Mengirimkan rentang usia
                    ),
                  ),
                );

                // Update the state with the new data
                if (updatedData != null) {
                  setState(() {
                    username = updatedData['username'];
                    email = updatedData['email'];
                    height = updatedData['height'];
                    weight = updatedData['weight'];
                    gender = updatedData['gender'];
                    profileImagePath = updatedData['profileImagePath'];
                    ageRange = updatedData['ageRange']; // Mengupdate rentang usia
                  });
                }
              },
              verticalPadding: 10.0,
              textStyle: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 16),

            // Additional Information
            Text(
              'Informasi Tambahan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Info List
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: [
                    _buildInfoItem('Jenis Kelamin', gender),
                    _buildInfoItem('Tinggi Badan', height),
                    _buildInfoItem('Berat Badan', weight),
                    _buildInfoItem('Rentang Usia', ageRange), // Menampilkan rentang usia
                    _buildInfoItem('Indeks Masa Tubuh', 'Ideal'),
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