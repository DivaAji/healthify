import 'package:flutter/material.dart';
import 'package:healthify/screens/image_picker_screen.dart';
import 'package:healthify/widgets/camera.dart';

class FaceScan extends StatelessWidget {
  const FaceScan({super.key});

  @override
  Widget build(BuildContext context) {
    // Mendapatkan ukuran layar menggunakan MediaQuery
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              CameraWidget(),
              _buildUploadButton(context, screenWidth, screenHeight),
              _buildDetectionOverlay(screenWidth, screenHeight),
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
          _buildInstructionText(screenWidth),
          SizedBox(height: screenHeight * 0.01),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: screenHeight * 0.005),
              child: Center(
                child: FloatingActionButton(
                  onPressed: () {
                    _takePicture();
                  },
                  backgroundColor: Colors.white,
                  child: Image.asset(
                    'assets/images/ellipse.png',
                    width: screenWidth * 0.2, // Lebar responsif
                    height: screenWidth * 0.2, // Tinggi responsif agar tetap proporsional
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk membangun tombol unggah
  Widget _buildUploadButton(BuildContext context, double screenWidth, double screenHeight) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: EdgeInsets.only(
          top: screenHeight * 0.05, // Padding atas 5% dari tinggi layar
          right: screenWidth * 0.08, // Padding kanan 8% dari lebar layar
        ),
        child: InkWell(
          onTap: () {
            // Navigasi ke screen image picker
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ImagePickerScreen(),
              ),
            );
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
                    fontSize: screenWidth * 0.04, // Ukuran teks responsif
                  ),
                ),
                SizedBox(width: screenWidth * 0.02), // Jarak responsif
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

  // Fungsi untuk membangun overlay deteksi
  Widget _buildDetectionOverlay(double screenWidth, double screenHeight) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: screenHeight * 0.3),
        child: Image.asset(
          'assets/images/detect_rectangle.png',
          width: screenWidth * 0.8, // Lebar gambar responsif
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // Fungsi untuk membangun teks instruksi
  Widget _buildInstructionText(double screenWidth) {
    return Text(
      'Pastikan wajah anda terlihat jelas',
      style: TextStyle(
        fontSize: screenWidth * 0.04,
        fontWeight: FontWeight.w400,
        color: Color.fromRGBO(33, 50, 75, 1),
      ),
      textAlign: TextAlign.center,
    );
  }

  // Fungsi untuk mengambil gambar
  void _takePicture() {
    // Implementasikan logika pengambilan gambar menggunakan camera
    // Misalnya, Anda dapat menggunakan CameraController dari CameraWidget
    // untuk mengambil gambar dan menyimpannya ke file atau memprosesnya lebih lanjut.
  }
}