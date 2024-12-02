import 'package:flutter/material.dart';
import 'package:healthify/screens/login/login_screen.dart';
import 'package:healthify/widgets/program_indicator.dart';

class DetailProgramScreen extends StatelessWidget {
  final String categoryName;
  final List<dynamic> workouts;

  const DetailProgramScreen({
    super.key,
    required this.categoryName,
    required this.workouts,
  });

  @override
  Widget build(BuildContext context) {
    // Menyesuaikan nama file gambar dengan kategori
    String bannerImage = 'assets/images/${categoryName.toLowerCase()}.jpg';

    return Scaffold(
      body: Column(
        children: [
          // Banner
          Container(
            height: MediaQuery.of(context).size.height *
                0.3, // Dynamic height based on screen size
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    bannerImage), // Gambar banner dinamis berdasarkan kategori
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                // Gradasi hitam transparan
                Container(
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.5), // Warna hitam transparan
                        Colors.transparent, // Transparan di bagian bawah
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(
                              context); // Kembali ke halaman sebelumnya
                        },
                      ),
                      SizedBox(
                          height: 80), // Adjusted for a smaller banner height
                      ProgramIndicator(
                        name: categoryName,
                        margin: EdgeInsets.only(left: 3),
                      ),
                      Text(
                        'Latihan Program $categoryName',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Perbatasan antara banner dan konten
          Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey.shade300, // Color for the border line
          ),

          const SizedBox(height: 16),

          // Teks Center
          const Center(
            child: Text(
              'Panduan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(33, 50, 75, 1),
              ),
            ),
          ),

          const SizedBox(height: 4),

          const Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Text(
              'Daftar latihan',
              style:
                  TextStyle(fontSize: 16, color: Color.fromRGBO(33, 50, 75, 1)),
            ),
          ),

          // ListView Latihan
          Expanded(
            child: workouts.isNotEmpty
                ? ListView.builder(
                    itemCount: workouts.length,
                    itemBuilder: (context, index) {
                      final workout = workouts[index];
                      final workoutDetails = workout['workouts_details'];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        workout['category'],
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromRGBO(33, 50, 75, 1),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: workoutDetails.length,
                                        itemBuilder: (context, detailsIndex) {
                                          final detail =
                                              workoutDetails[detailsIndex];
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 10),
                                            child: Card(
                                              elevation: 2,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              child: ListTile(
                                                leading: Icon(
                                                  Icons.fitness_center,
                                                  color: Color.fromRGBO(
                                                      33, 50, 75, 1),
                                                ),
                                                title: Text(
                                                  detail['name'],
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromRGBO(
                                                        33, 50, 75, 1),
                                                  ),
                                                ),
                                                subtitle: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        'Sub Kategori: ${detail['sub_category']}',
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    33,
                                                                    50,
                                                                    75,
                                                                    1))),
                                                    Text(
                                                        'Deskripsi: ${detail['description']}',
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    33,
                                                                    50,
                                                                    75,
                                                                    1))),
                                                    Text(
                                                        'Durasi: ${detail['duration']} menit',
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    33,
                                                                    50,
                                                                    75,
                                                                    1))),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      'Tidak ada latihan untuk kategori ini',
                      style: TextStyle(
                          fontSize: 16, color: Color.fromRGBO(33, 50, 75, 1)),
                    ),
                  ),
          ),

          const SizedBox(height: 20), // Space between content and button

          // Pilih Program Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const LoginScreen(), // Ganti dengan layar tujuan
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(
                    33, 50, 75, 1), // Tombol dengan warna yang sama
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Rounded button
                ),
                minimumSize:
                    const Size(double.infinity, 50), // Full-width button
              ),
              child: const Text(
                'Pilih Program Ini',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20), // Optional space after the button
        ],
      ),
    );
  }
}
