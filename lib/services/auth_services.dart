import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  Future<void> registerUser({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
    required String gender,
    required String weight,
    required String height,
    required String age,
  }) async {
    final url = Uri.parse(
        'http://192.168.56.239:8000/api/register'); // Ganti dengan URL API backend Anda

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'username': username,
        'email': email,
        'password': password,
        'password_confirmation': confirmPassword,
        'gender': gender,
        'weight': weight,
        'height': height,
        'age': age,
      }),
    );

    if (response.statusCode == 201) {
      // Registrasi berhasil
      print('User registered successfully');
    } else {
      // Gagal
      print('Failed to register user: ${response.body}');
    }
  }
}
