// import 'package:healthify/screens/profile_screen.dart';
// import 'package:healthify/screens/program/kelenturan_screen.dart';
// import 'package:healthify/screens/program/kelincahan_screen.dart';
// import 'package:healthify/screens/program/keseimbangan_screen.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('PROGRAM'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.person),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => ProfileScreen()),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16.0),
//             child: Text(
//               'Sedang Berlangsung',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//           // Gambar histori program
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Image.asset(
//               'assets/images/login_background.jpg', // Ganti dengan path gambar histori program
//               height: 200,
//               width: double.infinity,
//               fit: BoxFit.cover,
//             ),
//           ),
//           const Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16.0),
//             child: Text(
//               'Pilihan Program',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//           // Pilihan Program
//           Expanded(
//             child: ListView(
//               children: const [
//                 ProgramCard(
//                   title: 'Kelincahan',
//                   imageUrl: 'assets/images/login_background.jpg', // Ganti dengan path banner kelincahan
//                   nextPage: KelincahanScreen(title: 'Kelincahan'),
//                 ),
//                 ProgramCard(
//                   title: 'Keseimbangan',
//                   imageUrl: 'assets/images/login_background.jpg', // Ganti dengan path banner keseimbangan
//                   nextPage: KeseimbanganScreen(title: 'Keseimbangan'),
//                 ),
//                 ProgramCard(
//                   title: 'Kelenturan',
//                   imageUrl: 'assets/images/login_background.jpg', // Ganti dengan path banner kelenturan
//                   nextPage: KelenturanScreen(title: 'Kelenturan'),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ProgramCard extends StatelessWidget {
//   final String title;
//   final String imageUrl;
//   final Widget nextPage;

//   const ProgramCard({Key? key, required this.title, required this.imageUrl, required this.nextPage}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => nextPage),
//         );
//       },
//       child: Card(
//         margin: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             Image.asset(
//               imageUrl, // Menggunakan Image.asset untuk gambar lokal
//               height: 200,
//               width: double.infinity,
//               fit: BoxFit.cover,
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// Lebih dinamis

import 'package:flutter/material.dart';
import 'package:healthify/screens/detail_program_screen.dart';
import 'package:healthify/widgets/carousel_slider.dart';
import 'package:healthify/widgets/program_indicator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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

