import 'dart:typed_data';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:healthify/widgets/button.dart';
import 'package:healthify/widgets/navigation_bar.dart';
import 'package:healthify/screens/login/login_screen.dart';
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
  bool _isUploading = false; // Track the uploading state
  bool _isImageUploaded = false; // Track if image is uploaded
  final TextEditingController _ageController = TextEditingController();

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

    setState(() {
      _isUploading = true; // Set loading state to true
    });

    try {
      final uri = Uri.parse('http://192.168.1.6:8000/api/upload-image');
      final request = http.MultipartRequest('POST', uri)
        ..fields['user_id'] = widget.userId.toString();

      // For Web
      if (kIsWeb && _webImage != null) {
        final byteStream = http.ByteStream.fromBytes(_webImage!);
        final length = _webImage!.length;
        request.files.add(http.MultipartFile(
          'image', byteStream, length,
          filename: 'image.png', // Make sure to set the correct extension
        ));
      }
      // For Mobile
      else if (_image != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', _image!.path));
      }

      final response = await request.send();
      final responseBody = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gambar berhasil diunggah')),
        );
        setState(() {
          _isImageUploaded = true;
        });

        // Parse the JSON response from Laravel
        final responseData = json.decode(responseBody.body);
        final predictedAge = responseData['predicted_age']; // Get predicted age

        // After successful upload, show the dialog with predicted age
        Future.delayed(Duration(seconds: 1), () {
          _showAgeConfirmationDialog(predictedAge);
        });
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
    } finally {
      setState(() {
        _isUploading = false; // Hide loading indicator after the upload
      });
    }
  }

  // Show age confirmation dialog
  void _showAgeConfirmationDialog(int predictedAge) {
    String ageRange = '';
    if (predictedAge >= 18 && predictedAge <= 30) {
      ageRange = '18-30';
    } else if (predictedAge >= 30 && predictedAge <= 50) {
      ageRange = '30-50';
    } else if (predictedAge > 50) {
      ageRange = '50+';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Prediksi Usia: $ageRange'),
          content: Text('Apakah prediksi usia Anda benar?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // If "Benar" is pressed, navigate to the Login screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text('Benar'),
            ),
            TextButton(
              onPressed: () {
                // If "Salah" is pressed, go back to FaceScan screen
                Navigator.pop(context);
              },
              child: Text('Salah'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Foto')),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: kIsWeb
                        ? (_webImage == null
                            ? Text('Tidak ada gambar yang dipilih')
                            : Image.memory(_webImage!))
                        : (_image == null
                            ? Text('Tidak ada gambar yang dipilih')
                            : Image.file(_image!)),
                  ),
                ),
              ),
              Text(
                'Pastikan wajah terlihat jelas!',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(33, 50, 75, 1),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              CustomButton(
                onPressed: _pickImageFromCamera,
                text: 'Ambil dari Kamera',
                textStyle: TextStyle(fontSize: 16),
                horizontalPadding: 30.0,
                verticalPadding: 10.0,
              ),
              SizedBox(height: 5),
              CustomButton(
                onPressed: _pickImageFromGallery,
                text: 'Pilih dari Galeri',
                textStyle: TextStyle(fontSize: 16),
                horizontalPadding: 30.0,
                verticalPadding: 10.0,
              ),
              SizedBox(height: 5),
              if (_image != null || _webImage != null)
                CustomButton(
                  onPressed: _uploadImage,
                  text: 'Upload Gambar',
                  textStyle: TextStyle(fontSize: 16),
                  horizontalPadding: 30.0,
                  verticalPadding: 10.0,
                ),
              const SizedBox(height: 10),
            ],
          ),
          if (_isUploading) // Show loading spinner while uploading
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
