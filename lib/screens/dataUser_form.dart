import 'package:flutter/material.dart';
import 'package:healthify/screens/faceScan_screen.dart';
import 'package:healthify/widgets/button.dart';
import 'package:healthify/widgets/card.dart';
import 'package:healthify/widgets/text_field.dart';

class DataUserForm extends StatelessWidget {
  const DataUserForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/images/login_background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.3),
                child: MyCard(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Lengkapi Data Diri',
                          style: TextStyle(
                            fontFamily: 'Galatea',
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(33, 50, 75, 1),
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.25),
                                offset: Offset(0, 4),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 13),
                        const Text(
                          'Lengkapi data berikut dan bantu kami menyesuaikan program anda!',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(33, 50, 75, 1),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          labelText: 'Jenis Kelamin',
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          labelText: 'Berat Badan',
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          labelText: 'Tinggi Badan',
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          text: 'Next',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FaceScan(),
                              ),
                            );
                          },
                          horizontalPadding: 50.0,
                          verticalPadding: 10.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
