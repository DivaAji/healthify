import 'dart:typed_data';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:healthify/widgets/button.dart';
import 'package:healthify/widgets/navigation_bar.dart';
import 'package:healthify/screens/login/login_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:healthify/screens/config/api_config.dart';
import 'package:healthify/widgets/dropdown_button.dart';

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
  String selectedAgeRange = '';

  // Method to pick image from camera
  Future<void> _pickImageFromCamera() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        // Reset status upload dan pastikan spinner tidak aktif
        _isUploading = false;
        _isImageUploaded = false;

        // Reset image dan webImage
        _image = null;
        _webImage = null;
      });

      if (kIsWeb) {
        // Untuk Web: Konversi file menjadi Uint8List
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImage = bytes;
        });
      } else {
        // Untuk Mobile: Simpan path file
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengambil gambar')),
      );
    }
  }

// Method to pick image from gallery
  Future<void> _pickImageFromGallery() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        // Reset status upload dan pastikan spinner tidak aktif
        _isUploading = false;
        _isImageUploaded = false;

        // Reset image dan webImage
        _image = null;
        _webImage = null;
      });

      if (kIsWeb) {
        // Untuk Web: Konversi file menjadi Uint8List
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImage = bytes;
        });
      } else {
        // Untuk Mobile: Simpan path file
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memilih gambar')),
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
      final uri = Uri.parse('${ApiConfig.baseUrl}/upload-image');
      print('Debug: Sending request to: $uri');
      final request = http.MultipartRequest('POST', uri)
        ..fields['user_id'] = widget.userId.toString();

      if (kIsWeb && _webImage != null) {
        final byteStream = http.ByteStream.fromBytes(_webImage!);
        final length = _webImage!.length;
        request.files.add(http.MultipartFile(
          'image',
          byteStream,
          length,
          filename: 'image.png',
        ));
      } else if (_image != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', _image!.path));
      }

      final response = await request.send();
      final responseBody = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        // Handle success response
        setState(() {
          _isImageUploaded = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gambar berhasil diunggah')),
        );
        final responseData = json.decode(responseBody.body);
        final ageRange = responseData['ageRange'];
        _showAgeConfirmationDialog(ageRange);
      } else {
        // Handle error response
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

  void _showAgeConfirmationDialog(String ageRange) {
    String message;

    // Message for each age range
    if (ageRange == 'Belum Remaja') {
      message =
          'Prediksi usia Anda adalah Belum Remaja (Dibawah 18 tahun).\n Maaf anda belum mencukupi usia minimal untuk menggunakan aplikasi.';
    } else if (ageRange == 'Remaja') {
      message = 'Prediksi usia Anda adalah Remaja (18-30 tahun).';
    } else if (ageRange == 'Dewasa') {
      message = 'Prediksi usia Anda adalah Dewasa (31-50 tahun).';
    } else if (ageRange == 'Lansia') {
      message = 'Prediksi usia Anda adalah Lansia (di atas 50 tahun).';
    } else {
      message = 'Rentang usia tidak dikenali.\nCoba gunakan gambar lain';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Usia'),
          content: Text(message),
          actions: <Widget>[
            if (ageRange == 'Remaja' ||
                ageRange == 'Dewasa' ||
                ageRange == 'Lansia') ...[
              // Column to place buttons
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Row to place "Salah" and "Benar" buttons side by side
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Tombol "Salah"
                      CustomButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                  'Silahkan upload gambar ulang untuk verifikasi usia.'),
                              duration: Duration(seconds: 3), // Durasi tampil
                            ),
                          );
                        },
                        text: 'Salah',
                        horizontalPadding: 16.0,
                        verticalPadding: 8.0,
                      ),
                      SizedBox(width: 16), // Jarak antar tombol

                      // Tombol "Benar"
                      CustomButton(
                        onPressed: () {
                          Navigator.pop(context); // Close dialog
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        },
                        text: 'Benar',
                        horizontalPadding: 16.0,
                        verticalPadding: 8.0,
                      ),
                    ],
                  ),
                  SizedBox(height: 16), // Jarak antar baris tombol

                  // Tombol "Masukkan Usia Manual"
                  CustomButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                      _showManualAgeInputDialog(); // Allow manual age input
                    },
                    text: 'Masukkan Usia Manual',
                    horizontalPadding: 16.0,
                    verticalPadding: 8.0,
                  ),
                ],
              ),
            ] else ...[
              // Button for under 18 age group
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Tombol Registrasi Ulang
                  CustomButton(
                    onPressed: () async {
                      // Hapus akun pengguna jika usia di bawah 18 tahun
                      final uri = Uri.parse(
                          '${ApiConfig.baseUrl}/user/${widget.userId}');
                      try {
                        final response = await http.delete(uri);
                        if (response.statusCode == 200) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Akun Anda telah dihapus')),
                            );
                          }
                        } else {
                          print('Gagal menghapus akun: ${response.body}');
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Gagal menghapus akun Anda')),
                            );
                          }
                        }
                      } catch (e) {
                        print('Error: $e');
                      } finally {
                        // Arahkan ke halaman login
                        Navigator.pop(context); // Tutup dialog
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      }
                    },
                    text: 'Kembali ke login',
                    horizontalPadding: 16.0,
                    verticalPadding: 8.0,
                  ),
                  SizedBox(height: 16), // Jarak antar tombol

                  // Tombol Masukkan Usia Manual
                  CustomButton(
                    onPressed: () {
                      Navigator.pop(context); // Tutup dialog
                      _showManualAgeInputDialog(); // Izinkan input usia manual
                    },
                    text: 'Masukkan Usia Manual',
                    horizontalPadding: 16.0,
                    verticalPadding: 8.0,
                  ),
                  SizedBox(height: 30),
                  // Tombol Kembali untuk kembali ke halaman sebelumnya
                  CustomButton(
                    onPressed: () {
                      Navigator.pop(context); // Kembali ke halaman sebelumnya
                    },
                    text: 'Kembali',
                    horizontalPadding: 16.0,
                    verticalPadding: 8.0,
                  ),
                  SizedBox(height: 16), // Jarak antar tombol
                ],
              ),
            ],
          ],
        );
      },
    );
  }

  void _showManualAgeInputDialog() {
    String? selectedAgeRangeTemp = selectedAgeRange; // Variabel sementara

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setDialogState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text('Pilih Rentang Usia Anda'),
                    Column(
                      children: [
                        RadioListTile<String>(
                          title:
                              const Text('Belum Remaja \n(Dibawah 18 tahun)'),
                          value: 'Belum Remaja',
                          groupValue: selectedAgeRangeTemp,
                          onChanged: (String? value) {
                            setDialogState(() {
                              selectedAgeRangeTemp = value!;
                            });
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text('Remaja \n(18-30 tahun)'),
                          value: 'Remaja',
                          groupValue: selectedAgeRangeTemp,
                          onChanged: (String? value) {
                            setDialogState(() {
                              selectedAgeRangeTemp = value!;
                            });
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text('Dewasa \n(31-50 tahun)'),
                          value: 'Dewasa',
                          groupValue: selectedAgeRangeTemp,
                          onChanged: (String? value) {
                            setDialogState(() {
                              selectedAgeRangeTemp = value!;
                            });
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text('Lansia \n(50+ tahun)'),
                          value: 'Lansia',
                          groupValue: selectedAgeRangeTemp,
                          onChanged: (String? value) {
                            setDialogState(() {
                              selectedAgeRangeTemp = value!;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          onPressed: () {
                            if (selectedAgeRangeTemp != null) {
                              final uri =
                                  Uri.parse(ApiConfig.manualAgeEndpoint);
                              http.post(uri, body: {
                                'user_id': widget.userId.toString(),
                                'ageRange': selectedAgeRangeTemp,
                              }).then((response) {
                                if (response.statusCode == 200) {
                                  setState(() {
                                    selectedAgeRange = selectedAgeRangeTemp!;
                                  });
                                  Navigator.pop(context);
                                  _showAgeConfirmationDialog(
                                      selectedAgeRangeTemp!);
                                } else {
                                  // Handle failure
                                }
                              });
                            }
                          },
                          child: const Text('Submit'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Batal'),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
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