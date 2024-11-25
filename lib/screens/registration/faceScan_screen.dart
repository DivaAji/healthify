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
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gambar berhasil diunggah')),
          );
        }
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

  void _showAgeConfirmationDialog(int predictedAge) {
    int ageRange = 0; // Default value
    String message = '';

    // Determine age range based on prediction
    if (predictedAge < 18) {
      ageRange = 1;
      message =
          'Prediksi usia Anda adalah $predictedAge tahun. \nMaaf, Anda belum memenuhi syarat usia minimal untuk menggunakan aplikasi ini.';
    } else if (predictedAge >= 18 && predictedAge <= 30) {
      ageRange = 2;
      message =
          'Prediksi usia Anda adalah $predictedAge tahun (Rentang usia: 18-30 tahun). Apakah ini benar?';
    } else if (predictedAge >= 30 && predictedAge <= 50) {
      ageRange = 3;
      message =
          'Prediksi usia Anda adalah $predictedAge tahun (Rentang usia: 30-50 tahun). Apakah ini benar?';
    } else if (predictedAge > 50) {
      ageRange = 4;
      message =
          'Prediksi usia Anda adalah $predictedAge tahun (Rentang usia: di atas 50 tahun). Apakah ini benar?';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Usia'),
          content: Text(message),
          actions: <Widget>[
            // Options for users under 18 years
            if (predictedAge < 18) ...[
              CustomButton(
                onPressed: () {
                  // Navigate back to login
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                text: 'Kembali ke Login',
                textStyle: TextStyle(fontSize: 14),
                horizontalPadding: 25.0,
                verticalPadding: 8.0,
              ),
              CustomButton(
                onPressed: () {
                  // Input age manually
                  Navigator.pop(context);
                  _showManualAgeInputDialog();
                },
                text: 'Masukkan Usia Manual',
                textStyle: TextStyle(fontSize: 14),
                horizontalPadding: 25.0,
                verticalPadding: 8.0,
              ),
            ],
            // Options for users above 18 years
            if (predictedAge >= 18) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomButton(
                    onPressed: () {
                      // If age is correct, go to the next screen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                      print('Rentang usia pengguna: $ageRange');
                    },
                    text: 'Benar',
                    textStyle: TextStyle(fontSize: 16),
                    horizontalPadding: 30.0,
                    verticalPadding: 8.0,
                  ),
                  SizedBox(width: 10), // Space between the buttons
                  CustomButton(
                    onPressed: () {
                      // If age is incorrect, input age manually
                      Navigator.pop(context);
                      _showManualAgeInputDialog();
                    },
                    text: 'Salah',
                    textStyle: TextStyle(fontSize: 16),
                    horizontalPadding: 30.0,
                    verticalPadding: 8.0,
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }

  void _showManualAgeInputDialog() {
    final TextEditingController ageController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Masukkan Usia Anda'),
          content: TextField(
            controller: ageController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Usia',
              hintText: 'Masukkan usia Anda',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                int? manualAge = int.tryParse(ageController.text);
                if (manualAge != null && manualAge > 0) {
                  // Simpan usia manual ke database
                  final uri =
                      Uri.parse('http://192.168.1.6:8000/api/submit-age');
                  try {
                    final response = await http.post(
                      uri,
                      headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json',
                      },
                      body: json.encode({
                        'user_id': widget.userId,
                        'age': manualAge,
                      }),
                    );

                    // Debugging the response
                    print('Response: ${response.body}');
                    if (response.statusCode == 200) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Usia berhasil disimpan')),
                        );
                      }

                      // Menutup dialog sebelum navigasi
                      if (mounted) {
                        Navigator.pop(context); // Menutup dialog
                      }

                      // Navigasi ke halaman login
                      if (mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      }
                    } else {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Gagal menyimpan usia: ${response.body} (Status: ${response.statusCode})',
                            ),
                          ),
                        );
                      }
                    }
                  } catch (e) {
                    print('Error: $e');
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Terjadi kesalahan')),
                      );
                    }
                  }
                } else {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Harap masukkan usia yang valid dan lebih besar dari 0.'),
                      ),
                    );
                  }
                }
              },
              child: const Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog jika batal
              },
              child: const Text('Batal'),
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
