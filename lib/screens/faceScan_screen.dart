import 'package:flutter/material.dart';
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
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: screenHeight *
                        0.05, // Padding atas 5% dari tinggi layar
                    right:
                        screenWidth * 0.08, // Padding kanan 8% dari lebar layar
                  ),
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
                            fontSize:
                                screenWidth * 0.04, // Ukuran teks responsif
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
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.3),
                  child: Image.asset(
                    'assets/images/detect_rectangle.png',
                    width: screenWidth * 0.8, // Lebar gambar responsif
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
          Text(
            'Pastikan wajah anda terlihat jelas',
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(33, 50, 75, 1),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: screenHeight * 0.01),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: screenHeight * 0.02),
              child: GestureDetector(
                onTap: () {
                  _takePicture();
                },
                child: Image.asset(
                  'assets/images/ellipse.png',
                  width: screenWidth * 0.2, // Lebar responsif
                  height: screenWidth *
                      0.2, // Tinggi responsif agar tetap proporsional
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk mengambil gambar
  void _takePicture() {
    // Implementasikan logika pengambilan gambar menggunakan camera
  }
}
