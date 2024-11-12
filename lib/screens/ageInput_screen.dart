import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:healthify/screens/faceScan_screen.dart';
import 'package:healthify/widgets/button.dart';
import 'package:healthify/widgets/text_field.dart';
import 'package:healthify/widgets/dropdown_button.dart';

class AgeinputScreen extends StatefulWidget {
  final int userId;
  const AgeinputScreen({super.key, required this.userId});

  @override
  State<AgeinputScreen> createState() => _AgeinputScreenState();
}

class _AgeinputScreenState extends State<AgeinputScreen> {
  final TextEditingController ageController = TextEditingController();
  String ageInputOption = 'Manual';

  Future<void> updateAgeManually() async {
    try {
      final data = {
        'user_id': widget.userId,
        'age': ageController.text,
      };

      final response = await http.post(
        Uri.parse('http://192.168.1.6:8000/api/update-age'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Umur berhasil diperbarui')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui umur')),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan')),
      );
    }
  }

  void navigateToFaceScan() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FaceScan(
          userId: widget.userId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Deteksi Umur')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CustomDropdownButton(
              labelText: 'Pilih Cara Input Umur',
              selectedValue: ageInputOption,
              items: ['Manual', 'Ambil dari Gambar'],
              onChanged: (String? newValue) {
                setState(() {
                  ageInputOption = newValue!;
                });
              },
            ),
            const SizedBox(height: 15),
            if (ageInputOption == 'Manual')
              CustomTextField(
                controller: ageController,
                labelText: 'Masukkan Umur',
                keyboardType: TextInputType.number,
              ),
            if (ageInputOption == 'Ambil dari Gambar')
              CustomButton(
                text: 'Ambil Gambar untuk Deteksi Umur',
                onPressed: navigateToFaceScan, // Directly navigate to FaceScan
                horizontalPadding: 50.0,
                verticalPadding: 10.0,
              ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Simpan Umur',
              onPressed: ageInputOption == 'Manual'
                  ? updateAgeManually
                  : navigateToFaceScan,
              horizontalPadding: 50.0,
              verticalPadding: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}
