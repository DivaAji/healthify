import 'package:flutter/material.dart';
import 'package:healthify/screens/faceScan_screen.dart';
import 'package:healthify/widgets/button.dart';
import 'package:healthify/widgets/card.dart';
import 'package:healthify/widgets/text_field.dart';
import 'package:healthify/widgets/dropdown_button.dart'; // Import CustomDropdownButton

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  String selectedGender = ''; // Untuk menyimpan pilihan jenis kelamin

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
            child: Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.2,
                left: 20.0,
                right: 20.0,
              ),
              child: MyCard(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize:
                          MainAxisSize.min, // Minimize the height of the column
                      children: [
                        Text(
                          'Daftar Akun',
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
                          'Bergabunglah dengan kami dalam perjalanan kebugaran Anda!',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(33, 50, 75, 1),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          controller: usernameController,
                          labelText: 'Username',
                          keyboardType: TextInputType.name,
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          controller: passwordController,
                          labelText: 'Password',
                          obscureText: true,
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          controller: confirmPasswordController,
                          labelText: 'Konfirmasi Password',
                          obscureText: true,
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 15),

                        // Jenis Kelamin Dropdown menggunakan CustomDropdownButton
                        CustomDropdownButton(
                          labelText: 'Jenis Kelamin',
                          selectedValue: selectedGender,
                          items: ['Laki-laki', 'Perempuan'],
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedGender = newValue!;
                            });
                          },
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          labelText: 'Berat Badan',
                          controller: weightController,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          labelText: 'Tinggi Badan',
                          controller: heightController,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          text: 'Next',
                          onPressed: () {
                            // Arahkan ke halaman FaceScan
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
