import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import Flutter Bloc package
import 'package:healthify/screens/welcome/splash_screen.dart';
import 'package:healthify/screens/login/login_screen.dart';
import 'package:healthify/screens/registration/register_screen.dart'; // Import RegisterScreen
import 'package:healthify/blocs/registration_bloc/registration_bloc.dart'; // Import the RegistrationBloc

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Galatea',
      ),
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => BlocProvider(
              create: (context) => RegistrationBloc(),
              child: const RegisterScreen(),
            ),
      },
    );
  }
}
