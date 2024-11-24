import 'package:flutter/material.dart';
import 'package:healthify/screens/program/day_screen.dart';

class MyDetailProgram extends StatefulWidget {
  final String programName;
  final String programImage;
  final String programDescription;

  const MyDetailProgram({
    Key? key,
    required this.programName,
    required this.programImage,
    required this.programDescription,
  }) : super(key: key);

  @override
  _MyDetailProgramState createState() => _MyDetailProgramState();
}

class _MyDetailProgramState extends State<MyDetailProgram> {
  int completedDays = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.programName),
        backgroundColor: const Color.fromRGBO(0, 139, 144, 1).withOpacity(0.5),
      ),
      body: SingleChildScrollView(
        // Membungkus seluruh konten agar bisa discroll
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner image
            Container(
              height: 230,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/${widget.programImage}'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10.0),

            // Description
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                widget.programDescription,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
            ),

            const SizedBox(height: 10.0),

            // Day grid (GridView di sini sudah di-wrap dalam SingleChildScrollView)
            Padding(
              padding: const EdgeInsets.only(right: 18.0, left: 18.0),
              child: GridView.builder(
                physics:
                    const NeverScrollableScrollPhysics(), // Menghentikan scroll pada GridView
                shrinkWrap:
                    true, // Membuat GridView menyesuaikan dengan ukuran yang tersedia
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5, // Number of columns
                  crossAxisSpacing: 9.0,
                  mainAxisSpacing: 7.0,
                ),
                itemCount: 30, // Number of days
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (index <= completedDays) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Day1Screen(
                              day: index + 1,
                              bannerImage: widget.programImage,
                              programCategory: widget.programName,
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: index < completedDays
                            ? Colors.green
                            : const Color(0xFF78B9BA),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      alignment: Alignment.center,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Day',
                                style: TextStyle(
                                    color: Color(0xFF21324B), fontSize: 16),
                              ),
                              Text(
                                '${index + 1}',
                                style: const TextStyle(
                                    color: Color(0xFF21324B), fontSize: 23),
                              ),
                            ],
                          ),
                          if (index > completedDays)
                            const Center(
                              child: Icon(
                                Icons.lock,
                                color: Colors.white,
                                size: 35,
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
