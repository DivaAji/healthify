import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:healthify/screens/login_screen.dart';
import 'package:camera/camera.dart';
import 'package:healthify/widgets/camera.dart'; // Assuming CameraWidget is defined in this file
import 'package:flutter/services.dart';

class FaceScan extends StatefulWidget {
  const FaceScan({super.key});

  @override
  _FaceScanState createState() => _FaceScanState();
}

class _FaceScanState extends State<FaceScan> {
  CameraController? _cameraController;
  List<CameraDescription>? cameras;
  int _selectedCameraIndex = 0;
  bool isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  // Initialize the camera
  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    if (cameras != null && cameras!.isNotEmpty) {
      _selectedCameraIndex = cameras!.indexWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
      );
      if (_selectedCameraIndex == -1) {
        _selectedCameraIndex =
            0; // Default to rear camera if no front camera found
      }
      _cameraController = CameraController(
        cameras![_selectedCameraIndex],
        ResolutionPreset.high,
      );

      await _cameraController!.initialize();
      setState(() {
        isCameraInitialized = true;
      });
    }
  }

  // Capture image and upload it
  Future<void> _takePictureAndUpload(BuildContext context) async {
    try {
      if (!_cameraController!.value.isInitialized) {
        return;
      }

      final image = await _cameraController!.takePicture();
      if (image != null) {
        final File imageFile = File(image.path);

        // Send the image to the server using HTTP
        final uri = Uri.parse(
            'http://localhost:8000/api/upload-image'); // Update with your server URL
        final request = http.MultipartRequest('POST', uri)
          ..fields['user_id'] = 'user_id' // Replace with actual user_id
          ..files
              .add(await http.MultipartFile.fromPath('image', imageFile.path));

        final response = await request.send();

        if (response.statusCode == 200) {
          // Success
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gambar berhasil diunggah')),
          );
        } else {
          // Failure
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

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
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
              // Camera widget for live scanning
              if (isCameraInitialized) CameraPreview(_cameraController!),
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
                      context); // Capture and upload the image
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
}
