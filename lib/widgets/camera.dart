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

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  // Inisialisasi kamera dan setel kamera depan jika ada
  Future<void> initCamera() async {
    cameras = await availableCameras();
    if (cameras!.isNotEmpty) {
      // Cari kamera depan jika tersedia
      _selectedCameraIndex = cameras!.indexWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front);

      // Jika tidak ada kamera depan, gunakan kamera pertama
      if (_selectedCameraIndex == -1) {
        _selectedCameraIndex = 0;
      }

      _initializeCamera(_selectedCameraIndex);
    }
  }

  // Inisialisasi kamera dengan index yang dipilih
  Future<void> _initializeCamera(int cameraIndex) async {
    _cameraController?.dispose(); // Bersihkan kontroler kamera sebelumnya
    _cameraController = CameraController(
      cameras![cameraIndex],
      ResolutionPreset.high,
    );

    await _cameraController!.initialize();
    setState(() {});
  }

  // Fungsi untuk mengganti kamera
  void _toggleCamera() {
    _selectedCameraIndex = (_selectedCameraIndex + 1) % cameras!.length;
    _initializeCamera(_selectedCameraIndex);
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      // Tampilkan loading spinner saat kamera belum terinisialisasi
      return Center(child: CircularProgressIndicator());
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
            backgroundColor: const Color.fromRGBO(214, 222, 222, 1),
            foregroundColor: const Color.fromRGBO(0, 139, 144, 1),
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
