import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  Future<void> registerUser ({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
    required String gender,
    required String weight,
    required String height,
    required String age,
  }) async {
    final url = Uri.parse('http://192.168.69.94:8000/api/register'); // Ganti dengan URL API backend Anda

    try {
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
        print('User  registered successfully');
        // Optionally return a success message or user data
      } else {
        // Gagal
        final Map<String, dynamic> errorResponse = json.decode(response.body);
        String errorMessage = errorResponse['message'] ?? 'Failed to register user';
        print('Failed to register user: $errorMessage');
        throw Exception(errorMessage); // Throwing exception for better error handling
      }
    } catch (e) {
      // Handle any exceptions that occur during the API call
      print('Error occurred: $e');
      throw Exception('An error occurred while registering the user');
    }
  }
}