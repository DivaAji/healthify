import 'package:flutter/material.dart';
import 'package:healthify/screens/program/detail_program_screen.dart';
import 'package:healthify/screens/profil/profile_screen.dart';
import 'package:healthify/widgets/carousel_slider.dart';
import 'package:healthify/widgets/navigation_bar.dart';
import 'package:healthify/widgets/program_indicator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // List program yang sedang berlangsung (sesuaikan dg database)
    final List<Map<String, String>> selectedPrograms = [
      {
        'name': 'KELENTURAN',
        'image': 'kelenturan.jpg',
        'description':
            'Latihan kelenturan adalah jenis latihan fisik yang bertujuan untuk meningkatkan kemampuan otot dan sendi tubuh agar dapat bergerak dengan leluasa, nyaman, dan tanpa rasa sakit dalam rentang gerak yang maksimal. Latihan ini penting untuk menjaga postur tubuh, mencegah cedera, dan meningkatkan performa dalam aktivitas sehari-hari.'
      },
      {
        'name': 'KELINCAHAN',
        'image': 'kelenturan.jpg',
        'description':
            'Kelincahan merupakan salah satu komponen penting dalam kebugaran fisik yang mencerminkan kemampuan seseorang untuk bergerak cepat, tepat, dan seimbang dalam berbagai arah. Selain itu, kelincahan yang baik juga berperan dalam mengurangi risiko cedera serta meningkatkan kemampuan fungsional sehari-hari. Latihan ini penting bagi pengguna yang ingin mencapai tubuh yang lebih sehat dan tangkas.'
      },
    ];

    // List semua program yang ditawarkan (sesuaikan dengan database)
    final List<Map<String, String>> allPrograms = [
      {
        'name': 'KELINCAHAN',
        'image': 'kelenturan.jpg',
        'description':
            'Kelincahan merupakan salah satu komponen penting dalam kebugaran fisik yang mencerminkan kemampuan seseorang untuk bergerak cepat, tepat, dan seimbang dalam berbagai arah. Selain itu, kelincahan yang baik juga berperan dalam mengurangi risiko cedera serta meningkatkan kemampuan fungsional sehari-hari. Latihan ini penting bagi pengguna yang ingin mencapai tubuh yang lebih sehat dan tangkas.'
      },
      {
        'name': 'KESEIMBANGAN',
        'image': 'kelenturan.jpg',
        'description':
            'Latihan keseimbangan adalah jenis aktivitas yang bertujuan untuk meningkatkan kemampuan tubuh dalam mempertahankan posisi stabil, baik dalam keadaan diam maupun bergerak. Keseimbangan merupakan komponen penting dalam kebugaran fisik, terutama untuk mendukung koordinasi tubuh, postur, dan mencegah cedera, terutama pada orang lanjut usia atau atlet.'
      },
      {
        'name': 'KELENTURAN',
        'image': 'kelenturan.jpg',
        'description':
            'Latihan kelenturan adalah jenis latihan fisik yang bertujuan untuk meningkatkan kemampuan otot dan sendi tubuh agar dapat bergerak dengan leluasa, nyaman, dan tanpa rasa sakit dalam rentang gerak yang maksimal. Latihan ini penting untuk menjaga postur tubuh, mencegah cedera, dan meningkatkan performa dalam aktivitas sehari-hari.'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('PROGRAM'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Menampilkan greeting
            // Padding(
            //   padding: EdgeInsets.only(
            //       left: screenWidth * 0.04, top: screenHeight * 0.002),
            //   child: Text(
            //     'Hi, username!',
            //     style: TextStyle(
            //       fontSize: 24,
            //       fontFamily: 'Galatea',
            //       fontWeight: FontWeight.bold,
            //       color: Color.fromRGBO(33, 50, 75, 1),
            //     ),
            //   ),
            // ),
            // Menampilkan bagian "SEDANG BERLANGSUNG"
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
            // Menampilkan carousel untuk program yang sedang berlangsung
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.01),
              child: CustomCarouselSlider(
                imageUrls: selectedPrograms
                    .map((program) => program['image']!)
                    .toList(),
                chosenPrograms: selectedPrograms
                    .map((program) => program['name']!)
                    .toList(),
                descriptions: selectedPrograms
                    .map((program) => program['description']!)
                    .toList(),
              ),
            ),
            // Menampilkan bagian "PILIHAN PROGRAM"
            Container(
              child: Padding(
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
            ),
            // Menampilkan daftar semua program
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: allPrograms.length,
              itemBuilder: (context, index) {
                final program = allPrograms[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.04,
                        vertical: 10.0, // Cek indeks pertama
                      ),
                      child: GestureDetector(
                        onTap: () {
                          // Menavigasi ke halaman detail program
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyDetailProgram(
                                programName: program['name']!,
                                programImage: program['image']!,
                                programDescription: program['description']!,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 5, // Memberikan efek shadow pada Card
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10), // Sudut melengkung
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                10), // Pastikan gambar mengikuti sudut melengkung
                            child: Stack(
                              children: [
                                Image.asset(
                                  'assets/images/${program['image']}',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: screenHeight * 0.18,
                                  alignment: Alignment.bottomCenter,
                                ),
                                Positioned(
                                  bottom: 20,
                                  child: ProgramIndicator(
                                    name: program['name']!,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      // bottomNavigationBar: const MyNavigationBar(),
    );
  }
}
