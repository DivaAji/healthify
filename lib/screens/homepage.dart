import 'package:flutter/material.dart';
import 'package:healthify/screens/detail_program_screen.dart';
import 'package:healthify/widgets/carousel_slider.dart';
import 'package:healthify/widgets/program_indicator.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // list program latihan yang sedang berlangsung (akan disesuaikan dengan database)
    final List<String> selectedProgramImage = [
      'kelenturan.jpg',
      'kelenturan.jpg',
      'kelenturan.jpg',
    ];

    // list semua program latihan (akan disesuaikan dengan database)
    final List<String> allProgramImage = [
      'kelenturan.jpg',
      'kelenturan.jpg',
      'kelenturan.jpg',
    ];

    // list nama program latihan (akan disesuaikan dengan database)
    final List<String> allProgramNames = [
      'KELINCAHAN',
      'KESEIMBANGAN',
      'KELENTURAN',
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: screenWidth * 0.04, top: screenHeight * 0.055),
            child: Text(
              'Hi, username!',
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Galatea',
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(33, 50, 75, 1),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: screenWidth * 0.04, top: screenHeight * 0.02),
            child: Text(
              'SEDANG BERLANGSUNG',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Galatea',
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(33, 50, 75, 1),
              ),
            ),
          ),
          // menampilkan program latihan yang sedang berlangsung saja / yang dipilih
          Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.01),
            child: CustomCarouselSlider(imageUrls: selectedProgramImage),
          ),
          // menampilkan kalimat "PILIHAN PROGRAM"
          Padding(
            padding: EdgeInsets.only(
                left: screenWidth * 0.04, top: screenHeight * 0.025),
            child: Text(
              'PILIHAN PROGRAM',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Galatea',
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(33, 50, 75, 1),
              ),
            ),
          ),
          // menampilkan semua program latihan
          Padding(
            padding: const EdgeInsets.only(top: 0),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              // itemCount disesuaikan dengan jumlah semua program
              itemCount: allProgramImage.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04,
                          vertical: 8.0), // Mengurangi vertical padding
                      child: GestureDetector(
                        onTap: () {
                          // Menavigasi ke halaman detail program saat item di-tap
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyDetailProgram(
                                programName: allProgramNames[index],
                                programImage: allProgramImage[index],
                              ),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Stack(
                            children: [
                              Image.asset(
                                'assets/images/${allProgramImage[index]}',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: screenHeight * 0.17,
                                alignment: Alignment.bottomCenter,
                              ),
                              Positioned(
                                bottom: 20,
                                child: ProgramIndicator(
                                  text: allProgramNames[index],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
