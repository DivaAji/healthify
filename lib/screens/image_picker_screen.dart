import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagePickerScreen extends StatefulWidget {
  @override
  _ImagePickerScreenState createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  File? _image;

  // Fungsi untuk memilih gambar dari galeri
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    // Menyediakan pilihan untuk memilih gambar dari galeri
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Gambar'),
      ),
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
                : Text('Pilih gambar dari galeri'),

            SizedBox(height: 20),

            // Tombol untuk membuka image picker
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pilih Gambar'),
            ),
          ],
        ),
      ),
    );
  }
}
