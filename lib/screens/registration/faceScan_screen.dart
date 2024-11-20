import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:healthify/screens/home_screen.dart';
import 'package:healthify/widgets/button.dart';
import 'package:image_picker/image_picker.dart';
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
  bool _isCardVisible = false;
  bool _isAgeConfirmationVisible = true; // To toggle between text and TextField
  final TextEditingController _ageController = TextEditingController(); // Controller for the age input

  // Method to pick image from camera
  Future<void> _pickImageFromCamera() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImage = bytes;
        });
      } else {
        setState(() {
          _image = File(pickedFile.path);
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
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImage = bytes;
        });
      } else {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memilih gambar')),
      );
    }
  }

  // Method to handle submit age
  void _submitAge() {
    if (_ageController.text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mohon masukkan usia')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Foto')),
      body: Stack(
        children: [
          // Konten utama
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
              if (_image != null)
                CustomButton(
                  onPressed: () {
                    setState(() {
                      _isCardVisible = true;
                    });
                  },
                  text: 'Next >>',
                  textStyle: TextStyle(fontSize: 16),
                  horizontalPadding: 30.0,
                  verticalPadding: 10.0,
                ),
              const SizedBox(height: 10),
            ],
          ),

          // Layer transparan hitam
          if (_isCardVisible)
            Container(
              color: Colors.black.withOpacity(0.6), // Warna hitam transparan
              width: double.infinity,
              height: double.infinity,
            ),

          // Card konfirmasi usia
          if (_isCardVisible)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.25,
              left: MediaQuery.of(context).size.width * 0.1,
              right: MediaQuery.of(context).size.width * 0.1,
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Konfirmasi Usia',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromRGBO(0, 139, 144, 1),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _isAgeConfirmationVisible
                          ? Column(
                              children: [
                                Text(
                                  'Apakah umur anda berada direntang 18 - 30 tahun?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CustomButton(
                                      onPressed: () {
                                        setState(() {
                                          _isAgeConfirmationVisible =
                                              false; // Show TextField
                                        });
                                      },
                                      text: 'Tidak',
                                      textStyle: TextStyle(fontSize: 16),
                                      horizontalPadding: 25.0,
                                      verticalPadding: 5.0,
                                    ),
                                    CustomButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => HomeScreen(),
                                          ),
                                        );
                                      },
                                      text: 'Ya',
                                      textStyle: TextStyle(fontSize: 16),
                                      horizontalPadding: 35.0,
                                      verticalPadding: 5.0,
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                TextField(
                                  controller: _ageController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Pilih rentang Usia', //diganti ke dropdown button saja sehingga rentang usianya sudah di tentukan. Gunakan class CustomDropdownButton() yang ada di widget
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                CustomButton(
                                  onPressed: _submitAge,
                                  text: 'Submit',
                                  textStyle: TextStyle(fontSize: 16),
                                  horizontalPadding: 35.0,
                                  verticalPadding: 10.0,
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
