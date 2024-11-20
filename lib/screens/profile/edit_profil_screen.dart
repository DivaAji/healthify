import 'dart:io';
import 'package:flutter/material.dart';
import 'package:healthify/widgets/button.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilScreen extends StatefulWidget {
  final String username;
  final String email;
  final String height;
  final String weight;
  final String gender;
  final String profileImagePath;
  final String ageRange; // Menambahkan field untuk rentang umur

  const EditProfilScreen({
    Key? key,
    required this.username,
    required this.email,
    required this.height,
    required this.weight,
    required this.gender,
    required this.profileImagePath,
    required this.ageRange, // Menambahkan parameter untuk rentang umur
  }) : super(key: key);

  @override
  _EditProfilScreenState createState() => _EditProfilScreenState();
}

class _EditProfilScreenState extends State<EditProfilScreen> {
  final _formKey = GlobalKey<FormState>();
  late String username;
  late String email;
  late String height;
  late String weight;
  late String gender;
  late String profileImagePath;
  late String ageRange; // Menambahkan variabel untuk rentang umur

  @override
  void initState() {
    super.initState();
    username = widget.username;
    email = widget.email;
    height = widget.height;
    weight = widget.weight;
    gender = widget.gender;
    profileImagePath = widget.profileImagePath;
    ageRange = widget.ageRange; // Menginisialisasi rentang umur
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        profileImagePath = image.path; // Memperbarui path gambar profil
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Edit Profile Picture
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: profileImagePath.isNotEmpty
                      ? FileImage(File(profileImagePath))
                      : AssetImage('assets/images/default_profile.png') as ImageProvider,
                ),
              ),
              const SizedBox(height: 16),

              // Field Nama Pengguna
              TextFormField(
                initialValue: username,
                decoration: const InputDecoration(labelText: 'Nama Pengguna'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Silakan masukkan nama pengguna';
                  }
                  return null;
                },
                onChanged: (value) {
                  username = value;
                },
              ),
              const SizedBox(height: 16),

              // Field Email
              TextFormField(
                initialValue: email,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Silakan masukkan email';
                  }
                  return null;
                },
                onChanged: (value) {
                  email = value;
                },
              ),
              const SizedBox(height: 16),

              // Field Tinggi Badan
              TextFormField(
                initialValue: height,
                decoration: const InputDecoration(labelText: 'Tinggi Badan (cm)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Silakan masukkan tinggi badan';
                  }
                  return null;
                },
                onChanged: (value) {
                  height = value;
                },
              ),
              const SizedBox(height: 16),

              // Field Berat Badan
              TextFormField(
                initialValue: weight,
                decoration: const InputDecoration(labelText: 'Berat Badan (kg)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Silakan masukkan berat badan';
                  }
                  return null;
                },
                onChanged: (value) {
                  weight = value;
                },
              ),
              const SizedBox(height: 16),

              // Field Jenis Kelamin (tidak bisa diubah)
              TextFormField(
                enabled: false,
                initialValue: gender,
                decoration: const InputDecoration(labelText: 'Jenis Kelamin'),
              ),
              const SizedBox(height: 16),

              // Field Rentang Umur
              TextFormField(
                initialValue: ageRange,
                decoration: const InputDecoration(labelText: 'Rentang Umur'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Silakan masukkan rentang umur';
                  }
                  return null;
                },
                onChanged: (value) {
                  ageRange = value;
                },
              ),
              const SizedBox(height: 16),

              // Tombol Simpan
              CustomButton(
                text: 'Simpan',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Return updated data to ProfileScreen
                    Navigator.pop(context, {
                      'username': username,
                      'email': email,
                      'height': height,
                      'weight': weight,
                      'gender': gender,
                      'profileImagePath': profileImagePath,
                      'ageRange': ageRange, // Mengembalikan rentang umur
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}