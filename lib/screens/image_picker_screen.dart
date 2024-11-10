import 'package:flutter/material.dart';
import 'package:healthify/widgets/navigation_bar.dart';
import 'package:healthify/widgets/button.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagePickerScreen extends StatefulWidget {
  @override
  _ImagePickerScreenState createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  File? _image; // Menyimpan gambar yang dipilih

  // Fungsi untuk memilih gambar dari galeri
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    // Menyediakan pilihan untuk memilih gambar dari galeri
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Menyimpan gambar yang dipilih
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Gambar', style: TextStyle(color: Colors.black)),
        backgroundColor:
            Colors.white, // Mengubah warna latar belakang menjadi putih
      ),
      backgroundColor:
          Colors.white, // Mengubah warna latar belakang menjadi putih
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Menampilkan gambar jika sudah ada
            _image != null
                ? Image.file(
                    _image!,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  )
                : Text(
                    'Pilih gambar dari galeri',
                    style: TextStyle(fontSize: 18),
                  ),

            SizedBox(height: 20),

            // Tombol untuk memilih gambar
            CustomButton(
              text: 'Pilih Gambar',
              onPressed: _pickImage,
              textStyle: TextStyle(fontSize: 16),
              horizontalPadding: 30.0,
              verticalPadding: 10.0,
            ),

            SizedBox(height: 15),

            // Menampilkan tombol Submit hanya jika gambar sudah dipilih
            if (_image != null)
              CustomButton(
                text: 'Submit',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyNavigationBar(),
                    ),
                  );
                },
                textStyle: TextStyle(fontSize: 16),
                horizontalPadding: 45.0,
                verticalPadding: 10.0,
              ),
          ],
        ),
      ),
    );
  }
}
