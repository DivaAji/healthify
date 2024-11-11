import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart'; // For checking if running on Web

class FaceScan extends StatefulWidget {
  final String imagePath; // Path to the selected image
  final int userId;

  const FaceScan({super.key, required this.imagePath, required this.userId});

  @override
  _FaceScanState createState() => _FaceScanState();
}

class _FaceScanState extends State<FaceScan> {
  final ImagePicker _picker = ImagePicker();
  File? _image; // For mobile
  Uint8List? _webImage; // For web

  @override
  void initState() {
    super.initState();
    // If imagePath is passed, we can display the image on initial load
    if (widget.imagePath.isNotEmpty) {
      if (kIsWeb) {
        // For Web, we fetch the image as bytes
        _loadImageFromWeb();
      } else {
        // For mobile, load the image from the path directly
        _image = File(widget.imagePath);
      }
    }
  }

  // Load the image for web (using bytes)
  Future<void> _loadImageFromWeb() async {
    final byteData = await http.get(Uri.parse(widget.imagePath));
    setState(() {
      _webImage = byteData.bodyBytes;
    });
  }

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        // For Web, we convert the file to a byte array (Uint8List)
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImage = bytes;
        });
      } else {
        setState(() {
          _image = File(pickedFile.path); // For mobile
        });
      }

      // Call the upload function once the image is picked
      _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null && _webImage == null) return;

    try {
      final uri = Uri.parse('http://localhost:8000/api/upload-image');
      final request = http.MultipartRequest('POST', uri)
        ..fields['user_id'] = widget.userId.toString(); // Add the userId

      if (kIsWeb) {
        // For Web, upload the image as bytes (Uint8List)
        final byteStream = http.ByteStream.fromBytes(_webImage!);
        final length = _webImage!.length;
        request.files.add(http.MultipartFile('image', byteStream, length,
            filename: 'image.png')); // You can change the filename extension
      } else {
        // For Mobile, upload the image from the path
        request.files
            .add(await http.MultipartFile.fromPath('image', _image!.path));
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gambar berhasil diunggah')),
        );
      } else {
        final responseBody = await http.Response.fromStream(response);
        print("Server response: ${responseBody.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengunggah gambar')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan saat mengunggah gambar')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              // Camera widget for live scanning (optional)
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: screenWidth * 0.5),
                  child: Image.asset(
                    'assets/images/detect_rectangle.png',
                    width: 300,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: screenHeight * 0.05,
                    right: screenWidth * 0.05,
                  ),
                  child: InkWell(
                    onTap: _pickImage, // Trigger image picker on tap
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
            ],
          ),
          SizedBox(height: 20),
          Text(
            'Pastikan gambar yang diunggah benar',
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
              child: kIsWeb
                  ? (_webImage == null
                      ? Center(child: Text('Tidak ada gambar yang dipilih'))
                      : Image.memory(_webImage!)) // For web
                  : (_image == null
                      ? Center(child: Text('Tidak ada gambar yang dipilih'))
                      : Image.file(_image!)), // For mobile
            ),
          ),
        ],
      ),
    );
  }
}
