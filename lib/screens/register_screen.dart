import 'package:flutter/material.dart';
import 'package:healthify/screens/dataUser_form.dart';
import 'package:healthify/widgets/button.dart';
import 'package:healthify/widgets/card.dart';
import 'package:healthify/widgets/text_field.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(33, 50, 75, 1),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          labelText: 'Username', suffixIcon: null,
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          labelText: 'Password',
                          obscureText: true, suffixIcon: null,
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          labelText: 'Konfirmasi Password',
                          obscureText: true, suffixIcon: null,
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          text: 'Next',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DataUserForm(),
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
