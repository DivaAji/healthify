import 'package:flutter/material.dart';
import 'package:healthify/screens/program/day/day1_screen.dart';

class KelenturanScreen extends StatefulWidget {
  final String title;

  const KelenturanScreen({Key? key, required this.title}) : super(key: key);

  @override
  _KelenturanScreenState createState() => _KelenturanScreenState();
}

class _KelenturanScreenState extends State<KelenturanScreen> {
  int completedDays = 0; // Menyimpan jumlah hari yang telah diselesaikan

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,
        style: TextStyle(
          color: Color(0xFF21324B),
        ),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner dengan teks di dalamnya
            Stack(
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/kelenturan.jpg'), // Ganti dengan path gambar banner
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Center( // Memusatkan konten di dalam Positioned
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFF21324B), // Warna latar belakang kotak
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        'PROGRAM KELENTURAN TUBUH',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            Text(
              'DESKRIPSI',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF21324B)),
            ),
            // Deskripsi
            Text(
              'Tingkatkan fleksibilitas dan mobilitas tubuh dengan latihan peregangan yang aman dan efektif. Cocok untuk semua tingkatan, program ini membantu mengurangi kekakuan, meningkatkan postur, serta mencegah cedera. Jadikan kelenturan bagian dari rutinitas sehat Anda!',
              style: TextStyle(fontSize: 16, color: Color(0xFF21324B)),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 16.0),

            // Kotak hari
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5, // Jumlah kolom
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: 30, // Jumlah hari
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (index <= completedDays) {
                        // Buka halaman baru jika hari tersebut dapat diakses
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Day1Screen(day: index + 1),
                          ),
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: index < completedDays ? Colors.green : const Color(0xFF78B9BA),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      alignment: Alignment.center,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Day',
                                style: TextStyle(color: const Color(0xFF21324B), fontSize: 16),
                              ),
                              Text(
                                '${index + 1}',
                                style: TextStyle(color: const Color(0xFF21324B), fontSize: 30),
                              ), // Tampilkan teks tambahan jika hari dapat diakses
                            ],
                          ),
                          if (index > completedDays) // Tampilkan ikon gembok jika hari tidak dapat diakses
                            Center(
                              child: Icon(
                                Icons.lock,
                                color: const Color.fromARGB(255, 255, 255, 255),
                                size: 40, // Ukuran ikon yang lebih besar
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}