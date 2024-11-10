import 'package:flutter/material.dart';
import 'package:healthify/screens/dataUser_form.dart';
import 'package:healthify/widgets/button.dart';
import 'package:healthify/widgets/card.dart';
import 'package:healthify/widgets/text_field.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

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
                          controller: usernameController,
                          labelText: 'Username',
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          controller: passwordController,
                          labelText: 'Password',
                          obscureText: true,
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          controller: confirmPasswordController,
                          labelText: 'Konfirmasi Password',
                          obscureText: true,
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          text: 'Next',
                          onPressed: () {
                            // Arahkan ke halaman DataUserForm dengan membawa data
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DataUserForm(
                                  username: usernameController.text,
                                  password: passwordController.text,
                                  confirmPassword:
                                      confirmPasswordController.text,
                                ),
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
