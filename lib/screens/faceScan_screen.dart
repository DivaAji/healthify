import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart'; // For checking if running on Web

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
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: Text('Scan Wajah')),
      body: Column(
        children: [
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
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _pickImage,
            child: Text('Ambil Gambar'),
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
  Widget _buildCaptureButton(
      BuildContext context, double screenWidth, double screenHeight) {
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
}
