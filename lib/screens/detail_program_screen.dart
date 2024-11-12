import 'package:flutter/material.dart';
import 'package:healthify/screens/program/day/day1_screen.dart';

class MyDetailProgram extends StatefulWidget {
  final String programName;
  final String programImage;

  const MyDetailProgram({
    Key? key,
    required this.programName,
    required this.programImage,
  }) : super(key: key);

  @override
  _MyDetailProgramState createState() => _MyDetailProgramState();
}

class _MyDetailProgramState extends State<MyDetailProgram> {
  int completedDays = 0; // Store the number of completed days

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.programName), // Use the programName here
        backgroundColor: Color.fromRGBO(0, 139, 144, 1).withOpacity(0.5),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner image
            Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/${widget.programImage}'), // Dynamically use the program image
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Description
            Text(
              'Tingkatkan fleksibilitas dan mobilitas tubuh dengan latihan peregangan yang aman dan efektif. Cocok untuk semua tingkatan, program ini membantu mengurangi kekakuan, meningkatkan postur, serta mencegah cedera. Jadikan kelenturan bagian dari rutinitas sehat Anda!',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 16.0),

            // Day grid
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5, // Number of columns
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: 30, // Number of days
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (index <= completedDays) {
                        // Navigate to the day detail if the day is accessible
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Day1Screen(
                                day: index + 1), // Implement Day1Screen
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
                              Text(
                                'Day',
                                style: TextStyle(
                                    color: const Color(0xFF21324B),
                                    fontSize: 16),
                              ),
                              Text(
                                '${index + 1}',
                                style: TextStyle(
                                    color: const Color(0xFF21324B),
                                    fontSize: 30),
                              ),
                            ],
                          ),
                          if (index >
                              completedDays) // Show lock icon for inaccessible days
                            Center(
                              child: Icon(
                                Icons.lock,
                                color: Colors.white,
                                size: 40,
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
