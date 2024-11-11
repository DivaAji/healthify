import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:healthify/screens/login_screen.dart'; // Atau halaman lainnya sesuai kebutuhan
import 'package:healthify/widgets/button.dart'; // Custom button widget
import 'package:healthify/widgets/card.dart'; // Custom card widget
import 'package:healthify/widgets/text_field.dart'; // Custom text field widget
import 'package:healthify/widgets/dropdown_button.dart'; // Custom dropdown button widget

class AgeDetectionScreen extends StatefulWidget {
  final int userId; // Menyimpan userId yang dikirim dari halaman sebelumnya
  const AgeDetectionScreen({super.key, required this.userId});

  @override
  State<AgeDetectionScreen> createState() => _AgeDetectionScreenState();
}

class _AgeDetectionScreenState extends State<AgeDetectionScreen> {
  final TextEditingController ageController = TextEditingController();
  String ageInputOption = 'Manual'; // Pilihan input umur

  // Fungsi untuk mengambil gambar dan upload ke server
  Future<void> captureAndUploadImage() async {
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        final File imageFile = File(pickedFile.path);
        final uri = Uri.parse('http://localhost:8000/api/upload-image');
        final request = http.MultipartRequest('POST', uri)
          ..fields['user_id'] = widget.userId.toString()
          ..files
              .add(await http.MultipartFile.fromPath('image', imageFile.path));

        final response = await request.send();

        if (response.statusCode == 200) {
          // Tampilkan pesan sukses jika berhasil
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Gambar berhasil diunggah')));
        } else {
          // Tampilkan pesan error jika gagal
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Gagal mengunggah gambar')));
        }
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Terjadi kesalahan')));
    }
  }

  Future<void> updateAgeManually() async {
    try {
      final data = {'user_id': widget.userId, 'age': ageController.text};

      final response = await http.post(
        Uri.parse('http://localhost:8000/api/update-age'),
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
              onPressed: ageInputOption == 'Manual' ? updateAgeManually : () {},
              horizontalPadding: 50.0,
              verticalPadding: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}
