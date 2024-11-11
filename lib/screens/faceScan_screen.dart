import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;

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

  // Flip camera
  Future<void> _flipCamera() async {
    if (cameras != null && cameras!.isNotEmpty) {
      // Toggle between 0 and 1 to switch cameras
      _selectedCameraIndex = (_selectedCameraIndex + 1) % cameras!.length;

      // Dispose of the current camera and reinitialize it
      await _cameraController?.dispose();
      _cameraController = CameraController(
        cameras![_selectedCameraIndex],
        ResolutionPreset.high,
      );

      await _cameraController!.initialize();
      setState(() {});
    }
  }

  // Capture image and save it locally
  Future<void> _takePictureAndSave(BuildContext context) async {
    try {
      if (!_cameraController!.value.isInitialized) {
        return;
      }

      final image = await _cameraController!.takePicture();
      if (image != null) {
        final File imageFile = File(image.path);

        // Save the image to the gallery
        final result = await ImageGallerySaver.saveFile(imageFile.path);
        if (result != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gambar berhasil disimpan ke galeri')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal menyimpan gambar')),
          );
        }
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Terjadi kesalahan saat mengambil gambar')),
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
    // Get screen dimensions using MediaQuery
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              // Display live camera feed when initialized
              if (isCameraInitialized)
                CameraPreview(_cameraController!),
              _buildUploadButton(context, screenWidth, screenHeight),
              _buildDetectionOverlay(screenWidth, screenHeight),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: screenHeight * 0.05,
                    right: screenWidth * 0.05,
                  ),
                  child: InkWell(
                    onTap: () {
                      // Navigate to the image picker screen
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.03,
                        vertical: screenHeight * 0.01,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(214, 222, 222, 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Unggah',
                            style: TextStyle(
                              color: const Color.fromRGBO(0, 139, 144, 1),
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
              // Flip Camera Button
              Positioned(
                top: screenHeight * 0.05,
                left: screenWidth * 0.05,
                child: IconButton(
                  icon: Icon(
                    Icons.switch_camera,
                    color: Colors.white,
                    size: screenWidth * 0.07,
                  ),
                  onPressed: _flipCamera,
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
          _buildInstructionText(screenWidth),
          SizedBox(height: screenHeight * 0.01),
          _buildCaptureButton(context, screenWidth, screenHeight),
        ],
      ),
    );
  }

  // Function to build the upload button
  Widget _buildUploadButton(BuildContext context, double screenWidth, double screenHeight) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: EdgeInsets.only(
          top: screenHeight * 0.05, // 5% top padding from screen height
          right: screenWidth * 0.05, // 5% right padding from screen width
        ),
        child: InkWell(
          onTap: () {
            // Navigate to the image picker screen
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.03,
              vertical: screenHeight * 0.01,
            ),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(214, 222, 222, 1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Unggah',
                  style: TextStyle(
                    color: const Color.fromRGBO(0, 139, 144, 1),
                    fontSize: screenWidth * 0.04, // Responsive text size
                  ),
                ),
                SizedBox(width: screenWidth * 0.02), // Responsive spacing
                Image.asset(
                  'assets/icons/upload.png',
                  width: screenWidth * 0.05,
                  height: screenWidth * 0.05,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        ),
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
}
