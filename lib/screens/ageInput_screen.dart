import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:healthify/screens/login_screen.dart'; // Atau halaman lainnya sesuai kebutuhan
import 'package:healthify/screens/faceScan_screen.dart';
import 'package:healthify/widgets/button.dart'; // Custom button widget
import 'package:healthify/widgets/card.dart'; // Custom card widget
import 'package:healthify/widgets/text_field.dart'; // Custom text field widget
import 'package:healthify/widgets/dropdown_button.dart'; // Custom dropdown button widget

class AgeinputScreen extends StatefulWidget {
  final int userId; // Menyimpan userId yang dikirim dari halaman sebelumnya
  const AgeinputScreen({super.key, required this.userId});

  @override
  State<AgeinputScreen> createState() => _AgeinputScreenState();
}

class _AgeinputScreenState extends State<AgeinputScreen> {
  final TextEditingController ageController = TextEditingController();
  String ageInputOption = 'Manual'; // Pilihan input umur

  // // Fungsi untuk mengambil gambar dan mengarahkan ke FaceScan
  // Future<void> captureAndUploadImage() async {
  //   try {
  //     final ImagePicker _picker = ImagePicker();
  //     final XFile? pickedFile =
  //         await _picker.pickImage(source: ImageSource.camera);

  //     if (pickedFile != null) {
  //       // Menyimpan path gambar yang diambil
  //       String imagePath = pickedFile.path;

  //       // Arahkan ke halaman FaceScan
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => FaceScan(imagePath: imagePath),
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     print("Error: $e");
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text('Terjadi kesalahan')));
  //   }
  // }

  // Fungsi untuk memperbarui umur secara manual
  Future<void> updateAgeManually() async {
    try {
      final data = {
        'user_id': widget.userId,
        'age': ageController.text, // Dapatkan umur dari inputan
        'image': null, // Jika tidak ada gambar, set image ke null
      };

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

  // Fungsi untuk memperbarui umur dan upload image bersamaan
  Future<void> updateAgeAndImage() async {
    try {
      final data = {
        'user_id': widget.userId,
        'age': null, // Jika ambil gambar, umur tidak diupdate secara manual
      };

      final uri = Uri.parse('http://localhost:8000/api/upload-image');
      final request = http.MultipartRequest('POST', uri)
        ..fields['user_id'] = widget.userId.toString()
        ..files
            .add(await http.MultipartFile.fromPath('image', 'path/to/image'));

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
  void navigateToFaceScan() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FaceScan(), // Directly open FaceScan screen
      ),
    );
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
                onPressed: navigateToFaceScan,
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
