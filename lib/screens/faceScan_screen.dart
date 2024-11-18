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
  Future<void> _pickImageFromCamera() async {
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

  // Method to pick image from gallery
  Future<void> _pickImageFromGallery() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

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
        SnackBar(content: Text('Gagal memilih gambar')),
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
      final uri = Uri.parse('http://192.168.64.199:8000/api/upload-image');
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
        await _sendImageToFlask(responseBody.body);
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

  Future<void> _sendImageToFlask(String filePath) async {
    final uri =
        Uri.parse('http://192.168.64.199:5000/predict'); // Flask API URL
    final request = http.MultipartRequest('POST', uri)
      ..fields['file_path'] = filePath; // Kirim path gambar ke Flask

    final response = await request.send();
    final responseBody = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      final predictedAge = responseBody.body; // Ambil usia yang diprediksi
      // Kirim hasil prediksi kembali ke Laravel
      await _sendPredictedAgeToLaravel(predictedAge);
    } else {
      print('Error sending image to Flask: ${response.statusCode}');
    }
  }

  Future<void> _sendPredictedAgeToLaravel(String predictedAge) async {
    final uri = Uri.parse('http://192.168.64.199:8000/api/save-predicted-age');
    final request = http.MultipartRequest('POST', uri)
      ..fields['user_id'] = widget.userId.toString()
      ..fields['predicted_age'] = predictedAge;

    final response = await request.send();
    final responseBody = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Prediksi usia berhasil disimpan')),
      );
    } else {
      print('Error saving predicted age: ${response.statusCode}');
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
            onPressed: _pickImageFromCamera,
            child: Text('Ambil Gambar'),
          ),
          ElevatedButton(
            onPressed: _pickImageFromGallery,
            child: Text('Pilih dari Galeri'),
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
}
