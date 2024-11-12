import 'dart:io';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
<<<<<<< HEAD
import 'package:flutter/foundation.dart'; // For checking if running on Web
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;


class FaceScan extends StatefulWidget {
  final int userId;

  const FaceScan({super.key, required this.userId});

  @override
  _FaceScanState createState() => _FaceScanState();
}

class _FaceScanState extends State<FaceScan> {
  final ImagePicker _picker = ImagePicker();
  File? _image; // For mobile
  Uint8List? _webImage; // For web

  // Method to pick image from camera
  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      if (kIsWeb) {
        // For Web, convert file to byte array (Uint8List)
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImage = bytes;
        });
      } else {
        setState(() {
          _image = File(pickedFile.path); // For mobile
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil gambar')),
      );
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null && _webImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tidak ada gambar untuk diunggah')),
      );
      return;
    }
    try {
      final uri = Uri.parse('http://192.168.1.6:8000/api/upload-image');
      final request = http.MultipartRequest('POST', uri)
        ..fields['user_id'] = widget.userId.toString();

      // Untuk Web
      if (kIsWeb && _webImage != null) {
        final byteStream = http.ByteStream.fromBytes(_webImage!);
        final length = _webImage!.length;
        request.files.add(http.MultipartFile(
          'image', byteStream, length,
          filename: 'image.png', // pastikan ekstensi benar
        ));
      }
      // Untuk Mobile
      else if (_image != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', _image!.path));
      }

      final response = await request.send();

      // Cek status code dan response
      final responseBody = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gambar berhasil diunggah')),
        );

        // Arahkan ke halaman login setelah berhasil mengunggah gambar
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        print("Error: ${response.statusCode}, ${responseBody.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengunggah gambar')),
        );
      }
    } catch (e) {
      print('Error uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(content: Text('Terjadi kesalahan saat mengunggah gambar')),

      );
    }
  }

  @override
=======
import 'package:healthify/screens/login_screen.dart';
import 'package:healthify/widgets/camera.dart';
import 'package:image_picker/image_picker.dart';

class FaceScan extends StatelessWidget {
  const FaceScan({super.key});

  @override
>>>>>>> parent of cb12d56 (Commit)
  Widget build(BuildContext context) {
    // Get screen dimensions using MediaQuery
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: Text('Scan Wajah')),
      body: Column(
        children: [
<<<<<<< HEAD
          Expanded(
            child: Center(
              child: kIsWeb
                  ? (_webImage == null
                      ? Text('Tidak ada gambar yang dipilih')
                      : Image.memory(_webImage!)) // For web
                  : (_image == null
                      ? Text('Tidak ada gambar yang dipilih')
                      : Image.file(_image!)), // For mobile
            ),
=======
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
>>>>>>> parent of cb12d56 (Commit)
          ),
          Text(
            'Pastikan gambar yang diunggah benar',
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(33, 50, 75, 1),
            ),
            textAlign: TextAlign.center,
          ),
<<<<<<< HEAD
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _pickImage,
            child: Text('Ambil Gambar'),
=======
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
>>>>>>> parent of cb12d56 (Commit)
          ),
          ElevatedButton(
            onPressed: _uploadImage,
            child: Text('Unggah Gambar'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

<<<<<<< HEAD
  // Function to build the detection overlay
  Widget _buildDetectionOverlay(double screenWidth, double screenHeight) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: screenHeight * 0.3),
        child: Image.asset(
          'assets/images/detect_rectangle.png',
          width: screenWidth * 0.8, // Responsive image width
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // Function to build the instruction text
  Widget _buildInstructionText(double screenWidth) {
    return Text(
      'Pastikan wajah anda terlihat jelas',
      style: TextStyle(
        fontSize: screenWidth * 0.04,
        fontWeight: FontWeight.w400,
        color: const Color.fromRGBO(33, 50, 75, 1),
      ),
      textAlign: TextAlign.center,
    );
  }

  // Function to capture and save the picture
  Widget _buildCaptureButton(BuildContext context, double screenWidth, double screenHeight) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(bottom: screenHeight * 0.005),
        child: Center(
          child: GestureDetector(
            onTap: () {
              _takePictureAndSave(context); // Capture and save the image
            },
            child: Image.asset(
              'assets/images/ellipse.png',
              width: 80,
              height: 40,
            ),
          ),
        ),
      ),
    );
  }
}

class ImageGallerySaver {
  static saveFile(String path) {}
=======
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
>>>>>>> parent of cb12d56 (Commit)
}
