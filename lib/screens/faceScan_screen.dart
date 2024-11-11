import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:healthify/screens/login_screen.dart';
import 'package:healthify/widgets/camera.dart';
import 'package:image_picker/image_picker.dart';

class FaceScan extends StatelessWidget {
  const FaceScan({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              // Menambahkan widget kamera untuk menangkap gambar
              CameraWidget(),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: screenHeight * 0.05,
                    right: screenWidth * 0.05,
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.03,
                        vertical: screenHeight * 0.01,
                      ),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(214, 222, 222, 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Unggah',
                            style: TextStyle(
                              color: Color.fromRGBO(0, 139, 144, 1),
                              fontSize: screenWidth * 0.04,
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.02),
                          Image.asset(
                            'assets/icons/upload.png',
                            width: screenWidth * 0.05,
                            height: screenWidth * 0.05,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: screenWidth * 0.5),
                  child: Image.asset(
                    'assets/images/detect_rectangle.png',
                    width: 300,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            'Pastikan wajah anda terlihat jelas',
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(33, 50, 75, 1),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: GestureDetector(
                onTap: () {
                  _takePictureAndUpload(
                      context); // Menangkap gambar dan langsung upload
                },
                child: Image.asset(
                  'assets/images/ellipse.png',
                  width: 80,
                  height: 40,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk mengambil gambar dan upload ke server
  Future<void> _takePictureAndUpload(BuildContext context) async {
    try {
      // Menggunakan ImagePicker untuk membuka kamera dan mengambil gambar
      final ImagePicker _picker = ImagePicker();
      final XFile? pickedFile = await _picker.pickImage(
          source: ImageSource.camera); // Pastikan hanya kamera yang digunakan

      if (pickedFile != null) {
        final File imageFile = File(pickedFile.path);

        // Mengirim gambar ke server menggunakan HTTP
        final uri = Uri.parse(
            'http://localhost:8000/api/upload-image'); // Ganti dengan URL server Laravel
        final request = http.MultipartRequest('POST', uri)
          ..fields['user_id'] = 'user_id' // Gantilah dengan user_id yang sesuai
          ..files
              .add(await http.MultipartFile.fromPath('image', imageFile.path));

        final response = await request.send();

        if (response.statusCode == 200) {
          // Jika sukses, tampilkan pesan sukses
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gambar berhasil diunggah')),
          );
        } else {
          // Jika gagal, tampilkan pesan gagal
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal mengunggah gambar')),
          );
        }
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan saat mengambil gambar')),
      );
    }
  }
}
