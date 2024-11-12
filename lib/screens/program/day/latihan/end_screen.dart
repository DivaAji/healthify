import 'package:flutter/material.dart';
import 'package:healthify/screens/home_screen.dart';
import 'package:healthify/widgets/button.dart';

class CompletionScreen extends StatelessWidget {
  final List<String> exercises;

  const CompletionScreen({Key? key, required this.exercises}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selesai', style: TextStyle(color: Color(0xFF21324B))),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Center alignment for the column
          children: [
            // Banner Image with Border Radius
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0), // Add border radius
              child: Container(
                height: 150,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/kelenturan.jpg'), // Change to your banner image path
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Congratulatory Message
            const Text(
              'Selamat!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
              textAlign: TextAlign.center, // Center text
            ),
            const SizedBox(height: 10),
            const Text(
              'Anda telah menyelesaikan latihan hari pertama!',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center, // Center text
            ),
            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Rekapan Latihan',
                  style: TextStyle(fontSize: 24, color: Color(0xFF21324B), fontWeight: FontWeight.bold),
                ),
              ),
            ),
             const SizedBox(height: 10),

            // List of Completed Exercises with Check Icon
            Expanded(
              child: ListView.builder(
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      leading: const Icon(
                        Icons.check_circle, // Check icon
                        color: Colors.green,
                      ),
                      title: Text(
                        exercises[index],
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Centered Button to go back to the main menu or restart
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Center( // Center the button
                child: CustomButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()), // Ensure HomeScreen is pushed correctly
                    );
                  },
                  text: 'Kembali ke Menu Utama',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}