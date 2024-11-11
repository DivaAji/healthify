// import 'package:flutter/material.dart';
// import 'package:healthify/screens/faceScan_screen.dart';
// import 'package:healthify/widgets/button.dart';
// import 'package:healthify/widgets/card.dart';
// import 'package:healthify/widgets/text_field.dart';
// import 'package:healthify/services/auth_services.dart';

// class DataUserForm extends StatelessWidget {
//   final String username;
//   final String password;
//   final String confirmPassword;

//   // Controller untuk data pengguna
//   final TextEditingController genderController = TextEditingController();
//   final TextEditingController weightController = TextEditingController();
//   final TextEditingController heightController = TextEditingController();

//   DataUserForm({
//     required this.username,
//     required this.password,
//     required this.confirmPassword,
//   });

<<<<<<< HEAD
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
                          controller: genderController,
                          labelText: 'Jenis Kelamin', suffixIcon: null,
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          controller: weightController,
                          labelText: 'Berat Badan', suffixIcon: null,
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          controller: heightController,
                          labelText: 'Tinggi Badan', suffixIcon: null,
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          text: 'Next',
                          onPressed: () {
                            // Kirim data ke API untuk proses registrasi
                            final authService = AuthService();
                            authService.registerUser(
                              username: username,
                              email:
                                  '', // Anda bisa menambahkan field email jika dibutuhkan
                              password: password,
                              confirmPassword: confirmPassword,
                              gender: genderController.text,
                              weight: weightController.text,
                              height: heightController.text,
                              age: '', // Tambahkan usia jika diperlukan
                            );
=======
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           SizedBox.expand(
//             child: Image.asset(
//               'assets/images/login_background.jpg',
//               fit: BoxFit.cover,
//             ),
//           ),
//           Center(
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: EdgeInsets.only(
//                     top: MediaQuery.of(context).size.height * 0.3),
//                 child: MyCard(
//                   child: Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           'Lengkapi Data Diri',
//                           style: TextStyle(
//                             fontFamily: 'Galatea',
//                             fontSize: 24,
//                             fontWeight: FontWeight.w700,
//                             color: Color.fromRGBO(33, 50, 75, 1),
//                             shadows: [
//                               Shadow(
//                                 color: Colors.black.withOpacity(0.25),
//                                 offset: Offset(0, 4),
//                                 blurRadius: 4,
//                               ),
//                             ],
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                         const SizedBox(height: 13),
//                         const Text(
//                           'Lengkapi data berikut dan bantu kami menyesuaikan program anda!',
//                           style: TextStyle(
//                             fontSize: 14.5,
//                             fontWeight: FontWeight.w400,
//                             color: Color.fromRGBO(33, 50, 75, 1),
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                         const SizedBox(height: 15),
//                         CustomTextField(
//                           controller: genderController,
//                           labelText: 'Jenis Kelamin',
//                         ),
//                         const SizedBox(height: 15),
//                         CustomTextField(
//                           controller: weightController,
//                           labelText: 'Berat Badan',
//                         ),
//                         const SizedBox(height: 15),
//                         CustomTextField(
//                           controller: heightController,
//                           labelText: 'Tinggi Badan',
//                         ),
//                         const SizedBox(height: 20),
//                         CustomButton(
//                           text: 'Next',
//                           onPressed: () {
//                             // Kirim data ke API untuk proses registrasi
//                             final authService = AuthService();
//                             authService.registerUser(
//                               username: username,
//                               email:
//                                   '', // Anda bisa menambahkan field email jika dibutuhkan
//                               password: password,
//                               confirmPassword: confirmPassword,
//                               gender: genderController.text,
//                               weight: weightController.text,
//                               height: heightController.text,
//                               age: '', // Tambahkan usia jika diperlukan
//                             );
>>>>>>> cb12d56cb5780946e27ea91020fe7d02b37777b3

//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => const FaceScan(),
//                               ),
//                             );
//                           },
//                           horizontalPadding: 50.0,
//                           verticalPadding: 10.0,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
