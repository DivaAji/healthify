import 'package:flutter/material.dart';
import 'package:healthify/screens/image_picker_screen.dart';
import 'package:healthify/widgets/camera.dart';

class FaceScan extends StatelessWidget {
  const FaceScan({super.key});

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
                child: GestureDetector(
                  onTap: () {
                    _takePicture();
                  },
                  child: Image.asset(
                    'assets/images/ellipse.png',
                    width: screenWidth * 0.2, // Responsive width
                    height: screenWidth * 0.2, // Responsive height to maintain aspect ratio
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
        color: Color.fromRGBO(33, 50, 75, 1),
      ),
      textAlign: TextAlign.center,
    );
  }

  // Function to take a picture
  void _takePicture() {
    // Implement the logic for taking a picture using the camera
    // For example, you can use CameraController from CameraWidget
    // to take a picture and save it to a file or process it further.
  }
}