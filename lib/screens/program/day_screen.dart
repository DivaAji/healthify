import 'package:flutter/material.dart';
import 'package:healthify/screens/program/steps_start.dart';
import 'package:healthify/widgets/button.dart';
import 'package:healthify/widgets/program_indicator.dart';

Map<int, List<Map<String, String>>> latihanProgram = {
  1: [
    {
      'kategori': 'Kelincahan',
      'step': 'Lari tempat',
      'durasi': '1 menit', //waktunya menyesuaikan tipe datanya
      'image': 'assets/images/kelenturan.jpg'
    },
    {
      'kategori': 'Kelincahan',
      'step': 'Skipping',
      'durasi': '1 menit',
      'image': 'assets/images/kelenturan.jpg'
    },
    {
      'kategori': 'Kelenturan',
      'step': 'Peregangan kaki & punggung',
      'durasi': '2 menit',
      'image': 'assets/images/kelenturan.jpg'
    },
    {
      'kategori': 'Kekuatan',
      'step': 'Push-up 10x',
      'durasi': '2 menit',
      'image': 'assets/images/kelenturan.jpg'
    },
    {
      'kategori': 'Kelenturan',
      'step': 'Peregangan pinggang',
      'durasi': '2 menit',
      'image': 'assets/images/kelenturan.jpg'
    },
  ],
  2: [
    {
      'kategori': 'Kelenturan',
      'step': 'Peregangan leher & bahu',
      'durasi': '2 menit',
      'image': 'assets/images/kelenturan.jpg'
    },
    {
      'kategori': 'Kelenturan',
      'step': 'Peregangan tubuh bagian atas',
      'durasi': '2 menit',
      'image': 'assets/images/kelenturan.jpg'
    },
    {
      'kategori': 'Kekuatan',
      'step': 'Plank 30 detik',
      'durasi': '1 menit',
      'image': 'assets/images/kelenturan.jpg'
    },
    {
      'kategori': 'Kelincahan',
      'step': 'Lari zig-zag',
      'durasi': '2 menit',
      'image': 'assets/images/kelenturan.jpg'
    },
    {
      'kategori': 'Kekuatan',
      'step': 'Dips 10x',
      'durasi': '2 menit',
      'image': 'assets/images/kelenturan.jpg'
    },
  ],
};

class Day1Screen extends StatefulWidget {
  final int day;
  final String bannerImage;
  final String programCategory;

  const Day1Screen({
    Key? key,
    required this.day,
    required this.bannerImage,
    required this.programCategory,
  }) : super(key: key);

  @override
  _Day1ScreenState createState() => _Day1ScreenState();
}

class _Day1ScreenState extends State<Day1Screen> {
  @override
  Widget build(BuildContext context) {
    // filter berdasarkan kategori program
    final filteredPrograms = latihanProgram[widget.day]
        ?.where(
          (program) =>
              program['kategori']!.toLowerCase() ==
              widget.programCategory.toLowerCase(),
        )
        ?.toList();

    return Scaffold(
      body: Column(
        children: [
          // Banner
          Container(
            height: 300,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/${widget.bannerImage}'),
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
                  bottom: 20,
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
                      SizedBox(height: 100),
                      ProgramIndicator(
                        name: widget.programCategory,
                        margin: EdgeInsets.only(left: 3),
                      ),
                      Text(
                        'Latihan Hari ${widget.day}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.timer, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            'Durasi: 10 menit', //jumlah semua durasi latihan dihari itu
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Teks Center
          const Center(
            child: Text(
              'Panduan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 4),

          const Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Text(
              '5 step latihan',
              style: TextStyle(fontSize: 16),
            ),
          ),

          // ListView Latihan
          Expanded(
            child: filteredPrograms != null && filteredPrograms.isNotEmpty
                ? ListView.builder(
                    itemCount: filteredPrograms.length,
                    itemBuilder: (context, index) {
                      final program = filteredPrograms[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(
                                program['image']!,
                                height: 72,
                                width: 72,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    program['step']!,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    program['durasi']!,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      'Tidak ada latihan untuk kategori ini',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: CustomButton(
            text: 'Start',
            onPressed: () {
              if (filteredPrograms != null && filteredPrograms.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProgramSteps(
                      steps: filteredPrograms, // Kirim langkah-langkah
                      currentStep: 0, // Mulai dari langkah pertama
                    ),
                  ),
                );
              }
            },
            horizontalPadding: 10.0,
            verticalPadding: 10.0,
          ),
        ),
      ),
    );
  }
}
