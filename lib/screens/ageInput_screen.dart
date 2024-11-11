import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart'; // Make sure the image_picker package is imported
import 'package:healthify/screens/login_screen.dart';
import 'package:healthify/screens/faceScan_screen.dart';
import 'package:healthify/widgets/button.dart';
import 'package:healthify/widgets/card.dart';
import 'package:healthify/widgets/text_field.dart';
import 'package:healthify/widgets/dropdown_button.dart';

class AgeinputScreen extends StatefulWidget {
  final int userId; // Menyimpan userId yang dikirim dari halaman sebelumnya
  const AgeinputScreen({super.key, required this.userId});

  @override
  State<AgeinputScreen> createState() => _AgeinputScreenState();
}

class _AgeinputScreenState extends State<AgeinputScreen> {
  final TextEditingController ageController = TextEditingController();
  String ageInputOption = 'Manual'; // Pilihan input umur
  File? _image; // Image file for the uploaded image

  Future<void> captureAndUploadImage() async {
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        // Store image path in a variable
        String imagePath = pickedFile.path;

        // Navigate to FaceScan screen and pass the image path and userId
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FaceScan(
              imagePath: imagePath, // Pass the image path
              userId: widget.userId, // Pass the userId
            ),
          ),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Terjadi kesalahan')));
    }
  }

  // Fungsi untuk memperbarui umur secara manual
  Future<void> updateAgeManually() async {
    try {
      final data = {
        'user_id': widget.userId,
        'age': ageController.text, // Dapatkan umur dari inputan
        'image': null, // Jika tidak ada gambar, set image ke null
      };

      final response = await http.post(
        Uri.parse('http://192.168.64.21:8000/api/update-age'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LoginScreen()), // Atau halaman lain
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Gagal memperbarui umur')));
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Terjadi kesalahan')));
    }
  }

  // Fungsi untuk memperbarui umur dan upload image bersamaan
  Future<void> updateAgeAndImage() async {
    if (_image == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gambar belum dipilih')));
      return;
    }

    try {
      final uri = Uri.parse('http://192.168.64.21:8000/api/upload-image');
      final request = http.MultipartRequest('POST', uri)
        ..fields['user_id'] = widget.userId.toString()
        ..files.add(await http.MultipartFile.fromPath('image', _image!.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Gambar berhasil diunggah')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Gagal mengunggah gambar')));
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Terjadi kesalahan')));
    }
  }

// Navigates directly to FaceScan screen
  // void navigateToFaceScan(String imagePath) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) =>
  //           FaceScan(imagePath: imagePath), // Pass imagePath to FaceScan
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Deteksi Umur')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CustomDropdownButton(
              labelText: 'Pilih Cara Input Umur',
              selectedValue: ageInputOption,
              items: ['Manual', 'Ambil dari Gambar'],
              onChanged: (String? newValue) {
                setState(() {
                  ageInputOption = newValue!;
                });
              },
            ),
            const SizedBox(height: 15),
            if (ageInputOption == 'Manual')
              CustomTextField(
                controller: ageController,
                labelText: 'Masukkan Umur',
                keyboardType: TextInputType.number,
              ),
            if (ageInputOption == 'Ambil dari Gambar')
              CustomButton(
                text: 'Ambil Gambar untuk Deteksi Umur',
                onPressed: captureAndUploadImage,
                horizontalPadding: 50.0,
                verticalPadding: 10.0,
              ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Simpan Umur',
              onPressed: ageInputOption == 'Manual'
                  ? updateAgeManually
                  : updateAgeAndImage,
              horizontalPadding: 50.0,
              verticalPadding: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}
