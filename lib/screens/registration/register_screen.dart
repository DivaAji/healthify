import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthify/blocs/registration_bloc/registration_bloc.dart';
import 'package:healthify/blocs/registration_bloc/registration_event.dart';
import 'package:healthify/blocs/registration_bloc/registration_state.dart';
import 'package:healthify/widgets/button.dart';
import 'package:healthify/widgets/card.dart';
import 'package:healthify/widgets/text_field.dart';
import 'package:healthify/widgets/dropdown_button.dart';
import 'package:healthify/screens/registration/faceScan_screen.dart';

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
  final TextEditingController emailController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController ageRangeController = TextEditingController();

  final FocusNode passwordFocusNode = FocusNode();

  bool isPasswordMatched = true;
  bool isPasswordLengthValid = true;
  bool isPasswordFocused = false;

  String selectedGender = '';
  String ageInputOption = 'Manual';

  @override
  void initState() {
    super.initState();

    // Add listener to FocusNode
    passwordFocusNode.addListener(() {
      setState(() {
        isPasswordFocused = passwordFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    passwordController.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => RegistrationBloc(),
        child: Stack(
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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Daftar Akun',
                            style: TextStyle(
                              fontFamily: 'Galatea',
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Color.fromRGBO(33, 50, 75, 1),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Bantu kami menyesuaikan program kebugaran yang paling sesuai untuk Anda.',
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.normal,
                              color: Color.fromRGBO(33, 50, 75, 1),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 13),
                          CustomTextField(
                            controller: usernameController,
                            labelText: 'Username',
                            keyboardType: TextInputType.name,
                          ),
                          const SizedBox(height: 15),
                          Stack(
                            children: [
                              CustomTextField(
                                controller: passwordController,
                                labelText: 'Password',
                                obscureText: true,
                                keyboardType: TextInputType.text,
                                validationText: 'Password minimal 8 karakter.',
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          CustomTextField(
                            controller: confirmPasswordController,
                            labelText: 'Konfirmasi Password',
                            obscureText: true,
                            keyboardType: TextInputType.text,
                            isError: !isPasswordMatched,
                          ),
                          const SizedBox(height: 15),
                          CustomTextField(
                            controller: emailController,
                            labelText: 'Email',
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(height: 15),
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
                          BlocConsumer<RegistrationBloc, RegistrationState>(
                            listener: (context, state) {
                              if (state is RegistrationSuccess) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        FaceScan(userId: state.userId),
                                  ),
                                );
                              } else if (state is RegistrationFailure) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(state.message)),
                                );
                              }
                            },
                            builder: (context, state) {
                              if (state is RegistrationInProgress) {
                                return CircularProgressIndicator();
                              }
                              return CustomButton(
                                text: 'Next',
                                onPressed: () {
                                  if (passwordController.text !=
                                      confirmPasswordController.text) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Password dan Konfirmasi Password tidak cocok.'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }
                                  setState(() {
                                    isPasswordMatched =
                                        passwordController.text ==
                                            confirmPasswordController.text;
                                  });

                                  if (!isPasswordMatched) {
                                    return;
                                  }
                                  context.read<RegistrationBloc>().add(
                                        RegisterUserEvent(
                                          username: usernameController.text,
                                          password: passwordController.text,
                                          email: emailController.text,
                                          gender: selectedGender,
                                          weight: weightController.text,
                                          height: heightController.text,
                                          age: ageController.text,
                                          ageRange: ageRangeController.text,
                                        ),
                                      );
                                },
                              );
                            },
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
      ),
    );
  }
}