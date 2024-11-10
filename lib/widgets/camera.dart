import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraWidget extends StatefulWidget {
  @override
  _CameraWidgetState createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  CameraController? _cameraController;
  List<CameraDescription>? cameras;
  int _selectedCameraIndex = 0;
  bool _isInitializing = true; // State to track initialization

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  // Initialize camera and set to front camera if available
  Future<void> initCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras!.isNotEmpty) {
        // Find front camera if available
        _selectedCameraIndex = cameras!.indexWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front);

        // If no front camera, use the first available camera
        if (_selectedCameraIndex == -1) {
          _selectedCameraIndex = 0;
        }

        await _initializeCamera(_selectedCameraIndex);
      } else {
        // Handle case where no cameras are available
        // You might want to show a message to the user
        print('No cameras available');
      }
    } catch (e) {
      // Handle errors here
      print('Error initializing camera: $e');
    } finally {
      setState(() {
        _isInitializing = false; // Update the loading state
      });
    }
  }

  // Initialize camera with selected index
  Future<void> _initializeCamera(int cameraIndex) async {
    _cameraController?.dispose(); // Dispose previous camera controller
    _cameraController = CameraController(
      cameras![cameraIndex],
      ResolutionPreset.high,
    );

    await _cameraController!.initialize();
    setState(() {});
  }

  // Function to toggle camera
  void _toggleCamera() {
    if (cameras!.length < 2) return; // Prevent toggling if there's only one camera
    _selectedCameraIndex = (_selectedCameraIndex + 1) % cameras!.length;
    _initializeCamera(_selectedCameraIndex);
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return Center(child: CircularProgressIndicator());
    }

    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Center(child: Text('Camera not initialized'));
    }

    bool isFrontCamera = cameras![_selectedCameraIndex].lensDirection ==
        CameraLensDirection.front;

    return Stack(
      children: [
        Transform(
          alignment: Alignment.center,
          transform:
              isFrontCamera ? Matrix4.rotationY(3.14159) : Matrix4.identity(),
          child: CameraPreview(_cameraController!),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            onPressed: _toggleCamera,
            child: Icon(Icons.cameraswitch),
            backgroundColor: const Color.fromRGBO(214, 222, 222, 1), // Button background color
            foregroundColor: const Color.fromRGBO(0, 139, 144, 1), // Icon color
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }
}